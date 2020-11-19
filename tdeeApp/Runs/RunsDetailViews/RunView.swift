//
//  RunView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/17/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct RunView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    var dateRun: String
    var body: some View {
        // ChatList body will be called every time but this ChatView body is only run when there is a new teamName so that's ok.
        RunDetail(runInfo: FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "dateRun = %@", dateRun)))
    }
}

