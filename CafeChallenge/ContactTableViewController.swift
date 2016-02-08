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
    
    @IBOutlet weak var addRandomContactButton: UIBarButtonItem!
    @IBOutlet weak var addCustomContactButton: UIBarButtonItem!
    var loginButton: UIBarButtonItem!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.loginButton = UIBarButtonItem.init(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButtonTapped:")
        
        // Set the title
        self.title = "Contacts"
        // Set the footer to zero to remove extra lines from table view
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        // self.navigationItem.rightBarButtonItem = nil
        // self.navigationItem.leftBarButtonItem = self.loginButton
        }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        /*
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Contact", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            for object in result {
                let contact = object as! CafeChallengeContact
                print(contact.first_name)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
        cell.textLabel!.text = "\(object.valueForKey("first_name")!.description) \(object.valueForKey("last_name")!)"
        cell.detailTextLabel!.text = object.valueForKey("phone_number")!.description
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        /*
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        */
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueID = segue.identifier {
            switch segueID {
            case "editContactSegue":
                let indexPath = self.tableView.indexPathForSelectedRow!
                let contact = self.fetchedResultsController.objectAtIndexPath(indexPath) as! CafeChallengeContact
                let editContactViewController = segue.destinationViewController as! EditContactTableViewController
                editContactViewController.prepareContactFromSegue(contact)
            default:
                break
            }
        }
    }
    
    
    // MARK: - Button Selectors
    func loginButtonTapped(sender: UIBarButtonItem) {
    }
    
    // MARK: - IBActions
    
    @IBAction func randomButtonTapped(sender: UIBarButtonItem) {
        insertRandomContact()
    }
    
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
                let response = JSON as! NSDictionary
                let results = response.objectForKey("results") as! NSArray
                let user = results.objectAtIndex(0) as! NSDictionary
                let userDict = user.objectForKey("user") as! NSDictionary
                let fullName = userDict.objectForKey("name") as! NSDictionary
                let firstName = fullName.objectForKey("first") as! String
                let lastName = fullName.objectForKey(("last")) as! String
                let email = userDict.objectForKey("email") as! String
                let phoneNumber = userDict.objectForKey("phone") as! String
                
                let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: self.managedObjectContext)
                let record = CafeChallengeContact(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
                let infoDict: [String : String] = [
                    "first_name":firstName,
                    "last_name":lastName,
                    "email":email,
                    "phone_number":phoneNumber
                ]
                record .updateWithDictionary(infoDict, inManagedObjectContext: self.managedObjectContext)
                
            case .Failure(let error):
                print("Error: \(error)")
            }
            // Remove progressbar
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }

    }
    
    @IBAction func customButtonTapped(sender: UIBarButtonItem) {
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "first_name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
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
