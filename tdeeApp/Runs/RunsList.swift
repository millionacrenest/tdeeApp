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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: RunLogged.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \RunLogged.dateRun, ascending: false)
        ]
    ) var workouts: FetchedResults<RunLogged>
    
    
    var body: some View {
        VStack {
           List(workouts) { workout in
            NavigationLink(destination: RunsDetailView(workoutItem: workout)) {
                RunsRow(workoutItem: workout)
                }
//
            }
        }.onAppear {
            print(workouts.count)
        }
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
