//
//  LocationPoint+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/8/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationPoint> {
        return NSFetchRequest<LocationPoint>(entityName: "LocationPoint")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var pointUUID: UUID?
    @NSManaged public var runUUID: UUID?
    @NSManaged public var origin: RunLogged?
    
    public var wrappedUUID: String {
        runUUID?.uuidString ?? "Unknown Location"
    }

}

extension LocationPoint : Identifiable {

}
