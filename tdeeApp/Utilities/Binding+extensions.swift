//
//  Binding+extensions.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/16/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

extension Binding {
    /// Execute block when value is changed.
    ///
    /// Example:
    ///
    ///     Slider(value: $amount.didSet { print($0) }, in: 0...10)
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
    
    
}
