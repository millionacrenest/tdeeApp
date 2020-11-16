//
//  ProfileView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
    
    @State var showingDetail = false
    
    @EnvironmentObject var settings: UserSettings
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    
    @State private var currentBMI = "no BMI data"
    @State private var currentWeight = "no Weight data" {
        didSet {
            saveToCoreData()
        }
    }
    @State private var miles = "0"
    @State private var runnersBonus: String? {
        didSet {
            getCurrentCaloriesInAndDaysToLoseAPound()
        }
    }
    @State private var daysToLoseAPound = "0"
    @State private var caloriesToEatPerDay = "1600"
    @State private var healthKitIsAuthorized: Bool = false {
        didSet {
            getBMI()
            getWeight()
            getRunningWorkouts()
        }
    }
    
    let healthStore = HKHealthStore()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack {
                        VStack {
                            ZStack {
                            Image("fixx").resizable()
                                .clipShape(Circle()).frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/2.5)
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                                
                            }
                            if userAccount.first?.goalWeight != nil {
                                Text("GOAL: \(userAccount.first?.goalWeight ?? "0")")
                            }
                            Text("Current BMI: \(currentBMI)")
                            Text("Current Weight: \(currentWeight)")
                        }
                        Spacer()
                        Text("You run an average of:")
                        HStack {
                            Text(miles.prefix(3)).bold()
                            Text("miles per day")
                        }
                        Spacer()
                        VStack {
                            Text("This means your Runner's Bonus is")
                            HStack {
                                Text(runnersBonus ?? "").bold()
                                Text("extra calories per day!")
                            }
                            Text("If you eat \(caloriesToEatPerDay) calories per day")
                            Text("You'll lose a pound every \(daysToLoseAPound) days.")
                        }
                        Spacer()
                        Text("Adjust days to lose a pound:")
                        Slider(value: $settings.selectedDayValue, in: 1...14,step: 1,onEditingChanged: { data in
                            self.daysToLoseAPound = String(format: "%.0f", settings.selectedDayValue)
                            updateCaloriesForDaysToLoseAPound()
                        }).padding(12)
                    }.onAppear {
                        if healthKitIsAuthorized {
                            getBMI()
                            getWeight()
                            getRunningWorkouts()
                        } else {
                            getHealthKitAuth()
                        }
                        
                    }
                }
            }.navigationTitle("Runner's Bonus")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "gear").imageScale(.large)
                }.sheet(isPresented: $showingDetail) {
                    SettingsView()
                })
        }
        
    }
    
    func getHealthKitAuth() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
              
          guard authorized else {
                
            let baseMessage = "HealthKit Authorization Failed"
                
            if let error = error {
              print("\(baseMessage). Reason: \(error.localizedDescription)")
            } else {
              print(baseMessage)
            }
            
            return
          }
          healthKitIsAuthorized = true
          print("HealthKit Successfully Authorized.")
        }
    }
    
    func getBMI() {
        let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)

        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = Date(timeIntervalSince1970: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        // Create the HealthKit Query
        let query = HKSampleQuery(
            sampleType: bodyMassIndexType!,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor],
            resultsHandler: updateBMIData
        )
        // Execute our query
        healthStore.execute(query)
    }

    func updateBMIData(query: HKSampleQuery, results: [HKSample]?, error: Error?) {
        
        let currData = results?.first as? HKQuantitySample
        
        self.currentBMI = String(currData?.quantity.doubleValue(for: .count()) ?? 0)
 
    }
    
    func getWeight() {
        
        let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)

        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = Date(timeIntervalSince1970: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        // Create the HealthKit Query
        let query = HKSampleQuery(
            sampleType: bodyMassType!,
            predicate: predicate,
            limit: 0,
            sortDescriptors: [sortDescriptor],
            resultsHandler: updateWeightData
        )
        // Execute our query
        healthStore.execute(query)
        
        
    }

    func updateWeightData(query: HKSampleQuery, results: [HKSample]?, error: Error?) {
        
        let currData = results?.first as? HKQuantitySample
        
        let weightInKilograms = Measurement(value: currData?.quantity.doubleValue(for: .gramUnit(with: .kilo)) ?? 0, unit: UnitMass.kilograms)
        let weightString = "\(weightInKilograms.converted(to: .pounds))"
        
        self.currentWeight = String(weightString.prefix(3))
        
        
    }
    
    
    func getRunningWorkouts() {

        var workouts = [HKWorkout]()
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
           
           let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
           
           let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
               { (sampleQuery, results, error ) -> Void in

                   if let queryError = error {
                       print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                   }
            
            let endDate = Date()
            let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 168.0)
            var miles = [Double]()
            
            workouts = results as! [HKWorkout]
            for workout in workouts.prefix(7) {
                if workout.endDate > startDate {
                    miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                }
            }
            
            let averageOfMiles = miles.reduce(0, +)
            self.miles = String(averageOfMiles/7)
            let runnersBonus = (averageOfMiles/7) * 100
            self.runnersBonus = String(format: "%.0f", runnersBonus)
            
           }
        
        healthStore.execute(sampleQuery)
        
    }
    
    func getCurrentCaloriesInAndDaysToLoseAPound() {
        
        
        let goalWeight = Double(userAccount.first?.goalWeight ?? "0")
        let bonus = Double(runnersBonus ?? "") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight ?? 0) * 15
        

        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        let caloriesToEat = caloriesToSustainGoalWeight - (bonus/2)
        self.caloriesToEatPerDay = String(format: "%.0f", caloriesToEat)

        let calorieDeficetPerDay = caloriesRequiredPerDay - caloriesToEat
        
        let daysToLoseAPound = 3500/calorieDeficetPerDay
        self.daysToLoseAPound = String(format: "%.0f", daysToLoseAPound)
        DispatchQueue.main.async {
            settings.selectedDayValue = Double(daysToLoseAPound)
        }
        
    }
    
    func updateCaloriesForDaysToLoseAPound() {
        let goalWeight = Double(userAccount.first?.goalWeight ?? "0")
        let bonus = Double(runnersBonus ?? "") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight ?? 0) * 15


        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        //how to calculate?
        let calorieDeficetPerDay = 3500/settings.selectedDayValue
        let caloriesToEat = caloriesRequiredPerDay - calorieDeficetPerDay
        self.caloriesToEatPerDay = String(format: "%.0f", caloriesToEat)
        
        
    }
    
    func saveToCoreData() {
        let userSettings = User(context: managedObjectContext)
        
        
        userSettings.currentWeight = currentWeight
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}





