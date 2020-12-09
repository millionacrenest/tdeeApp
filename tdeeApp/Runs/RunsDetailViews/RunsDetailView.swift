//
//  RunsDetailView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/13/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit

struct RunsDetailView: View {
    
    var workoutItem: RunLogged
    
    @Environment(\.managedObjectContext) var managedObjectContext
   
    
    @State private var durationToShow: String?
    @State private var distanceToShow: String?
    @State private var caloriesBurned: String?
    @State private var dateToFilter: String?
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        
        
        ScrollView {
            VStack {
                RunView(workoutItem: workoutItem)
                Text("Run completed in \(durationToShow ?? "")")
                Text("Run distance: \(distanceToShow ?? "") miles")
                Text("Run calories: \(caloriesBurned ?? "")")

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

                        Text("Photo library")
                            .font(.headline)
                    }.buttonStyle(FilledButton())
                }


            }.onAppear {
                durationToShow = workoutItem.duration
                distanceToShow = workoutItem.distance
                caloriesBurned = workoutItem.caloriesBurned
            }.sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(selectedImage: self.$image, sourceType: .camera)
            }
        }
    }
    
}
