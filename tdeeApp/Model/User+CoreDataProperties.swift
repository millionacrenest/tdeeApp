//
//  User+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/11/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var goalWeight: String?
    @NSManaged public var currentWeight: String?
    @NSManaged public var shoeMaxMiles: Int16
    @NSManaged public var userID: UUID?
    @NSManaged public var dateMilesLastSet: Date?

}

extension User : Identifiable {

}
