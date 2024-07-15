//
//  DateEventsView.swift
//  Applied
//

import SwiftUI

struct DateEventsView: View {
    
    @FetchRequest(fetchRequest: Event.fetch(), animation: .bouncy)
    var events: FetchedResults<Event>
    
    let date: Date
    
    var body: some View {
        
        let matchingEvents = events
            .filter { Calendar.current.isDate($0.dueDate_, inSameDayAs: date)}
            .filter {$0.dueDate_ > Date() }
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 20){
                HStack{
                    Text(DateUtils.monthDayYearFormatter.string(from: date))
                        .font(.headline)
                    Spacer()
                }
                if matchingEvents.isEmpty {
                    Text("There are no upcoming events for this date.")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView{
                        VStack(alignment: .leading){
                            ForEach(matchingEvents, id: \.dueDate_){ event in
                                EventCardView(event: event)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Spacer()
        }
    }
}

struct EventCardView: View {
    
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
            .background(.customBackground)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
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
            Text(DateUtils.twelveHourFormatFormatter.string(from: event.dueDate_))
            Rectangle()
                .frame(width: 3, height: 50)
                .foregroundColor(.primary)
        }
        .frame(width: 80)
    }
    
    private var detailsView: some View{
        VStack(alignment: .leading, spacing: 5){
            Text(event.title_)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .bold()
            Text(event.application_.company_)
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
#Preview {
    DateEventsView(date: Date())
}
