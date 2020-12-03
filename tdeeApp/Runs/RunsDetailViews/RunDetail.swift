//
//  RunDetail.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/17/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct RunDetail : View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    var workoutItem: RunLogged
    
    @State private var runDescription: String = ""
    @State private var runImage = UIImage()
    @State private var isEditing = false
    
    var body: some View {

        VStack {

            Text("run info \(workoutItem.dateRun)")
            Spacer()
            TextView(text: $runDescription).frame(minWidth: 300, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)

            Spacer()
            Button(action: {
                saveRunData()
            }) {
                Text("SAVE CHANGES")
            }
            Spacer()
            Image(uiImage: UIImage(data: workoutItem.runImage ?? Data()) ?? UIImage()).resizable()
                .scaledToFill()
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width)
            Spacer()
            ImagePicker(selectedImage: $runImage, sourceType: .camera)
                .scaledToFill()
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width)

        }.onAppear {
            runImage = UIImage(data: workoutItem.runImage ?? Data()) ?? UIImage()
            runDescription = workoutItem.runDescription ?? ""
        }
    }
    
    func saveRunData() {
        
        workoutItem.runDescription = runDescription
        workoutItem.runImage = runImage.jpegData(compressionQuality: 1.0)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
}
