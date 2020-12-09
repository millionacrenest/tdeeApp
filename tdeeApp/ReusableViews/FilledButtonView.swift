//
//  FilledButtonView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/9/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct FilledButtonView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
    }
}

struct FilledButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
    }
}
