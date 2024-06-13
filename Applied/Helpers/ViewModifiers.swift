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
            .background(.customBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            
    }
}
