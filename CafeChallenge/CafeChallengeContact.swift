//
//  CafeChallengeContact.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-06.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CafeChallengeContact: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Update the contact object with information for contact
    func updateWithDictionary(infoDict: Dictionary<String, String>, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        // set the value for each key from the passed information
        for (contactKey, contactValue) in infoDict {
            self.setValue(contactValue, forKey: contactKey)
        }
        if managedObjectContext.hasChanges {
            saveContext(managedObjectContext)
        }
    }
    
    // Delete self
    func deleteSelf(context: NSManagedObjectContext) {
        context.deleteObject(self)
        saveContext(context)
    }
    
    // Save context after create/edit, delete
    func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
