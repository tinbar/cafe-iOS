//
//  EditContactTableViewController.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-06.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//

import UIKit
import CoreData

class EditContactTableViewController: UITableViewController, UITextFieldDelegate {
    
    // Text Field for contact's first name
    var firstNameTextField: UITextField!
    
    // Text Field for contact's last name
    var lastNameTextField: UITextField!
    
    // Text Field for contact's email address
    var emailTextField: UITextField!
    
    // Text Field for contact's phone number
    var phoneNumberTextField: UITextField!
    
    // Contact for editing if in edit mode, otherwise this is nil for a new contact
    var editContact: CafeChallengeContact!
    
    // Button to commit changes for contact
    var doneButton: UIBarButtonItem!
    
    // Managed Object Context that will be used to create, edit, save, and delete contacts
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap Gesture for dismissing keyboard when user touches screen not occupied
        // by the keyboard when it is active
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Create and set the done button's action target to self
        self.doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTapped:")
        
        // Add the done button to the right corner of the navigation bar
        self.navigationItem.rightBarButtonItem = self.doneButton
        
        // Register identifier for reusable cell
        // Note that this table is set to the grouped style in the storyboard
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        
        // Initialize and configure the text fields for the contact
        
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
        
        // if edit contact is set
        if (editContact != nil) {
            self.title = "Edit Contact"
            self.firstNameTextField.text = editContact.first_name!
            self.lastNameTextField.text = editContact.last_name
            self.emailTextField.text = editContact.email
            self.phoneNumberTextField.text = editContact.phone_number
        }
        // if new contact
        else {
            self.title = "Insert Contact"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Static table with four sections.
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // For simplicity the array is passed directly, but this should be a var that
        // can be changed as the app adds more functionality
        return ["First Name", "Last Name", "Email", "Phone Number"][section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Row for text field
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Remove any sub views to ensure objects aren't added multiple times
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        // Add correct text field to correct table row with a horizontal padding of 20
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
            break
        }
        return cell
    }
    
    // MARK: - UITextField Delegate
    
    // Dismiss keyboard when user presses enter/return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    // Dismiss keyboard when user taps screen not occupied by keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Button Selectors
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        
        // verify valid data
        if verifyTextFieldData() {
            
            // Create contact entity description
            let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: self.managedObjectContext)
            
            // Contact to be updated
            var contact: CafeChallengeContact
            
            // Set update contact as contact set for editing if not nil
            if editContact != nil {
                contact = editContact
            }
            // Otherwise create a new contact
            else {
                contact = CafeChallengeContact(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
            }
            
            // Set dictionary with information for contact from text fields
            let infoDict: [String : String] = [
                "first_name":self.firstNameTextField.text!,
                "last_name":self.lastNameTextField.text!,
                "email":self.emailTextField.text!,
                "phone_number":self.phoneNumberTextField.text!
            ]
            
            // Update and save contact
            contact.updateWithDictionary(infoDict, inManagedObjectContext: self.managedObjectContext)
        }
        // finally, pop back to root
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Helpers
    
    func verifyTextFieldData() -> Bool {
        // For now simply check that all fields have something in them
        // A more thorough validation with regular expressions should be done
        let firstName = self.firstNameTextField.text!
        let lastName = self.lastNameTextField.text!
        let email = self.emailTextField.text!
        let phoneNumber = self.phoneNumberTextField.text!
        if firstName.characters.count > 0 && lastName.characters.count > 0 && email.characters.count > 0 && phoneNumber.characters.count > 0 {
            return true
        }
        return false
    }
    
    // Function to be called just before edit view controller is about to be loaded
    func prepareContactFromSegue(contact: CafeChallengeContact) {
        // Set contact for editing
        self.editContact = contact
    }
}
