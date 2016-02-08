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
    
    var contact: CafeChallengeContact?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let contactDict = [
        "first_name":"testFirst",
        "last_name":"testLast",
        "email":"testEmail",
        "phone_number":"0123456789"
    ]
    
    let updateContactDict = [
        "first_name":"testFirstUpdate",
        "last_name":"testLastUpdate",
        "email":"testEmailUpdate",
        "phone_number":"0123456789876543210"
    ]
    
    let contactDictBadInfo = [
        "first_name":3,
        "last_name":true,
        "email":false,
        "phone_number":[]
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let contactEntity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: managedObjectContext)
        contact = CafeChallengeContact.init(entity: contactEntity!, insertIntoManagedObjectContext: managedObjectContext)
        contact?.updateWithDictionary(contactDict, inManagedObjectContext: managedObjectContext)
    }
    
    func testContext() {
        XCTAssertNotNil(managedObjectContext, "Bad context")
    }
    
    func testContactExists() {
        XCTAssertNotNil(contact, "Contact does not exist")
    }
    
    func testContactFirstName() {
        XCTAssertNotNil(contact?.first_name, "Contact has no first name")
        XCTAssertEqual(contact?.first_name, "testFirst", "Incorrect first name")
    }
    
    func testContactLastName() {
        XCTAssertNotNil(contact?.last_name, "Contact has no last name")
        XCTAssertEqual(contact?.last_name, "testLast", "Incorrect last name")
    }
    
    func testContactEmail() {
        XCTAssertNotNil(contact?.email, "Contact has no email")
        XCTAssertEqual(contact?.email, "testEmail", "Incorrect email")
    }
    
    func testPhoneNumber() {
        XCTAssertNotNil(contact?.phone_number, "Contact has no phone number")
        XCTAssertEqual(contact?.phone_number, "0123456789", "Incorrect phone number")
    }
    
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
