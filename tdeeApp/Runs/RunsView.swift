//
//  RunsView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct RunsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var showingDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                RunsList()
            }.navigationTitle("Running Log")
        .navigationBarItems(trailing:
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Image(systemName: "gear").imageScale(.large)
            }.sheet(isPresented: $showingDetail) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                RunsView().environment(\.managedObjectContext, context)
            })
        }
    }
    
}

struct RunsView_Previews: PreviewProvider {
    static var previews: some View {
        RunsView()
    }
}
