//
//  ProgressView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/21/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ProgressView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    
    @State var showingDetail = false
    
    @State var currentWeight: String = "" {
        didSet {
            saveToCoreData()
        }
    }
    
    var body: some View {
        NavigationView {
                VStack {
                    
                    Text("Record your progress:")
                    
                    TextField("Enter current weight in lbs", text: $currentWeight).padding(12).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        self.saveToCoreData()
                    }) {
                        Text("Save")
                    }
                    ProgressList()
                }
            .navigationTitle("Progress")
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
    
    func saveToCoreData() {
        let newProgressItem = ProgressEntity(context: managedObjectContext)
        let currentWeightInt = Int(userAccount.first?.currentWeight ?? "0") ?? 0
        let goalWeightInt = Int(userAccount.first?.goalWeight ?? "0") ?? 0
        let goalWeightDifference = currentWeightInt - goalWeightInt
        
        
        newProgressItem.date = Date()
        newProgressItem.pounds = currentWeight
        newProgressItem.goalWeightDifference = String(goalWeightDifference)
        newProgressItem.id = UUID()
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Show the error here
                }
            }
        
    }

}
