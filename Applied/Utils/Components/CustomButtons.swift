//
//  CustomButtons.swift
//  Applied
//

import SwiftUI

struct BackButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "arrow.backward")
        })
    }
}
