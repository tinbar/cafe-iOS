//
//  ContactTableViewController.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-06.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import MBProgressHUD

class ContactTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // Button to pull and add a random user from randomuser.me
    @IBOutlet weak var addRandomContactButton: UIBarButtonItem!
    
    // Button to navigate to view controller for adding contact
    @IBOutlet weak var addCustomContactButton: UIBarButtonItem!
    
    // Button for logging in with account for web app sync
    // var loginButton: UIBarButtonItem!
    
    // Button to sync contacts after login
    // var syncButton: UIBarButtonItem!
    
    // Managed Object Context that will be used to create, edit, save, and delete contacts
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set edit button to allow user to delete item
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Set the title
        self.title = "Contacts"
        
        // Set the footer to zero to remove extra lines from table view
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Reload the table after navigating back from edit contact view controller
        // Should actually be set as a delegate so we know specifically when we are
        // returning to this controller from an edit controller.
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Use section count from fetched results controller
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get number of rows in section from fetched results controller
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell identifier set in storyboard because it was basic cell.
        // A more custom cell could be subclassed and set in storyboard or set in 
        // view did load programmatically.
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
        
        // Send cell object and index path to helper method
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    // Helper function that sets the cell's labels with full name and phone number
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        // Get contact object
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
        
        // Set main label text
        cell.textLabel!.text = "\(object.valueForKey("first_name")!.description) \(object.valueForKey("last_name")!)"
        
        // Set sub label text
        cell.detailTextLabel!.text = object.valueForKey("phone_number")!.description
        
        // Specify cell accessory to inform user that cell can be pressed for further
        // interaction
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Let user edit all items
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let contact = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CafeChallengeContact
            contact.deleteSelf(self.managedObjectContext)
            // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Not all segues have identifiers, so first check if identifier exists
        if let segueID = segue.identifier {
            switch segueID {
            // Identifier set in storyboard
            case "editContactSegue":
                // Get index path of row that triggered segue
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                // Get corresponding contact object
                let contact = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CafeChallengeContact
                
                // Get edit view controller (destination)
                let editContactViewController = segue.destinationViewController as! EditContactTableViewController
                
                // Prepare the controller with the contact object for editing
                editContactViewController.prepareContactFromSegue(contact)
            default:
                break
            }
        }
    }
    
    // MARK: - IBActions
    
    // Button for inserting random contact
    @IBAction func randomButtonTapped(sender: UIBarButtonItem) {
        insertRandomContact()
    }
    
    // Method that fetches, parses and inserts contact made from randomuser.me
    func insertRandomContact() {
        // Remove view if being pressed while previous fetch is taking place
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        // Add loading bar
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Fetching random user ... "
        
        // Make JSON request, parse data and insert contact
        Alamofire.request(.GET, "https://randomuser.me/api/")
            .responseJSON { response in switch response.result {
            case .Success(let JSON):
                // On success, parse JSON data to get desired fields
                let response = JSON as! NSDictionary
                let results = response.objectForKey("results") as! NSArray
                let user = results.objectAtIndex(0) as! NSDictionary
                let userDict = user.objectForKey("user") as! NSDictionary
                let fullName = userDict.objectForKey("name") as! NSDictionary
                let firstName = fullName.objectForKey("first") as! String
                let lastName = fullName.objectForKey(("last")) as! String
                let email = userDict.objectForKey("email") as! String
                let phoneNumber = userDict.objectForKey("phone") as! String
                
                // Create contact entity description
                let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: self.managedObjectContext)
                // Create contact managed object
                let record = CafeChallengeContact(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
                // Set information for new contact
                let infoDict: [String : String] = [
                    "first_name":firstName,
                    "last_name":lastName,
                    "email":email,
                    "phone_number":phoneNumber
                ]
                // Update the contact with new information and save contact
                record .updateWithDictionary(infoDict, inManagedObjectContext: self.managedObjectContext)
                
            case .Failure(let error):
                print("Error: \(error)")
            }
            // Remove progressbar
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }

    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // Sort the contacts by first name
        let sortDescriptor = NSSortDescriptor(key: "first_name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

}
