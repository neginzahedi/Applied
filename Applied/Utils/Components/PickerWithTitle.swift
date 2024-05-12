//
//  PickerWithTitle.swift
//  Applied
//

import SwiftUI

struct PickerWithTitle: View {
    
    let title: String
    let options: [String]
    
    @Binding var selection: String
    
    var body: some View {
        HStack {
            Text(title).bold()
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.description).tag(option)
                }
            }
        }
    }
}

