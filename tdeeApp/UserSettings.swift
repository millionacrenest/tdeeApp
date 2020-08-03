//
//  UserSettings.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class UserSettings: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var startingWeightInLbs: String = ""
    @Published var goalWeightInLbs: String = ""
    @Published var profileImage: UIImage?
    @Published var caloriesToSustainGoalWeight: Int = 0
    @Published var caloriesToEatPerDay: Int = 0
    @Published var milesRunPerDay: String = "4"
    @Published var daysToLoseAPound: Int = 0
    @Published var goalWeightSet: Bool = false
    @Published var selectedDayValue: Double = 0 {
        didSet {
            let intValue = Int(selectedDayValue)
            daysToLoseAPound = intValue
        }
    }
    
    func getCurrentCaloriesInAndDaysToLoseAPound() {
        guard let goalWeight = Int(goalWeightInLbs) else { return }
        let miles = 4
        
        caloriesToSustainGoalWeight = goalWeight * 15


        let runnersCalorieBonus = miles * 100
        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + runnersCalorieBonus

        caloriesToEatPerDay = caloriesToSustainGoalWeight - (runnersCalorieBonus/2)

        let calorieDeficetPerDay = caloriesRequiredPerDay - caloriesToEatPerDay

        daysToLoseAPound = 3500/calorieDeficetPerDay
        
    }
}
