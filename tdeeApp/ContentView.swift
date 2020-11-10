//
//  ContentView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    @EnvironmentObject var settings: UserSettings
    @State private var currentBMI = "no BMI data"
    @State private var currentWeight = "no Weight data"
    @State private var miles = "0"
    @State private var runnersBonus = "0"
    
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
                        Text(runnersBonus).bold()
                        Text("extra calories per day!")
                    }
                }
                Spacer()
            }.onAppear {
                getBMI()
                getWeight()
                getDistanceWalkingRunning()
            }
        }
        
    }
    
    func getBMI() {
        
        let healthStore = HKHealthStore()
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
        
        let healthStore = HKHealthStore()
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
    
    func getDistanceWalkingRunning() {
        
        let healthStore = HKHealthStore()
        let distanceWalkingRunningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)

        // Use a sortDescriptor to get the recent data first (optional)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        // Get all samples from the last 24 hours
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 168.0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        // Create the HealthKit Query
        
        let query = HKStatisticsQuery(quantityType: distanceWalkingRunningType!, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
            

            if error != nil {
                print("something went wrong")
            } else if let quantity = statistics?.sumQuantity() {
                self.miles = "\(quantity.doubleValue(for: HKUnit.mile())/7)"
                let runnersBonus = (quantity.doubleValue(for: HKUnit.mile())/7) * 100
                self.runnersBonus = String(format: "%.0f", runnersBonus)
            }
        }
        healthStore.execute(query)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





