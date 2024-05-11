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
        
        let matchingEvents = events.filter { Calendar.current.isDate($0.dueDate_, inSameDayAs: date) }
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text(Utils.formatDateToMonthDayYear(date))
                ScrollView{
                    VStack(alignment: .leading, spacing: 0){
                        ForEach(matchingEvents, id: \.dueDate_){ event in
                            HStack(spacing: 10){
                                // Date
                                HStack(spacing: 20){
                                    Text(Utils.hourIn12HourFormat(from: event.dueDate_))
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
                }
            }
            Spacer()
        }
    }
}

#Preview {
    DateEventsView(date: Date())
}
