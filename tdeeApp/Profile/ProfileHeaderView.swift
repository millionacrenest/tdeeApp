//
//  ProfileHeaderView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct ProfileHeaderView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [Color.green, Color.purple ]), startPoint: .leading, endPoint: .trailing)
        content
            .padding()
            .cornerRadius(16)
            .transition(.move(edge: .top))
            .animation(.spring())
         
        }
        
    }
}
