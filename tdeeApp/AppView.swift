//
//  AppView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/9/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
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
    
    @State var showingDetail = false
    
    var body: some View {
        
        
        ZStack {
                   
                TabView {
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                    ProgressView()
                        .tabItem {
                            Image(systemName: "rosette")
                            Text("Progress")
                        }
                    RunsView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("Runs")
                        }
                    ShoesView()
                        .tabItem {
                            Image(systemName: "hourglass")
                            Text("Shoe Life")
                        }
                    }
                    
            }.onAppear {
                if (userAccount.count == 0) {
                    self.showingDetail.toggle()
                    let userAccount = User(context: managedObjectContext)
                    userAccount.userID = UUID()
                    print("creating user ", userAccount.userID)
                    if managedObjectContext.hasChanges {
                        do {
                            try managedObjectContext.save()
                            
                        } catch {
                            // Show the error here
                        }
                    }
                } else {
                    print("welcome back user ", userAccount.first?.userID)
                    print(workouts.count)
                }
            }.sheet(isPresented: $showingDetail) {
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                SettingsView().environment(\.managedObjectContext, context)
            }
    }
    
    
}
    


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
