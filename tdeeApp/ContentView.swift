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
    
    
    var body: some View {
        NavigationView {
        
            ScrollView {
            VStack {
                
                    Text("The Runner's Bonus helps you calculate how many calories you should eat daily to reach your weightloss goal.").multilineTextAlignment(.leading).padding(12)
                    Spacer()
                    ZStack {
                        Image("fixx").resizable()
                            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/2.5)
                        .cornerRadius(5)
                        if settings.goalWeightInLbs != "" {
                            VStack {
                                Text("\(settings.goalWeightInLbs)").font(.largeTitle).foregroundColor(.white)
                                Text("goal weight").font(.caption).foregroundColor(.white)
                                
                            }
                        }
                    }
                    TextField("Enter your goal weight in lbs", text: $settings.goalWeightInLbs).padding(12).multilineTextAlignment(.center).textFieldStyle(RoundedBorderTextFieldStyle())
                    
            NavigationLink(destination: ResultsView().onAppear {
                                   
                        self.settings.getCurrentCaloriesInAndDaysToLoseAPound()

                    }) {
                      Text("Calculate Your Bonus")
                    }
                    
                
                }
                
            }.navigationBarTitle("Runner's Bonus").navigationBarItems(trailing:
                NavigationLink(destination: ProgressView()) {
                Image(systemName: "calendar.circle").imageScale(.large)
            })

            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
