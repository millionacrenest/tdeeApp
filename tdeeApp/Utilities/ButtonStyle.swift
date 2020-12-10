//
//  ButtonStyle.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/9/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

enum ButtonStylePalette: ButtonStyle {
   case primary
   case secondary
   case destructive
    func makeBody(configuration: Configuration) -> some View {
        switch self {
        case .primary:
            return AnyView(PrimaryButtonStyle(color: ColorsPalette.primary.color).makeBody(configuration: configuration))
        case .secondary:
            return AnyView(SecondaryButtonStyle(color: ColorsPalette.primary.color).makeBody(configuration: configuration))
        case .destructive:
            return AnyView(DestructiveButtonStyle(color: ColorsPalette.primary.color).makeBody(configuration: configuration))
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = ColorsPalette.primary.color
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration, color: color)
    }
}

struct PrimaryButton: View {
    let configuration: PrimaryButtonStyle.Configuration
    let color: Color
    var body: some View {
        return configuration.label
        .padding(20)
        .foregroundColor(Color.white)
        .background(color)
        .cornerRadius(5)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var color: Color = ColorsPalette.primary.color
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration, color: color)
    }
}

struct SecondaryButton: View {
    let configuration: SecondaryButtonStyle.Configuration
    let color: Color
    var body: some View {
        return configuration.label
        .padding(20)
        .foregroundColor(Color.white)
        .background(color)
        .cornerRadius(5)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    var color: Color = ColorsPalette.primary.color
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration, color: color)
    }
}

struct DestructiveButton: View {
    let configuration: DestructiveButtonStyle.Configuration
    let color: Color
    var body: some View {
        return configuration.label
        .padding(20)
        .foregroundColor(Color.white)
        .background(color)
        .cornerRadius(5)
    }
}
