//
//  RunLogged+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/17/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension RunLogged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunLogged> {
        return NSFetchRequest<RunLogged>(entityName: "RunLogged")
    }

    @NSManaged public var dateRun: String?
    @NSManaged public var runDescription: String?
    @NSManaged public var runImage: Data?
    @NSManaged public var runUUID: UUID?
    @NSManaged public var distance: String?
    @NSManaged public var caloriesBurned: String?

}

extension RunLogged : Identifiable {

}
