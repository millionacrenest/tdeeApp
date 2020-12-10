//
//  ProfileView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit
import Lottie

struct ProfileView: View {
    
    @State var showingDetail = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    @FetchRequest(
        entity: RunLogged.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \RunLogged.dateRun, ascending: false)
        ]
    ) var workouts: FetchedResults<RunLogged>
    
    @State private var miles = "0"
    @State private var runnersBonus: String? {
        didSet {
            getCurrentCaloriesInAndDaysToLoseAPound()
        }
    }
    @State private var selectedDayValue: Double = 5
    @State private var daysToLoseAPound = "0"
    @State private var caloriesToEatPerDay = "1600"
    @State private var healthKitIsAuthorized: Bool = false
    
    let healthStore = HKHealthStore()
    
    
    var body: some View {
        
        NavigationView {
                ZStack {
                    VStack {
                        VStack {
                            LottieView(filename: "health-and-fitness")

                            if userAccount.first?.goalWeight != nil {
                                Text("GOAL Weight: \(userAccount.first?.goalWeight ?? "0")")
                                Text("Current BMI: \(userAccount.first?.userBMI ?? "no BMI data")")
                                Text("Current Weight: \(userAccount.first?.currentWeight ?? "no weight data")")
                            } else {
                                Text("GOAL WEIGHT NOT SET")
                            }

                        }
                        Spacer()
                        Text("You run an average of:")
                        HStack {
                            Text(miles.prefix(3)).bold()
                            Text("miles per day")
                        }
                        Spacer()
                        VStack {
                            Text("This means your Runner's Bonus is")
                            HStack {
                                Text(runnersBonus ?? "").bold()
                                Text("extra calories per day!")
                            }
                            Text("If you eat \(caloriesToEatPerDay) calories per day")
                            Text("You'll lose a pound every \(daysToLoseAPound) days.")
                        }
                        Spacer()
                        Text("Adjust days to lose a pound:")
                        Text("DAYS: \(selectedDayValue)")
//                        Slider(value: $selectedDayValue, in: 1...14,step: 1,onEditingChanged: { data in
//                            self.daysToLoseAPound = String(format: "%.0f", selectedDayValue)
//                            updateCaloriesForDaysToLoseAPound()
//                        }).padding(12)

                        CustomSlider(value: $selectedDayValue,   range: (0, 14)) { modifiers in
                          ZStack {
                            LinearGradient(gradient: .init(colors: [Color.pink, Color.orange ]), startPoint: .leading, endPoint: .trailing)
                            ZStack {
                              Circle().fill(Color.white)
                              Circle().stroke(Color.black.opacity(0.2), lineWidth: 2)

                            }
                            .padding([.top, .bottom, .leading, .trailing], 2)
                            .modifier(modifiers.knob)
                          }.cornerRadius(15)
                        }.frame(height: 30)
                    }
                }.navigationTitle("Runner's Bonus")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showingDetail.toggle()
                    }) {
                        Image(systemName: "gear").imageScale(.large)
                    }.sheet(isPresented: $showingDetail) {
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        SettingsView().environment(\.managedObjectContext, context)
                    })

        }
        
    }
    
    func getCurrentCaloriesInAndDaysToLoseAPound() {
        
        
        let goalWeight = Double(userAccount.first?.goalWeight ?? "0")
        let bonus = Double(runnersBonus ?? "") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight ?? 0) * 15
        

        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        let caloriesToEat = caloriesToSustainGoalWeight - (bonus/2)
        self.caloriesToEatPerDay = String(format: "%.0f", caloriesToEat)

        let calorieDeficetPerDay = caloriesRequiredPerDay - caloriesToEat
        
        let daysToLoseAPound = 3500/calorieDeficetPerDay
        self.daysToLoseAPound = String(format: "%.0f", daysToLoseAPound)
        DispatchQueue.main.async {
            selectedDayValue = Double(daysToLoseAPound)
        }
        
    }
    
    func updateCaloriesForDaysToLoseAPound() {
        let goalWeight = Double(userAccount.first?.goalWeight ?? "0")
        let bonus = Double(runnersBonus ?? "") ?? 0
        
        let caloriesToSustainGoalWeight = Double(goalWeight ?? 0) * 15


        let caloriesRequiredPerDay = caloriesToSustainGoalWeight + bonus

        //how to calculate?
        let calorieDeficetPerDay = 3500/selectedDayValue
        let caloriesToEat = caloriesRequiredPerDay - calorieDeficetPerDay
        self.caloriesToEatPerDay = String(format: "%.0f", caloriesToEat)
        
        
    }


}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}





