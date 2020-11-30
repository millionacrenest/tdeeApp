//
//  SettingsView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/12/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State var data: [(String, [String])] = [
            ("One", Array(0...9).map { "\($0)" }),
            ("Two", Array(0...9).map { "\($0)" }),
            ("Three", Array(0...9).map { "\($0)" })
        ]
    @State var selection: [String] = [0, 0, 0].map { "\($0)" }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \User.userID, ascending: true)
        ]
    ) var userAccount: FetchedResults<User>
    
    @State private var localModel: MultiSegmentPickerViewModel?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if userAccount.first?.goalWeight == nil {
                    Text("Set your goal weight")
                    } else {
                        Text("GOAL WEIGHT \(userAccount.first?.goalWeight ?? "")")
                        Text("Update your goal weight")
                    }
                    PickerView(data: data, selection: $selection)
                    Button(action: {
                        saveToCoreData()
                    }) {
                        Text("Save")
                            .frame(height: 55)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.leading, .trailing], 4)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.leading, .trailing])
                        
                    }
                }
            }.navigationTitle("Settings")
        }
    }
    
    func saveToCoreData() {
        
        
        userAccount.first?.goalWeight = "\(selection[0])\(selection[1])\(selection[2])"
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
