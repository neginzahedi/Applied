//
//  UpcomingInterviewCardView.swift
//  Applied
//
// TODO: replace default values with real user added values from core data

import SwiftUI

struct UpcomingInterviewCardView: View {
    var body: some View {
        HStack(spacing: 20){
            HStack(spacing: 20){
                VStack{
                    Text("Wed")
                    Text("17")
                        .font(.footnote)
                }
                Rectangle()
                    .frame(width: 3, height: 40)
                    .foregroundColor(Color.black)
            }
            VStack(alignment: .leading){
                Text("Robinhood")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                Text("2 pm - 3 pm")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .font(.caption)
        .bold()
        .padding()
        .frame(width: 200,height: 80)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    UpcomingInterviewCardView()
}
