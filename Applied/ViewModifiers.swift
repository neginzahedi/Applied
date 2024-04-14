//
//  ViewModifiers.swift
//  Applied
//

import SwiftUI

struct RoundedRectangleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary, lineWidth: 1)
            )
    }
}
