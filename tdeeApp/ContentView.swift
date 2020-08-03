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
            
                
                Image("runningFig").resizable()
            .frame(width: 100.0, height: 100.0)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.red, lineWidth: 5))
        
            
            
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
                Slider(value: $userSettings.selectedDayValue, in: 1...365,step: 1,onEditingChanged: { data in
                    self.userSettings.getCurrentCaloriesInAndDaysToLoseAPound()
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
