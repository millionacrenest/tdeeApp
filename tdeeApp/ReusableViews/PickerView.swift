//
//  PickerView.swift
//  tdeeApp
//
//  Created by McEntire, Allison on 11/12/20.
//  Copyright © 2020 Deloitte Digital. All rights reserved.
//

import SwiftUI


struct PickerView: View {
    
    
    typealias Label = String
    typealias Entry = String

    let data: [ (Label, [Entry]) ]
    @Binding var selection: [Entry]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<self.data[column].1.count) { row in
                            Text(verbatim: self.data[column].1[row])
                            .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                    .clipped()
                }
            }
        }
    }
    
}

struct MultiSegmentPickerViewModel {
    typealias Label = String // The label for each picker
    typealias Selection = Binding<Int> // The selection index for each picker
    typealias PickerDisplayValues = [String] // The respective values for the picker
    
      // A multi-segment picker is composed of an array of the above types
    let segments: [(Label, Selection, PickerDisplayValues)]
}
