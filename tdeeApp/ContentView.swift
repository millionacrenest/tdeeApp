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
    @State var measurementsSet: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        VStack {
            if !measurementsSet {
            Image("runningFig").resizable()
            .frame(width: 100.0, height: 100.0)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(Color.red, lineWidth: 5))
        
            Text("First, we need some info:")
            TextField("Enter first name", text: $userSettings.firstName).padding(12)
            Text("Birthday")
            DatePicker("", selection: $userSettings.birthday, displayedComponents: .date).labelsHidden()
            TextField("Enter your height in CM", value: $userSettings.heightInCM, formatter: NumberFormatter()).padding(12)
            TextField("Enter your current weight in KG", value: $userSettings.startingWeightInKg, formatter: NumberFormatter()).padding(12)
            TextField("Enter your goal weight in KG", value: $userSettings.startingWeightInKg, formatter: NumberFormatter()).padding(12)
                Button("Calculate TDEE", action: {
                    self.measurementsSet = true
                })
            //slider desired days to lose a pound
            } else {
                Text("Thanks for the info \(userSettings.firstName)!")
                Text("Your current TDEE is")
                Text("\(userSettings.currentTDEE)").font(.largeTitle).foregroundColor(.red)
                Text("This means you should eat \(userSettings.caloriesIn) to lose a pound every \(userSettings.desiredDaysPerPoundLost) days")
                Text("Please check back soon to see how these values change with your running routine.")
                Button("Recalculate TDEE", action: {
                    self.measurementsSet = false
                })
            }
            
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
