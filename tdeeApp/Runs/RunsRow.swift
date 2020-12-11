//
//  RunsRow.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/12/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit
import MapKit

struct RunsRow: View {
    
    var workoutItem: RunLogged
    
    var body: some View {
        HStack {
            RunMapView(workoutItem: workoutItem)
            RunsRowView {
                Text("\(workoutItem.dateRun ?? Date())")
                Text("Total Distance: \(workoutItem.distance ?? "")")
                Text("Calories Burned: \(workoutItem.caloriesBurned ?? "")")
            }
        }
    }
    
}

struct RunsRowView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
        content
            .padding()
            .cornerRadius(16)
            .transition(.move(edge: .top))
            .animation(.spring())
            .background(Color(.tertiarySystemBackground))
         
        }
        
    }
}


