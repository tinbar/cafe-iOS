//
//  ContactTests.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-07.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//

import XCTest
import CoreData
import UIKit
@testable import CafeChallenge


class ContactTests: XCTestCase {
    
    // Contact object to be tested
    var contact: CafeChallengeContact?
    
    // Managed Object Context to test the contact object with
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Initial contact information dictionary for new contact
    let contactDict = [
        "first_name":"testFirst",
        "last_name":"testLast",
        "email":"testEmail",
        "phone_number":"0123456789"
    ]
    
    // Update contact information dictionary for editing contact
    let updateContactDict = [
        "first_name":"testFirstUpdate",
        "last_name":"testLastUpdate",
        "email":"testEmailUpdate",
        "phone_number":"0123456789876543210"
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // Contact entity description
        let contactEntity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
        // Create new contact object
        contact = CafeChallengeContact.init(entity: contactEntity!, insertIntoManagedObjectContext: managedObjectContext)
        // Update the contact with initial information
        contact?.updateWithDictionary(contactDict, inManagedObjectContext: managedObjectContext)
    }
    
    // Test that the context exists
    func testContext() {
        XCTAssertNotNil(managedObjectContext, "Bad context")
    }
    
    // Test that the contact object exists
    func testContactExists() {
        XCTAssertNotNil(contact, "Contact does not exist")
    }
    
    // Test the contact's first name field
    func testContactFirstName() {
        XCTAssertNotNil(contact?.first_name, "Contact has no first name")
        XCTAssertEqual(contact?.first_name, "testFirst", "Incorrect first name")
    }
    
    // Test the contact's last name field
    func testContactLastName() {
        XCTAssertNotNil(contact?.last_name, "Contact has no last name")
        XCTAssertEqual(contact?.last_name, "testLast", "Incorrect last name")
    }
    
    // Test the contact's email field
    func testContactEmail() {
        XCTAssertNotNil(contact?.email, "Contact has no email")
        XCTAssertEqual(contact?.email, "testEmail", "Incorrect email")
    }
    
    // Test the contact's phone number field
    func testPhoneNumber() {
        XCTAssertNotNil(contact?.phone_number, "Contact has no phone number")
        XCTAssertEqual(contact?.phone_number, "0123456789", "Incorrect phone number")
    }
    
    // Edit and test the updated contact
    func testEditAndUpdateContact() {
        contact?.updateWithDictionary(updateContactDict, inManagedObjectContext: managedObjectContext)
        XCTAssertNotNil(contact?.first_name, "Contact has no first name")
        XCTAssertEqual(contact?.first_name, "testFirstUpdate", "Incorrect first name")
        XCTAssertNotNil(contact?.last_name, "Contact has no last name")
        XCTAssertEqual(contact?.last_name, "testLastUpdate", "Incorrect last name")
        XCTAssertNotNil(contact?.email, "Contact has no email")
        XCTAssertEqual(contact?.email, "testEmailUpdate", "Incorrect email")
        XCTAssertNotNil(contact?.phone_number, "Contact has no phone number")
        XCTAssertEqual(contact?.phone_number, "0123456789876543210", "Incorrect phone number")
    }
    
    // Delete and test the contact does not exist
    func testDeleteContact() {
        XCTAssertNotNil(contact?.managedObjectContext, "Context already gone before delete")
        contact?.deleteSelf(managedObjectContext)
        XCTAssertNil(contact?.managedObjectContext, "Context still exists after delete")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
