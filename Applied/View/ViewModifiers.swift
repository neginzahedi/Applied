//
//  ViewModifiers.swift
//  Applied
//

import SwiftUI

struct RoundedRectangleModifier: ViewModifier {
    var cornerRadius : CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.black.opacity(0.1), lineWidth: 1)
            )
    }
}
