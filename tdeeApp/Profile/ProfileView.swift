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
import UIKit

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
    @State private var runnersBonus: String?
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
                            
                            
                            if userAccount.first?.goalWeight != nil {
                                ProfileHeaderView {
                                    HStack {
                                        LottieView(filename: "health-and-fitness").frame(width: 150, height: 150, alignment: .leading)
                                        VStack {
                                            Text("GOAL Weight: \(userAccount.first?.goalWeight ?? "0")").multilineTextAlignment(.leading)
                                    Text("Current BMI: \(userAccount.first?.userBMI ?? "no BMI data")").multilineTextAlignment(.leading)
                                    Text("Current Weight: \(userAccount.first?.currentWeight ?? "no weight data")").multilineTextAlignment(.leading)
                                        }
                                    }
                                }.padding([.top, .bottom], 20)
                                
                            } else {
                                Text("GOAL WEIGHT NOT SET")
                            }

                        }
                        Spacer()
                        Text("You run an average of:")
                        HStack {
                            Text(userAccount.first?.currentMilesAverage ?? "000").bold()
                            Text("miles per day")
                        }
                        Spacer()
                        VStack {
                            Text("This means your Runner's Bonus is")
                            HStack {
                                Text(userAccount.first?.currentRunnersBonus ?? "000").bold()
                                Text("extra calories per day!")
                            }
                            Text("If you eat \(caloriesToEatPerDay) calories per day")
                            Text("You'll lose a pound every \(daysToLoseAPound) days.")
                        }
                        Spacer()
                        Text("Adjust days to lose a pound:")

                        VStack(spacing: 30) {
                               Group {
                                   
                                CustomSlider(value: $selectedDayValue.didSet { _ in
                                                self.caloriesToEatPerDay = updateCaloriesForDaysToLoseAPound(user: userAccount.first ?? User(), value: selectedDayValue)
                                    self.daysToLoseAPound = String(Int(selectedDayValue))
                                    
                                },   range: (0, 14)) { modifiers in
                                  ZStack {
                                    LinearGradient(gradient: .init(colors: [Color.green, Color.purple ]), startPoint: .leading, endPoint: .trailing)
                                    ZStack {
                                      Circle().fill(Color.white)
                                      Circle().stroke(Color.black.opacity(0.2), lineWidth: 2)
                                      Text(daysToLoseAPound)

                                    }
                                    .padding([.top, .bottom, .leading, .trailing], 2)
                                    .modifier(modifiers.knob)
                                    
                                    
                                  }.cornerRadius(15)
                                  
                                }
                                 
                               }.frame(width:320, height: 100).padding(.bottom, 20)
                           }
                       }
                }.onAppear {
                    runnersBonus = userAccount.first?.currentRunnersBonus
                    self.selectedDayValue = getCurrentCaloriesInAndDaysToLoseAPound(user: userAccount.first ?? User()).1
                    self.caloriesToEatPerDay = getCurrentCaloriesInAndDaysToLoseAPound(user: userAccount.first ?? User()).0
                    
                    
                }
                .navigationTitle("Runner's Bonus")
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
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}




