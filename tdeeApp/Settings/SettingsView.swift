//
//  SettingsView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/12/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit
import MapKit
import CoreData

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var data: [(String, [String])] = [
            ("One", Array(0...9).map { "\($0)" }),
            ("Two", Array(0...9).map { "\($0)" }),
            ("Three", Array(0...9).map { "\($0)" })
        ]
    @State var selection: [String] = [0, 0, 0].map { "\($0)" }
    
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
    
    
    @State private var localModel: MultiSegmentPickerViewModel?
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if userAccount.first?.goalWeight == nil {
                    Text("Set your goal weight")
                    } else {
                        Text("GOAL WEIGHT \(userAccount.first?.goalWeight ?? "")")
                        Text("Update your goal weight")
                    }
                    PickerView(data: data, selection: $selection)
                    Button(action: {
                        //saveGoalWeightToCoreData(goalWeightString: "\(selection[0])\(selection[1])\(selection[2])")
                        saveGoalWeightToCoreData(goalWeightString: "\(selection[0])\(selection[1])\(selection[2])")
                       
                    }) {
                        Text("Save")
                            
                        
                    }.buttonStyle(ButtonStylePalette.secondary)
                }
            }.navigationTitle("Settings")
        }
    }
    
    func saveGoalWeightToCoreData(goalWeightString: String) {
        print("saving user goal weight ", userAccount.first?.userID)
        userAccount.first?.goalWeight = goalWeightString
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
               // getRunningWorkouts()
            } catch {
                // Show the error here
            }
        }
    }
    
    func saveCurrentMilesAndBonusToCoreData(miles: String, bonus: String) {
        
        userAccount.first?.currentMilesAverage = miles
        userAccount.first?.currentRunnersBonus = bonus
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
    
    func saveBMIToCoreData(bmiString: String) {
        print("saving user bmiString ")
        userAccount.first?.userBMI = bmiString
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
    
    func saveWeightToCoreData(weightString: String) {
        print("saving user weightString ")
        userAccount.first?.currentWeight = weightString
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
    
    func saveRunToCoreData(workoutItem: HKWorkout, coordinates: [CLLocationCoordinate2D] ) {
        let runLogged = RunLogged(context: managedObjectContext)
        runLogged.runUUID = workoutItem.uuid
        print("saving run to core data", workoutItem.uuid)
        runLogged.dateRun = workoutItem.endDate
        runLogged.caloriesBurned = String(format: "%.0f", workoutItem.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()) ?? 0)
        runLogged.distance = String(format: "%.0f", workoutItem.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
        
        runLogged.duration = formatRunTime(interval: workoutItem.duration)
        print("TRM coordinates passed to core data", coordinates)
        
        for coordinate in coordinates {
            let locationPoint = LocationPoint(context: managedObjectContext)
            locationPoint.latitude = coordinate.latitude
            locationPoint.longitude = coordinate.longitude
            locationPoint.pointUUID = UUID()
            locationPoint.runUUID = runLogged.runUUID
            locationPoint.origin = runLogged
        }
        
        
        
        if managedObjectContext.hasChanges {
            do {
                print("saved this run: ", runLogged.runUUID?.uuidString)
                print("saved locations count ", runLogged.locationPointArray.count)
                try managedObjectContext.save()
                
            } catch {
                // Show the error here
            }
        } else {
            print("not saved, no changes")
        }
    }
    
    func formatRunTime(interval: TimeInterval) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(interval))!
    }
    
}

