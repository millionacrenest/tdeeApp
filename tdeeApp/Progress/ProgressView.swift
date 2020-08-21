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
    
    @State var currentWeight: String = "" {
        didSet {
            saveToCoreData()
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            TextField("Record your progress:", text: $currentWeight).padding(12)
            Button(action: {
                self.saveToCoreData()
            }) {
                Text("Save")
            }
            ProgressList()
        }
        
    }
    
    func saveToCoreData() {
        let newProgressItem = ProgressEntity(context: managedObjectContext)
        newProgressItem.date = Date()
        newProgressItem.pounds = currentWeight
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
