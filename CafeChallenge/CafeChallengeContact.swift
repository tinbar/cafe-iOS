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
    
    func updateWithDictionary(infoDict: Dictionary<String, String>, inManagedObjectContext managedObjectContext: NSManagedObjectContext) {
        for (contactKey, contactValue) in infoDict {
            self.setValue(contactValue, forKey: contactKey)
        }
        if managedObjectContext.hasChanges {
            saveContext(managedObjectContext)
        }
    }
    
    func deleteSelf(context: NSManagedObjectContext) {
        context.deleteObject(self)
        saveContext(context)
    }
    
    func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
