//
//  RunLogged+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/16/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension RunLogged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunLogged> {
        return NSFetchRequest<RunLogged>(entityName: "RunLogged")
    }

    @NSManaged public var runImage: Data?
    @NSManaged public var runUUID: UUID?
    @NSManaged public var dateRun: String?
    @NSManaged public var runDescription: String?

}

extension RunLogged : Identifiable {

}
