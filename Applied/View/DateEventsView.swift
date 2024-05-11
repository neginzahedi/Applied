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
                                HStack(spacing: 10){
                                    // Date
                                    HStack(spacing: 20){
                                        Text(DateUtils.twelveHourFormatFormatter.string(from: event.dueDate_))
                                        Rectangle()
                                            .frame(width: 3, height: 50)
                                            .foregroundColor(Color.black)
                                    }
                                    .frame(width: 80)
                                    
                                    let company = event.application_.company_
                                    
                                    // Datails
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(event.title_)
                                            .font(.footnote)
                                            .multilineTextAlignment(.leading)
                                            .bold()
                                        Text(company)
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
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            Spacer()
        }
    }
}

#Preview {
    DateEventsView(date: Date())
}
