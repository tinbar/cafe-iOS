//
//  EditContactTableViewController.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-06.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//

import UIKit

class EditContactTableViewController: UITableViewController, UITextFieldDelegate {
    
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    var emailTextField: UITextField!
    var phoneNumberTextField: UITextField!
    
    var doneButton: UIBarButtonItem!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Edit/Insert Contact"
        self.doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTapped:")
        self.navigationItem.rightBarButtonItem = self.doneButton
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        self.firstNameTextField = UITextField()
        self.firstNameTextField.delegate = self
        self.firstNameTextField.placeholder = "Ex: John"
        
        self.lastNameTextField = UITextField()
        self.lastNameTextField.delegate = self
        self.lastNameTextField.placeholder = "Ex: Smith"
        
        self.emailTextField = UITextField()
        self.emailTextField.keyboardType = .EmailAddress
        self.emailTextField.delegate = self
        self.emailTextField.placeholder = "Ex: john.smith@iOS.com"
        
        self.phoneNumberTextField = UITextField()
        self.phoneNumberTextField.keyboardType = .DecimalPad
        self.phoneNumberTextField.delegate = self
        self.phoneNumberTextField.placeholder = "Ex: 0123456789"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["First Name", "Last Name", "Email", "Phone Number"][section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        //cell.textLabel!.text = "Text"
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        switch indexPath.section {
        case 0:
            self.firstNameTextField.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 40, cell.contentView.frame.size.height)
            cell.contentView.addSubview(self.firstNameTextField)
        case 1:
            self.lastNameTextField.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 40, cell.contentView.frame.size.height)
            cell.contentView.addSubview(self.lastNameTextField)
        case 2:
            self.emailTextField.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 40, cell.contentView.frame.size.height)
            cell.contentView.addSubview(self.emailTextField)
        case 3:
            self.phoneNumberTextField.frame = CGRectMake(20, 0, cell.contentView.frame.size.width - 40, cell.contentView.frame.size.height)
            cell.contentView.addSubview(self.phoneNumberTextField)
        default:
            print("default")
        }
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
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Button Selectors
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        // verify valid data
        if verifyTextFieldData() {
            // save data
        }
        // finally, pop back to root
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Helpers
    
    func verifyTextFieldData() -> Bool {
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let email = self.emailTextField.text!
        let phoneNumber = self.phoneNumberTextField.text!
        if firstName.characters.count > 0 && lastName.characters.count > 0 && email.characters.count > 0 && phoneNumber.characters.count > 0 {
            return true
        }
        return false
    }
}
