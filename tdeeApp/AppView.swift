//
//  AppView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/9/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
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
                
            }
            
        }
    
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
