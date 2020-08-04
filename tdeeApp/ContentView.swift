//
//  ContentView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userSettings = UserSettings()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        
        ScrollView {
        VStack {
            
            ZStack {
            Image("fixx").resizable()
            .frame(width: 200.0, height: 250.0)
            .cornerRadius(25)
                if userSettings.goalWeightSet {
                    VStack {
                        Text("\(userSettings.goalWeightInLbs)").font(.largeTitle).foregroundColor(.white)
                        Text("goal weight").font(.caption).foregroundColor(.white)
                    }
                }
            }
            
            
            
            if userSettings.goalWeightSet {
                
                VStack {
                    Text("You currently run an average of")
                    Text("\(userSettings.milesRunPerDay)").font(.largeTitle).foregroundColor(.red)
                    Text("miles per day")
                }
                Spacer()
                Text("Your current TDEE is")
                Text("\(userSettings.caloriesToSustainGoalWeight)").font(.largeTitle).foregroundColor(.red)
                Spacer()
                Text("This means you should eat")
                Text(String(userSettings.caloriesToEatPerDay)).font(.largeTitle).foregroundColor(.red)
                HStack {
                    Text(" calories to lose a pound every")
                    Text("\(userSettings.daysToLoseAPound)").font(.largeTitle).foregroundColor(.red)
                    Text("days")
                }
                Text("Adjust days to lose a pound:")
                Slider(value: $userSettings.selectedDayValue, in: 1...14,step: 1,onEditingChanged: { data in
                    self.userSettings.updateCaloriesForDaysToLoseAPound()
                }).padding(12)
                
            } else {
                TextField("Enter your goal weight in lbs", text: $userSettings.goalWeightInLbs).padding(12)
                Button(action: {
                    self.userSettings.getCurrentCaloriesInAndDaysToLoseAPound()
                    self.userSettings.goalWeightSet = true
                }) {
                    Text("Calculate your TDEE")
                }
            }
            
            
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
