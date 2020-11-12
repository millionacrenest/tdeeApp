//
//  RunsView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct RunsView: View {
    
    @State var showingDetail = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Coming Soon").bold()
                    Text("~ List of Running Workouts Imported from WatchKit ~")
                }
            }.navigationTitle("Recorded Runs")
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
}

struct RunsView_Previews: PreviewProvider {
    static var previews: some View {
        RunsView()
    }
}
