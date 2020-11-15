//
//  ProgressList.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/21/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ProgressList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: ProgressEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ProgressEntity.date, ascending: false)]
    ) var progressItems: FetchedResults<ProgressEntity>
    
    var body: some View {
        
        List(self.progressItems, rowContent: ProgressRow.init)
        
    }
    
}

struct ProgressList_Previews: PreviewProvider {
    static var previews: some View {
        ProgressList()
    }
}
