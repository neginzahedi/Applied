//
//  TextFieldWithTitle.swift
//  Applied
//

import SwiftUI

struct TextFieldWithTitle: View {
    
    let title: String
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            TextField(placeholder, text: $text)
                .modifier(RoundedRectangleModifier(cornerRadius: 10))
                .keyboardType(.default)
                .submitLabel(.done)
            
        }
    }
}

