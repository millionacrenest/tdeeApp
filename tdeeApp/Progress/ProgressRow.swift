//
//  ProgressRow.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/21/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ProgressRow: View {
    var progressItem: ProgressEntity
    
    
    var body: some View {
        HStack() {
            Text("\(progressItem.pounds ?? "") pounds on")
            Text("\(progressItem.date!.description)")
        }
    }
}
  
