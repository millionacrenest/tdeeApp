//
//  Setting.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 12/10/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI

struct Setting {
    var name: String
    var value: Value
}

extension Setting {
    enum Value {
        case bool(Bool)
        case int(Int)
        case string(String)
        case group([Setting])
    }
}

struct SettingGroup {
    var name: String
    var settings: [Setting]

    init(name: String,
         @SettingBuilder builder: () -> [Setting]) {
        self.name = name
        self.settings = builder()
    }
}

@_functionBuilder
struct SettingBuilder {
    static func buildBlock() -> [Setting] { [] }
}

func makeSettings(@SettingBuilder _ content: () -> [Setting]) -> [Setting] {
    content()
}

let settings = makeSettings {}

extension SettingBuilder {
    static func buildBlock(_ settings: Setting...) -> [Setting] {
        settings
    }
}

protocol SettingConvertible {
    func asSettings() -> [Setting]
}

extension Setting: SettingConvertible {
    func asSettings() -> [Setting] { [self] }
}

extension SettingGroup: SettingConvertible {
    func asSettings() -> [Setting] {
        [Setting(name: name, value: .group(settings))]
    }
}

extension SettingBuilder {
    static func buildBlock(_ values: SettingConvertible...) -> [Setting] {
        values.flatMap { $0.asSettings() }
    }
}

extension Array: SettingConvertible where Element == Setting {
    func asSettings() -> [Setting] { self }
}

extension SettingBuilder {
    static func buildIf(_ value: SettingConvertible?) -> SettingConvertible {
        value ?? []
    }
}

extension SettingBuilder {
    static func buildEither(first: SettingConvertible) -> SettingConvertible {
        first
    }

    static func buildEither(second: SettingConvertible) -> SettingConvertible {
        second
    }
}

extension Setting {
    struct Empty: SettingConvertible {
        func asSettings() -> [Setting] { [] }
    }
}

enum UserAccessLevel {
    case restricted
    case normal
    case experimental
}
