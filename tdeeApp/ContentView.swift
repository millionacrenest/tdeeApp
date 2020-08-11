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
    @State var progessButtonTapped = false
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        NavigationView {
        
            ScrollView {
            VStack {
                
                if progessButtonTapped == false {
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


struct ResultsView: View {
    
    @EnvironmentObject var settings: UserSettings
    var body: some View {
        
        
        
            VStack {
                VStack {
                    Text("You currently run an average of")
                    Text("\(settings.milesRunPerDay)").font(.largeTitle).foregroundColor(.red)
                    Text("miles per day")
                }
                Text("Your current Runner's Bonus is")
                Text("\(settings.runnersBonus)").font(.largeTitle).foregroundColor(.red)
               
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


struct ProgressView: View {

    @EnvironmentObject var settings: UserSettings
    
    @State var addWeight: String = ""
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @State private var weighInDate = Date()
    
    var body: some View {
            VStack {
                
                //add items to the weightloss array
                
                VStack {
                    TextField("Record today's weight", text: self.$addWeight).multilineTextAlignment(.center).textFieldStyle(RoundedBorderTextFieldStyle()).padding(12)
                    if addWeight != "" {
                        DatePicker(selection: $weighInDate, in: ...Date(), displayedComponents: .date) {
                            Text("")
                        }.labelsHidden()
                    }
                    
                }
                Button(action: {
                    self.settings.progressItems.append(Progress(id: UUID(), weight: self.addWeight, date: self.weighInDate))
                                         self.addWeight = ""
                    
                    
                                     }, label: {
                                         Text("Add")
                                     })
                
                List(self.settings.progressItems, rowContent: ProgressRow.init)
            }
    }

}

struct Progress: Identifiable {
    var id = UUID()
    var weight: String
    var date: Date
}

struct ProgressRow: View {
    var progress: Progress

    var body: some View {
        VStack {
            Text("Recorded weight \(progress.weight)").multilineTextAlignment(.leading).foregroundColor(.black)
            Text("On \(progress.date)").font(.caption).foregroundColor(.gray)
        }.padding(12)
    }
}
    

    
