//
//  ContentView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var settings: UserSettings
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        NavigationView {
        
            ScrollView {
            VStack {
                
               
                
                ZStack {
                Image("fixx").resizable()
                .frame(width: 200.0, height: 250.0)
                .cornerRadius(25)
                    if settings.goalWeightInLbs != "" {
                        VStack {
                            Text("\(settings.goalWeightInLbs)").font(.largeTitle).foregroundColor(.white)
                            Text("goal weight").font(.caption).foregroundColor(.white)
                            
                        }
                    }
                }
                
                TextField("Enter your goal weight in lbs", text: $settings.goalWeightInLbs).padding(12)
                
                NavigationLink(destination: ResultsView().onAppear {
                               
                    self.settings.getCurrentCaloriesInAndDaysToLoseAPound()

                }) {
                  Text("Calculate Your Bonus")
                }
                
                }
            }.navigationBarTitle("Runner's Bonus")
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ResultsView: View {
    
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        
        
        
        VStack {
            VStack {
                Text("You currently run an average of")
                Text("\(settings.milesRunPerDay)").font(.largeTitle).foregroundColor(.red)
                Text("miles per day")
            }
            Spacer()
            Text("Your current TDEE is")
            Text("\(settings.caloriesToSustainGoalWeight)").font(.largeTitle).foregroundColor(.red)
            Spacer()
            Text("This means you should eat")
            Text(String(settings.caloriesToEatPerDay)).font(.largeTitle).foregroundColor(.red)
            HStack {
                Text(" calories to lose a pound every")
                Text("\(settings.daysToLoseAPound)").font(.largeTitle).foregroundColor(.red)
                Text("days")
            }
            Text("Adjust days to lose a pound:")
            Slider(value: $settings.selectedDayValue, in: 1...14,step: 1,onEditingChanged: { data in
                self.settings.updateCaloriesForDaysToLoseAPound()
            }).padding(12)
        }
          
    }
}

    

    
