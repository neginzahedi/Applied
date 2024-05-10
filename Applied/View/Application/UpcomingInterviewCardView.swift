//
//  UpcomingInterviewCardView.swift
//  Applied
//
// TODO: replace default values with real user added values from core data

import SwiftUI

struct UpcomingInterviewCardView: View {
    @ObservedObject var event: Event
    
    var body: some View {
        HStack(spacing: 10){
            // Date
            HStack(spacing: 20){
                VStack{
                    Text(Utils.dayOfWeek(from: event.dueDate_))
                        .font(.caption)
                    Text(Utils.dayOfMonth(from: event.dueDate_))
                        .font(.headline)
                        .bold()
                }
                Rectangle()
                    .frame(width: 3, height: 50)
                    .foregroundColor(Color.black)
            }
            .frame(width: 60)
            
            // Datails
            VStack(alignment: .leading, spacing: 5){
                Text(event.title_)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .bold()
                Text("\(Utils.hourIn12HourFormat(from: event.dueDate_))")
                    .foregroundStyle(.secondary)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing){
                Menu {
                    Button(role: .destructive,action: {
                        Event.delete(event: event)
                    }, label: {
                        Text("Delete")
                    })
                    Button(action: {
                        print("")
                    }, label: {
                        Text("Edit")
                    })
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
                Spacer()
            }
        }
        .font(.caption)
        .padding()
        .frame(minHeight: 80)
        .frame(maxWidth: .infinity, alignment: .leading)
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
