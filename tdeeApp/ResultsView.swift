//
//  ResultsView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/21/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        
        VStack {
            VStack {
                Text("You currently run an average of")
                HStack {
                    Text("\(settings.milesRunPerDay)").font(.largeTitle).foregroundColor(.red)
                    Text("miles per day")
                }
            }
            Text("Your current Runner's Bonus is")
            Text("\(settings.runnersBonus)").font(.largeTitle).foregroundColor(.red)
           
            Text("This means you should eat")
            Text("\(settings.caloriesToEatPerDay, specifier: "%.1f")").font(.largeTitle).foregroundColor(.red)
            
            Text(" calories to lose a pound every")
            HStack {
                Text("\(settings.daysToLoseAPound, specifier: "%.1f")").font(.largeTitle).foregroundColor(.red)
                Text("days")
            }
            
            Text("Adjust days to lose a pound:")
            Slider(value: $settings.selectedDayValue, in: 1...14,step: 1,onEditingChanged: { data in
                self.settings.updateCaloriesForDaysToLoseAPound()
            }).padding(12)
            
        }.onAppear {
            self.settings.getCurrentCaloriesInAndDaysToLoseAPound()
        }
        
    }
}
