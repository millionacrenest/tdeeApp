//
//  RunsRow.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/12/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct RunsRow: View {
    
    var workoutItem: HKWorkout
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        VStack {
            Text("Run completed: \(workoutItem.endDate)")
            Spacer()
            Text("Total Distance: \(workoutItem.totalDistance!)")
            Text("Duration: \(workoutItem.duration)")
            Text("Calories Burned: \(workoutItem.totalEnergyBurned!)")
        }.onAppear {
            saveToCoreData()
        }
    }
    
    func saveToCoreData() {
        
        let runLogged = RunLogged(context: managedObjectContext)
        runLogged.runUUID = UUID()
        runLogged.dateRun = "\(workoutItem.endDate)"
        runLogged.caloriesBurned = String(format: "%.0f", workoutItem.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()) ?? 0)
        runLogged.distance = String(format: "%.0f", workoutItem.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
       
        
        //let data = image.jpegData(compressionQuality: 1.0)
     //   runLogged.runUUID = workoutItem
        
        // save image
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
}


