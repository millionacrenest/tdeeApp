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
    

    @State private var intervalToShow: String?
    @State private var distanceToShow: String?
    @State private var caloriesBurned: String?
   
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Run completed in \(intervalToShow ?? "")")
                Text("Run distance: \(distanceToShow ?? "") miles")
                Text("Run calories: \(caloriesBurned ?? "")")
                
            }.onAppear {
                intervalToShow = formatRunTime(interval: workoutItem.duration)
                distanceToShow = String(format: "%.0f", workoutItem.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                caloriesBurned = String(format: "%.0f", workoutItem.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()) ?? 0)
            }
        }
    }
    
    func formatRunTime(interval: TimeInterval) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        
        return formatter.string(from: TimeInterval(interval))!
    }
    
    
}

