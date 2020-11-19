//
//  RunsDetailView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/13/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreData
import Combine

struct RunsDetailView: View {
    
    var workoutItem: HKWorkout
    
    @Environment(\.managedObjectContext) var managedObjectContext
   
    
    @State private var intervalToShow: String?
    @State private var distanceToShow: String?
    @State private var caloriesBurned: String?
    @State private var dateToFilter: String?
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        

        ScrollView {
            VStack {
                
                RunView(dateRun: "\(workoutItem.endDate)")
                Text("Run completed in \(intervalToShow ?? "")")
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
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
            
                
            }.onAppear {
                
                intervalToShow = formatRunTime(interval: workoutItem.duration)
                distanceToShow = String(format: "%.0f", workoutItem.totalDistance?.doubleValue(for: HKUnit.mile()) ?? 0)
                caloriesBurned = String(format: "%.0f", workoutItem.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie()) ?? 0)
            }.sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(selectedImage: self.$image, sourceType: .camera)
            }
        }
    }
    
    func formatRunTime(interval: TimeInterval) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(interval))!
    }

}
