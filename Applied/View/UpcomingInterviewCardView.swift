//
//  UpcomingInterviewCardView.swift
//  Applied
//
// TODO: replace default values with real user added values from core data

import SwiftUI

struct UpcomingInterviewCardView: View {
    @ObservedObject var event: Event
    
    var body: some View {
        HStack(spacing: 20){
            HStack(spacing: 20){
                VStack{
                    Text(Utils.dayOfWeek(from: event.dueDate_))
                    Text(Utils.dayOfMonth(from: event.dueDate_))
                        .font(.footnote)
                }
                Rectangle()
                    .frame(width: 3, height: 40)
                    .foregroundColor(Color.black)
            }
            VStack(alignment: .leading){
                Text(event.title_)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                Text("\(Utils.hourIn12HourFormat(from: event.dueDate_))")
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .font(.caption)
        .bold()
        .padding()
        .frame(height: 80)
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
    UpcomingInterviewCardView(event: Event.example)
}
