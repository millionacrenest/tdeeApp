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
                        getBMI()
                        getWeight()
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
                getRunningWorkouts()
            } catch {
                // Show the error here
            }
        }
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
            
            workouts = results as? [HKWorkout] ?? [HKWorkout]()
            
                for workout in workouts {
                        self.getRunningWorkoutRoute(workoutItem: workout)
                    
                    
                    
                }
                for workout in workouts.prefix(7) {
                    
                    if workout.endDate > startDate {
                        miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                    }
                }
            
            
            let averageOfMiles = miles.reduce(0, +)
           // self.miles = String(averageOfMiles/7)
            let runnersBonus = (averageOfMiles/7) * 100
           // self.runnersBonus = String(format: "%.0f", runnersBonus)
            
           }
        
        healthStore.execute(sampleQuery)
        
    }
    
    func getRunningWorkoutRoute(workoutItem: HKWorkout) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: workoutItem)
        
        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The initial query failed.")
            }
            if let route = samples?.first as? HKWorkoutRoute {
                print("route", route)
                print("workout item", workoutItem.uuid)
                self.getRouteData(route: route, workoutItem: workoutItem)
                
            }
            
           
        }

        routeQuery.updateHandler = { (query, samples, deleted, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The update failed.")
            }
            
            // Process updates or additions here.
            print("updated samples: ", samples?.first?.sampleType ?? [HKSample]())
            
        }

        healthStore.execute(routeQuery)
        
    }
    
    func getRouteData(route: HKWorkoutRoute, workoutItem: HKWorkout) {
        var locationCoordinates = [CLLocationCoordinate2D]()
        
        // Create the route query.
        let query = HKWorkoutRouteQuery(route: route) { (query, locationsOrNil, done, errorOrNil) in
            
            // This block may be called multiple times.
            
            if let error = errorOrNil {
                // Handle any errors here.
                return
            }
            
            guard let locations = locationsOrNil else {
                fatalError("*** Invalid State: This can only fail if there was an error. ***")
            }
            
            // Do something with this batch of location data.
                
            if done {
                // The query returned all the location data associated with the route.
                // Do something with the complete data set.
                
                for location in locations {
                    locationCoordinates.append(location.coordinate)
                }
                
                //save workout and route to core data

            // You can stop the query by calling:
            // store.stop(query)
               self.saveRunToCoreData(workoutItem: workoutItem, coordinates: locationCoordinates)
                
            }
            
            
        }
        healthStore.execute(query)
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
        
        if let currData = results?.first as? HKQuantitySample {
            print("BMI IS ", String(currData.quantity.doubleValue(for: .count())))
           // saveHealthKitBMIDataToUserEntity(bmiString: String(currData.quantity.doubleValue(for: .count())))
            saveBMIToCoreData(bmiString: String(currData.quantity.doubleValue(for: .count())))
        }
        
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
        saveWeightToCoreData(weightString: String(weightString.prefix(3)))
       // saveHealthKitWeightDataToUserEntity(weightString: String(weightString.prefix(3)))
        
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

