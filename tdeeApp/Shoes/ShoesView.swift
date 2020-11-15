//
//  ShoesView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct ShoesView: View {
    
    //TODO: have app send PN when shoe limit is reached
    
    let healthStore = HKHealthStore()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    @State private var shoeMaxMiles: String = "Enter a maximum mile target for your running shoes:"
    @State private var milesRemaining: Int16?
    @State var showingDetail = false
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    
                    VStack {

                                Image(uiImage: self.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                         

                                Button(action: {
                                    self.isShowPhotoLibrary = true
                                    
                                }) {
                                    HStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 20))

                                        Text("Post Image of Shoes")
                                            .font(.headline)
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                }
                            }.sheet(isPresented: $isShowPhotoLibrary) {
                                ImagePicker(selectedImage: self.$image, sourceType: .camera)
                            }
                    
                    VStack {
                        if userAccount.first?.shoeMaxMiles == 0 || userAccount.first?.shoeMaxMiles == nil {
                            TextEditor(text: $shoeMaxMiles)
                                .frame(height: 55)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.leading, .trailing], 4)
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                .padding([.leading, .trailing], 24).onTapGesture {
                                    shoeMaxMiles = ""
                            }
                            
                            Button(action: {
                                userAccount.first?.shoeMaxMiles = Int16(shoeMaxMiles) ?? 0
                                if managedObjectContext.hasChanges {
                                    do {
                                        try managedObjectContext.save()
                                        milesRemaining = getRunningWorkouts()
                                    } catch {
                                        // Show the error here
                                    }
                                }
                            }) {
                                Text("Save")
                                    .frame(height: 55)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.leading, .trailing], 4)
                                    .cornerRadius(16)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                    .padding([.leading, .trailing])
                                
                            }
                        } else {
                            VStack {
                                Spacer()
                                Text("Your shoe max miles: \(userAccount.first?.shoeMaxMiles ?? 0)").multilineTextAlignment(.leading)
                                Spacer()
                                Button(action: {
                                    userAccount.first?.shoeMaxMiles = 0
                                    if managedObjectContext.hasChanges {
                                        do {
                                            try managedObjectContext.save()
                                        } catch {
                                            // Show the error here
                                        }
                                    }
                                }) {
                                    Text("Change")
                                        .frame(height: 55)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding([.leading, .trailing], 4)
                                        .cornerRadius(16)
                                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                                        .padding([.leading, .trailing])
                                    
                                }
                                Spacer()
                                Text("New shoes recorded: \(userAccount.first?.dateMilesLastSet ?? Date())")
                                Spacer()
                                Text("Your shoes have \(milesRemaining ?? 0) more miles in them.").multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        
                    }
                }.onAppear {
                    fetchSavedImage()
                    milesRemaining = getRunningWorkouts()
                }
            }.navigationTitle("Shoe Life")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "gear").imageScale(.large)
                }.sheet(isPresented: $showingDetail) {
                    SettingsView()
                })
        }
    }
    
    func getRunningWorkouts() -> Int16 {
        calculateMilesRemaining()
        var sumOfMiles: Int16 = 0
        var milesValue: Int16 = Int16(shoeMaxMiles) ?? 0
        var workouts = [HKWorkout]()
        let predicate =  HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.running)
           
           let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
           
           let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
               { (sampleQuery, results, error ) -> Void in

                   if let queryError = error {
                       print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                   }
            
            let startDate = userAccount.first?.dateMilesLastSet
            var miles = [Double]()
            
            workouts = results as! [HKWorkout]
            for workout in workouts.prefix(7) {
                if workout.endDate > startDate ?? Date() {
                    miles.append(workout.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                }
            }
            
            sumOfMiles = Int16(miles.reduce(0, +))
            
           }
        
        healthStore.execute(sampleQuery)
        return userAccount.first?.shoeMaxMiles ?? 0 - sumOfMiles
        
    }
    
    func calculateMilesRemaining() -> String {

        let milesRemainingString = userAccount.first?.shoeMaxMiles.description ?? ""
        
        return milesRemainingString
    }
    
    func fetchSavedImage() {
        let data = userAccount.first?.shoeImage
        self.image = UIImage(data: ((data ?? Data() as NSObject) as! Data as NSObject) as! Data) ?? UIImage()
    }
    
}

struct ShoesView_Previews: PreviewProvider {
    static var previews: some View {
        ShoesView()
    }
}


