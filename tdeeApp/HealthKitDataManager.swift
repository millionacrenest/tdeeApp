//
//  HealthKitDataManager.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/7/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import HealthKit
import SwiftUI
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
    
    let healthStore = HKHealthStore()
    
    func getBMI() {
        let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)

        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = Date(timeIntervalSince1970: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        // Create the HealthKit Query
        let query = HKSampleQuery(
            sampleType: bodyMassIndexType!,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor],
            resultsHandler: updateBMIData
        )
        // Execute our query
        healthStore.execute(query)
    }
    
    func updateBMIData(query: HKSampleQuery, results: [HKSample]?, error: Error?) {
        
        if let currData = results?.first as? HKQuantitySample {
            print("BMI IS ", String(currData.quantity.doubleValue(for: .count())))
           // saveHealthKitBMIDataToUserEntity(bmiString: String(currData.quantity.doubleValue(for: .count())))
           // saveBMIToCoreData(bmiString: String(currData.quantity.doubleValue(for: .count())))
        }
        
    }
    
    func getWeight() {
        let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)

        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = Date(timeIntervalSince1970: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        // Create the HealthKit Query
        let query = HKSampleQuery(
            sampleType: bodyMassType!,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor],
            resultsHandler: updateWeightData
        )
        // Execute our query
        healthStore.execute(query)
        
        
    }

    func updateWeightData(query: HKSampleQuery, results: [HKSample]?, error: Error?) {
        
        let currData = results?.first as? HKQuantitySample
        
        let weightInKilograms = Measurement(value: currData?.quantity.doubleValue(for: .gramUnit(with: .kilo)) ?? 0, unit: UnitMass.kilograms)
        let weightString = "\(weightInKilograms.converted(to: .pounds))"
        print("weight is \(weightString)")
       // saveWeightToCoreData(weightString: String(weightString.prefix(3)))
       // saveHealthKitWeightDataToUserEntity(weightString: String(weightString.prefix(3)))
        
    }
    
    func getRunningWorkouts() {
        getBMI()
        getWeight()
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
                        self.getRunningWorkoutRoute(workoutItem: workout)
                    
                    
                    
                }
                for workout in workouts.prefix(7) {
                    
                    if workout.endDate > startDate {
                        miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                    }
                }
            
            
            let averageOfMiles = miles.reduce(0, +)
            let currentAverageMiles = String(averageOfMiles/7).prefix(3)
            let runnersBonus = (averageOfMiles/7) * 100
            let currentRunnersBonus = String(format: "%.0f", runnersBonus)
           // saveCurrentMilesAndBonusToCoreData(miles: String(currentAverageMiles), bonus: currentRunnersBonus)
           }
        
        healthStore.execute(sampleQuery)
        
    }
    
    func getRunningWorkoutRoute(workoutItem: HKWorkout) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: workoutItem)
        
        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The initial query failed.")
            }
            if let route = samples?.first as? HKWorkoutRoute {
                print("route", route)
                print("workout item", workoutItem.uuid)
                self.getRouteData(route: route, workoutItem: workoutItem)
                
            }
            
           
        }

        routeQuery.updateHandler = { (query, samples, deleted, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The update failed.")
            }
            
            // Process updates or additions here.
            print("updated samples: ", samples?.first?.sampleType ?? [HKSample]())
            
        }

        healthStore.execute(routeQuery)
        
    }
    
    func getRouteData(route: HKWorkoutRoute, workoutItem: HKWorkout) {
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
        //self.saveRunToCoreData(workoutItem: workoutItem, coordinates: locationCoordinates)
                print(locationCoordinates)
            }
            
            
        }
        healthStore.execute(query)
    }
    
    


    
    
   

}
