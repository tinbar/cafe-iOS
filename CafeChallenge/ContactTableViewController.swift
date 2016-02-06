//
//  ContactTableViewController.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-06.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    @IBOutlet weak var addRandomContactButton: UIBarButtonItem!
    @IBOutlet weak var addCustomContactButton: UIBarButtonItem!
    var loginButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.loginButton = UIBarButtonItem.init(title: "Login", style: UIBarButtonItemStyle.Plain, target: self, action: "loginButtonTapped:")
        
        // Set the title
        self.title = "Contacts"
        // Set the footer to zero to remove extra lines from table view
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
        // self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = self.loginButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCellIdentifier", forIndexPath: indexPath)
        cell.textLabel!.text = "Jim"
        cell.detailTextLabel!.text = "bob"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Selectors
    func loginButtonTapped(sender: UIBarButtonItem) {
        print("login button tapped")
    }
    
    // MARK: - IBActions
    
    @IBAction func randomButtonTapped(sender: UIBarButtonItem) {
        print("pressed")
    }
    
    @IBAction func customButtonTapped(sender: UIBarButtonItem) {
        print("custom pressed")
    }

}
