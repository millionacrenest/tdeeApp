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
    

    
    


    
    
   

}
