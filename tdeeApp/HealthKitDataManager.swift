//
//  HealthKitDataManager.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/7/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import HealthKit
import SwiftUI
import CoreData
import MapKit

class HealthKitDataManager {
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    
    @FetchRequest(
        entity: RunLogged.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \RunLogged.dateRun, ascending: false)
        ]
    ) var workoutItems: FetchedResults<RunLogged>
    
    static let healthStore = HKHealthStore()
    
    class func getRunningWorkouts() {

        var workouts = [HKWorkout]()
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
           
           let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
           
           let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
               { (sampleQuery, results, error ) -> Void in

                   if let queryError = error {
                       print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                   }
            
            let endDate = Date()
            let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 168.0)
            var miles = [Double]()
            
            workouts = results as? [HKWorkout] ?? [HKWorkout]()
            
                for workout in workouts {
                    
                    //let coordinates = self.getRunningWorkoutRoute(workoutItem: workout)
                    print("workoutUUID ", workout.uuid)
                
                    //self.saveRunToCoreData(workoutItem: workout, routeCoordinates: coordinates)
                }
                for workout in workouts.prefix(7) {
                    
                    if workout.endDate > startDate {
                        miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                    }
                }
            
            
            let averageOfMiles = miles.reduce(0, +)
           // self.miles = String(averageOfMiles/7)
            let runnersBonus = (averageOfMiles/7) * 100
           // self.runnersBonus = String(format: "%.0f", runnersBonus)
            
           }
        
        healthStore.execute(sampleQuery)
        
    }
    
    class func getRunningWorkoutRoute(workoutItem: HKWorkout) -> [CLLocationCoordinate2D] {
        var routeCoordinates = [CLLocationCoordinate2D]() {
            didSet {
                print(routeCoordinates)
            }
        }
        
        let runningObjectQuery = HKQuery.predicateForObjects(from: workoutItem)
        
       
        
        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The initial query failed.")
            }
            if let route = samples?.first as? HKWorkoutRoute {
                self.getRouteData(route: route, workoutItem: workoutItem)
            }
            
           
        }

        routeQuery.updateHandler = { (query, samples, deleted, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The update failed.")
            }
            
            // Process updates or additions here.
            //print("updated samples: ", samples?.first?.sampleType ?? [HKSample]())
            
            
        }

        healthStore.execute(routeQuery)
        return routeCoordinates
        
    }
    
    class func getRouteData(route: HKWorkoutRoute, workoutItem: HKWorkout) {
        var locationCoordinates = [CLLocationCoordinate2D]()
        // Create the route query.
        let query = HKWorkoutRouteQuery(route: route) { (query, locationsOrNil, done, errorOrNil) in
            
            // This block may be called multiple times.
            
            if let error = errorOrNil {
                // Handle any errors here.
                return
            }
            
            guard let locations = locationsOrNil else {
                fatalError("*** Invalid State: This can only fail if there was an error. ***")
            }
            
            // Do something with this batch of location data.
                
            if done {
                // The query returned all the location data associated with the route.
                // Do something with the complete data set.
                
                for location in locations {
                    locationCoordinates.append(location.coordinate)
                }
                
                //save workout and route to core data

            // You can stop the query by calling:
            // store.stop(query)
            
            }
            healthStore.execute(query)
        }
    }
    
    


    
    
   

}
