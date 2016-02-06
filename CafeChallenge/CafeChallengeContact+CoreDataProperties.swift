//
//  CafeChallengeContact+CoreDataProperties.swift
//  CafeChallenge
//
//  Created by Atindra Ganeshen on 2016-02-06.
//  Copyright © 2016 Atindra Ganeshen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CafeChallengeContact {

    @NSManaged var email: String?
    @NSManaged var first_name: String?
    @NSManaged var last_name: String?
    @NSManaged var phone_number: String?

}
