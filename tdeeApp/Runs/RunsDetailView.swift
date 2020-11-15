//
//  RunsDetailView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/13/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct RunsDetailView: View {
    
    var workoutItem: HKWorkout
    
    var body: some View {
        VStack {
            Text("Run completed: \(workoutItem.endDate)")
            Spacer()
            Text("Total Distance: \(workoutItem.totalDistance!)")
            Text("Duration: \(workoutItem.duration)")
            Text("Calories Burned: \(workoutItem.totalEnergyBurned!)")
        }
    }
}

