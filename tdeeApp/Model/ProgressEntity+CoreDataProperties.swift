//
//  ProgressEntity+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/21/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension ProgressEntity: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressEntity> {
        return NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var pounds: String?

}
