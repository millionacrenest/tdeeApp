//
//  HealthKitSetupAssistant.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/9/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import HealthKit
import SwiftUI

class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
          completion(false, HealthkitSetupError.notAvailableOnDevice)
          return
        }

    //2. Prepare the data types that will interact with HealthKit
        guard   let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                let height = HKObjectType.quantityType(forIdentifier: .height),
                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }

    //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        HKObjectType.workoutType()]
            
        let healthKitTypesToRead: Set<HKObjectType> = [bodyMassIndex,
                                                       height,
                                                       bodyMass,
                                                       activeEnergy,
                                                       distanceWalkingRunning,
                                                       HKSeriesType.workoutRoute(),
                                                       HKObjectType.workoutType()]

    //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
           
            
          completion(success, error)
        }

    }
    
}

