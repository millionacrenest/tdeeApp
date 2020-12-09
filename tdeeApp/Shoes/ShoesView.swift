//
//  ShoesView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit
import UserNotifications
import Lottie

struct ShoesView: View {
    
    //TODO: have app send PN when shoe limit is reached
    
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
    @State var showingDetail = false
    
    
    @State private var milesOnShoes: Int16?
    @State var shoeDate = Date()
    
    @State private var showingDatePicker = false
    
          
    
    var body: some View {
        NavigationView {
               
                    
                    VStack {
                        LottieView(filename: "shoes-animation")
                        Text("New Shoes Recorded:")
                        Text(shoeDate, style: .date)
                        
                        Button("Adjust Recorded Date") {
                            self.showingDatePicker.toggle()
                        }
                        .sheet(isPresented: $showingDatePicker, onDismiss: getRunningWorkouts) {
                            DatePicker("", selection: $shoeDate, displayedComponents: .date).datePickerStyle(GraphicalDatePickerStyle()).labelsHidden()
                        }
                        Text("You have run \(milesOnShoes ?? 0) miles since \(shoeDate)")
                        Spacer()
                        
                        Text("You will need new shoes in \(milesRemaining ?? 0) miles")
                        Spacer()
                    }.onAppear {
                        shoeDate = userAccount.first?.dateMilesLastSet ?? Date()
                        getRunningWorkouts()
                        
                    }.navigationTitle("Shoe Life")
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showingDetail.toggle()
                        }) {
                            Image(systemName: "gear").imageScale(.large)
                        }.sheet(isPresented: $showingDetail) {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            SettingsView().environment(\.managedObjectContext, context)
                        })
                    
        }
    }
    
    func saveToCoreData() {
        userAccount.first?.dateMilesLastSet = shoeDate
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
        
    }
    
    func getRunningWorkouts() {
        saveToCoreData()
        var workouts = [HKWorkout]()
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
           
           let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
           
           let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
               { (sampleQuery, results, error ) -> Void in

                   if let queryError = error {
                       print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                   }
            
            var miles = [Double]()
            
            workouts = results as! [HKWorkout]
            for workout in workouts {
                if workout.endDate > shoeDate {
                    miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                }
            }
            
            milesOnShoes = Int16(miles.reduce(0, +))
            milesRemaining = Int16(300 - milesOnShoes!)
            
           }
        
        healthStore.execute(sampleQuery)
        
        
    }
    
    
}

struct ShoesView_Previews: PreviewProvider {
    static var previews: some View {
        ShoesView()
    }
}


