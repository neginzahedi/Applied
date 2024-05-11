//
//  UpcomingInterviewCardView.swift
//  Applied
//

import SwiftUI

struct UpcomingInterviewCardView: View {
    
    @ObservedObject var event: Event
    
    @State private var showDeleteConfirmationDialog: Bool = false
    
    var body: some View {
        HStack(spacing: 10){
            // Date
            HStack(spacing: 20){
                VStack{
                    Text(DateFormatters.abbreviatedDayOfWeekFormatter.string(from: event.dueDate_))
                        .font(.caption)
                    Text(DateFormatters.dayOfMonthFormatter.string(from: event.dueDate_))
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
                Text(DateFormatters.twelveHourFormatFormatter.string(from: event.dueDate_))
                    .foregroundStyle(.secondary)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing){
                Spacer()
                Button {
                    self.showDeleteConfirmationDialog.toggle()
                } label: {
                    Image(systemName:"trash")
                }
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
        
        .confirmationDialog("Delete Event",
                            isPresented: $showDeleteConfirmationDialog,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                Event.delete(event: event)
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
        
    }
}

#Preview {
    UpcomingInterviewCardView(event: Event.example)
}
