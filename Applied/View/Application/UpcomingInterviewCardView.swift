//
//  UpcomingInterviewCardView.swift
//  Applied
//

import SwiftUI

struct UpcomingInterviewCardView: View {
    
    // MARK: - Properties
    
    @ObservedObject var event: Event
    
    @State private var showDeleteConfirmationDialog: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        content
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
        
        // MARK: - Confirmation Dialog
        
            .confirmationDialog("Delete Event",
                                isPresented: $showDeleteConfirmationDialog,
                                titleVisibility: .visible) {
                deleteEventButton
            } message: {
                Text("Are you sure you want to delete this event?")
            }
    }
    
    // MARK: - Computed Properties
    
    private var content: some View{
        HStack(spacing: 10){
            dateView
            detailsView
            deleteButtonView
        }
    }
    
    private var dateView: some View{
        HStack(spacing: 20){
            VStack{
                Text(DateUtils.abbreviatedDayOfWeekFormatter.string(from: event.dueDate_))
                    .font(.caption)
                Text(DateUtils.dayOfMonthFormatter.string(from: event.dueDate_))
                    .font(.headline)
                    .bold()
            }
            Rectangle()
                .frame(width: 3, height: 50)
                .foregroundColor(Color.black)
        }
        .frame(width: 60)
    }
    
    private var detailsView: some View{
        VStack(alignment: .leading, spacing: 5){
            Text(event.title_)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .bold()
            Text(DateUtils.twelveHourFormatFormatter.string(from: event.dueDate_))
                .foregroundStyle(.secondary)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var deleteButtonView: some View{
        VStack(alignment: .trailing){
            Spacer()
            Button {
                self.showDeleteConfirmationDialog.toggle()
            } label: {
                Image(systemName:"trash")
            }
        }
    }
    
    private var deleteEventButton: some View{
        Button(role: .destructive) {
            Event.delete(event: event)
        } label: {
            Text("Delete")
        }
    }
}

#if DEBUG
#Preview {
    UpcomingInterviewCardView(event: Event.example)
}
#endif
