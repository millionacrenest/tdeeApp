//
//  Date+extensions.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//
import Foundation

extension Date {
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}
