//
//  ShoesView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct ShoesView: View {
    
    let healthStore = HKHealthStore()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    @State private var shoeMaxMiles: String = "Enter a maximum mile target for your running shoes:"
    @State private var milesRemaining: Int16?
    
    var body: some View {
        ZStack {
            VStack {
                if userAccount.first?.shoeMaxMiles == 0 || userAccount.first?.shoeMaxMiles == nil {
                    TextEditor(text: $shoeMaxMiles)
                        .frame(height: 55)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.leading, .trailing], 4)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.leading, .trailing], 24).onTapGesture {
                            shoeMaxMiles = ""
                    }
                    
                    Button(action: {
                        userAccount.first?.shoeMaxMiles = Int16(shoeMaxMiles) ?? 0
                        if managedObjectContext.hasChanges {
                            do {
                                try managedObjectContext.save()
                                milesRemaining = getRunningWorkouts()
                            } catch {
                                // Show the error here
                            }
                        }
                    }) {
                        Text("Save")
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.leading, .trailing], 4)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.leading, .trailing])
                        
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Your shoe max miles: \(userAccount.first?.shoeMaxMiles ?? 0)").multilineTextAlignment(.leading)
                        Spacer()
                        Button(action: {
                            userAccount.first?.shoeMaxMiles = 0
                            if managedObjectContext.hasChanges {
                                do {
                                    try managedObjectContext.save()
                                } catch {
                                    // Show the error here
                                }
                            }
                        }) {
                            Text("Change")
                                .frame(height: 55)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.leading, .trailing], 4)
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                .padding([.leading, .trailing])
                            
                        }
                        Spacer()
                        Text("New shoes recorded: \(userAccount.first?.dateMilesLastSet ?? Date())")
                        Spacer()
                        Text("Your shoes have \(milesRemaining ?? 0) more miles in them.").multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                
            }
        }.onAppear {
            milesRemaining = getRunningWorkouts()
        }
    }
    
    func getRunningWorkouts() -> Int16 {
        calculateMilesRemaining()
        var sumOfMiles: Int16 = 0
        var milesValue: Int16 = Int16(shoeMaxMiles) ?? 0
        var workouts = [HKWorkout]()
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
           
           let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
           
           let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
               { (sampleQuery, results, error ) -> Void in

                   if let queryError = error {
                       print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                   }
            
            let startDate = userAccount.first?.dateMilesLastSet
            var miles = [Double]()
            
            workouts = results as! [HKWorkout]
            for workout in workouts.prefix(7) {
                if workout.endDate > startDate ?? Date() {
                    miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                }
            }
            
            sumOfMiles = Int16(miles.reduce(0, +))
            
           }
        
        healthStore.execute(sampleQuery)
        return userAccount.first?.shoeMaxMiles ?? 0 - sumOfMiles
        
    }
    
    func calculateMilesRemaining() -> String {

        var milesRemainingString = userAccount.first?.shoeMaxMiles.description ?? ""
        
        return milesRemainingString
    }
    
    func saveToCoreData() {
        let userSettings = User(context: managedObjectContext)
        
        
        userSettings.shoeMaxMiles = Int16(shoeMaxMiles) ?? 0
        userSettings.dateMilesLastSet = Date()
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
}

struct ShoesView_Previews: PreviewProvider {
    static var previews: some View {
        ShoesView()
    }
}


