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
            RunMapView()
            VStack {
                Text("Run completed: \(workoutItem.dateRun ?? Date())")
                Spacer()
                Text("Total Distance: \(workoutItem.distance ?? "")")
    //            Text("Duration: \(workoutItem.)")
    //            Text("Calories Burned: \(workoutItem.totalEnergyBurned!)")
                Text("Coordinates \(workoutItem.routeCoordinates?.debugDescription ?? "MAPQUEST")")
            }
        }
    }
    
}


