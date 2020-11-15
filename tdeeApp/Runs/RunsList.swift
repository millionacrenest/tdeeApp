//
//  RunsList.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/12/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct RunsList: View {
    
    
    @State var workouts = [HKWorkout]()
    
    var body: some View {
        VStack {
           List(workouts) { workout in
            NavigationLink(destination: RunsDetailView(workoutItem: workout)) {
                RunsRow(workoutItem: workout)
                }
//
            }
        }
    .onAppear {
            getRunningWorkouts()
        }
    }
    
    func getRunningWorkouts() {
        
        let healthStore = HKHealthStore()

        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
           
           let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
           
           let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
               { (sampleQuery, results, error ) -> Void in

                   if let queryError = error {
                       print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                   }
            
        
            workouts = results as! [HKWorkout]
            
           }
        
        healthStore.execute(sampleQuery)
        
    }
}

struct RunsList_Previews: PreviewProvider {
    static var previews: some View {
        RunsList()
    }
}

extension HKWorkout: Identifiable {
    public var id: UUID {
        return UUID()
    }

}
