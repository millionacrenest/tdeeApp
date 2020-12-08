//
//  RunLogged+CoreDataProperties.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/8/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension RunLogged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RunLogged> {
        return NSFetchRequest<RunLogged>(entityName: "RunLogged")
    }

    @NSManaged public var caloriesBurned: String?
    @NSManaged public var dateRun: Date?
    @NSManaged public var distance: String?
    @NSManaged public var duration: String?
    @NSManaged public var runDescription: String?
    @NSManaged public var runImage: Data?
    @NSManaged public var runUUID: UUID?
    @NSManaged public var locationPoint: NSSet?
    
    public var locationPointArray: [LocationPoint] {
        let set = locationPoint as? Set<LocationPoint> ?? []
        return set.sorted {
            $0.wrappedUUID < $1.wrappedUUID
        }
    }
    
    public var coreLocationArray: [CLLocationCoordinate2D] {
        let array = locationPointArray
        var locations = [CLLocationCoordinate2D]()
        for item in array {
            locations.append(CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
        }
        
        return locations
        
    }

}

// MARK: Generated accessors for locationPoint
extension RunLogged {

    @objc(addLocationPointObject:)
    @NSManaged public func addToLocationPoint(_ value: LocationPoint)

    @objc(removeLocationPointObject:)
    @NSManaged public func removeFromLocationPoint(_ value: LocationPoint)

    @objc(addLocationPoint:)
    @NSManaged public func addToLocationPoint(_ values: NSSet)

    @objc(removeLocationPoint:)
    @NSManaged public func removeFromLocationPoint(_ values: NSSet)

}

extension RunLogged : Identifiable {

}
