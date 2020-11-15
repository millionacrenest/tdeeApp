//
//  UserSettings.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

class UserSettings: ObservableObject {
    
    @Published var startingWeightInLbs: String = ""
    @Published var goalWeightInLbs: String = ""
    @Published var caloriesToSustainGoalWeight: Double = 0
    @Published var caloriesToEatPerDay: Double = 0
    @Published var milesRunPerDay: String = "4.45"
    @Published var daysToLoseAPound: Double = 0
    @Published var goalWeightSet: Bool = false
    @Published var runnersBonus: String = "445"
    @Published var calorieDeficetPerDay: Double = 0
    @Published var selectedDayValue: Double = 0 {
        didSet {
            daysToLoseAPound = selectedDayValue
        }
    }
    
    
    func getCurrentCaloriesInAndDaysToLoseAPound() {
        self.goalWeightSet = true
        guard let goalWeight = Int(goalWeightInLbs) else { return }
        let miles = 4.45
        
        caloriesToSustainGoalWeight = Double(goalWeight * 15)


        let runnersCalorieBonus = miles * 100
        runnersBonus = "\(runnersCalorieBonus)"
        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + runnersCalorieBonus

        caloriesToEatPerDay = caloriesToSustainGoalWeight - (runnersCalorieBonus/2)

        calorieDeficetPerDay = caloriesRequiredPerDay - caloriesToEatPerDay
        
        daysToLoseAPound = 3500/calorieDeficetPerDay
        selectedDayValue = daysToLoseAPound
        
        
    }
    
    func updateCaloriesForDaysToLoseAPound() {
        guard let goalWeight = Int(goalWeightInLbs) else { return }
        let miles = 4.45
        
        caloriesToSustainGoalWeight = Double(goalWeight * 15)


        let runnersCalorieBonus = miles * 100
        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + runnersCalorieBonus

        //how to calculate?
        calorieDeficetPerDay = 3500/daysToLoseAPound
        print("calorie deficet is \(calorieDeficetPerDay)")
        caloriesToEatPerDay = caloriesRequiredPerDay - calorieDeficetPerDay
        
        
        
    }
    
    
}
