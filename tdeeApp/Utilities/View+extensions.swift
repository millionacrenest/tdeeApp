//
//  View+extensions.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

extension View {
    func updateCaloriesForDaysToLoseAPound(user: User, value: Double) -> String {
        let goalWeight = Double(user.goalWeight ?? "0")
        let bonus = Double(user.currentRunnersBonus ?? "") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight ?? 0) * 15


        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        //how to calculate?
        let calorieDeficetPerDay = 3500/value
        let caloriesToEat = caloriesRequiredPerDay - calorieDeficetPerDay
        return String(format: "%.0f", caloriesToEat)
        
        
    }
    
    func getCurrentCaloriesInAndDaysToLoseAPound(user: User) -> (String, Double) {
        
        let goalWeight = Double(user.goalWeight ?? "0")
        let bonus = Double(user.currentRunnersBonus ?? "0") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight ?? 0) * 15
        

        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        let caloriesToEat = caloriesToSustainGoalWeight - (bonus/2)

        let calorieDeficetPerDay = caloriesRequiredPerDay - caloriesToEat
        
        let daysToLoseAPound = 3500/calorieDeficetPerDay
        
        return (String(format: "%.0f", caloriesToEat), Double(daysToLoseAPound))
        
        
    }
}
