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

struct RunView: View {
    var dateRun: String
    var body: some View {
        // ChatList body will be called every time but this ChatView body is only run when there is a new teamName so that's ok.
        RunDetail(runInfo: FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "dateRun = %@", dateRun)))
    }
}

struct RunDetail : View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest var runInfo: FetchedResults<RunLogged>
    
    @State private var runDescription: String = ""
    @State private var runImage = UIImage()
    
    var body: some View {
        VStack {
            Text("run info \(runInfo.first?.dateRun ?? "")")
            Text(runInfo.first?.runDescription ?? "")
            TextField("run description:", text: $runDescription)
            Image(uiImage: UIImage(data: runInfo.first?.runImage ?? Data()) ?? UIImage()).resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            ImagePicker(selectedImage: $runImage, sourceType: .camera)
            Button(action: {
                saveRunData()
            }) {
                Text("SAVE CHANGES TO RUN LOG")
            }
        }
    }
    
    func saveRunData() {
        runInfo.first?.runDescription = runDescription
        runInfo.first?.runImage = runImage.jpegData(compressionQuality: 1.0)
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Show the error here
            }
        }
    }
}
