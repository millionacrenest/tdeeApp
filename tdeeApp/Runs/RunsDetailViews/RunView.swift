//
//  RunView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/17/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct RunView: View {
    
    var workoutItem: RunLogged
    var body: some View {
        RunDetail(workoutItem: workoutItem)
    }
}

