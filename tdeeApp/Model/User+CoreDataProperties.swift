//
//  User+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/4/20.
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

}

extension User : Identifiable {

}
