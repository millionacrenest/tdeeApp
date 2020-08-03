//
//  UserSettings.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 8/2/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class UserSettings: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var birthday = Date()
    @Published var heightInCM: Int?
    @Published var startingWeightInKg: Int?
    @Published var currentWeightInKg: Int?
    @Published var goalWeightInKG: Int?
    @Published var desiredDaysPerPoundLost = 7
    @Published var profileImage: UIImage?
    @Published var currentTDEE: Int = 2300
    @Published var caloriesIn: Int = 1600
    @Published var prefersImperial = false
    
    
}
