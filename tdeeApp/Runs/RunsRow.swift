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
    
    var workoutItem: RunLogged
    
    var body: some View {
        VStack {
            Text("Run completed: \(workoutItem.dateRun)")
            Spacer()
            Text("Total Distance: \(workoutItem.distance ?? "")")
//            Text("Duration: \(workoutItem.)")
//            Text("Calories Burned: \(workoutItem.totalEnergyBurned!)")
            Text("UUID \(workoutItem.runUUID?.uuidString ?? "0")")
        }
    }
    
}


