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
    
    
    @EnvironmentObject var settings: UserSettings
    @State private var currentBMI = "no BMI data"
    @State private var currentWeight = "no Weight data"
    @State private var miles = "0"
    @State private var runnersBonus: String? {
        didSet {
            getCurrentCaloriesInAndDaysToLoseAPound()
        }
    }
    @State private var daysToLoseAPound = "0"
    
    let healthStore = HKHealthStore()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    Text("Runner's Bonus").bold()
                    Image("fixx").resizable()
                        .clipShape(Circle()).frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/2.5)
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                    
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
                    Text("You'll lose a pound every \(daysToLoseAPound) days")
                }
                Spacer()
            }.onAppear {
                    getBMI()
                    getWeight()
                    getRunningWorkouts()
                
            }
        }
        
    }
    
    func getBMI() {
        let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)

        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0)
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
        let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0)
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
        
        let miles = Double(self.miles)
        let goalWeight = 126
        let bonus = Double(runnersBonus ?? "") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight * 15)
        

        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        let caloriesToEatPerDay = caloriesToSustainGoalWeight - (bonus/2)

        let calorieDeficetPerDay = caloriesRequiredPerDay - caloriesToEatPerDay
        
        let daysToLoseAPound = 3500/calorieDeficetPerDay
        self.daysToLoseAPound = String(format: "%.0f", daysToLoseAPound)
        //selectedDayValue = Double(daysToLoseAPound)
        
        
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}





