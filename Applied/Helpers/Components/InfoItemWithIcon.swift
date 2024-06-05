//
//  InfoItemWithIcon.swift
//  Applied
//

import SwiftUI

struct InfoItemWithIcon: View {
    
    let icon: String
    let title: String
    let text: String
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: icon)
                Text(title)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .font(.caption)
            HStack{
                Text(text)
                Spacer()
            }
            .font(.footnote)
        }
    }
}

#Preview {
    InfoItemWithIcon(icon: "globe.desk", title: "Location", text: "Toronto")
}
