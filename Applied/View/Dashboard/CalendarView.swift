//
//  CalendarView.swift
//  Applied
//

import SwiftUI

struct CalendarView: View {
    
    // MARK: - Properties
    
    @State private var selectedDate = Date()
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0){
            // Month and Year Header
            MonthYearHeader(selectedDate: $selectedDate)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(DateUtils.getDaysInMonth(date: selectedDate), id: \.self) { date in
                        NavigationLink(destination: DateEventsView(date: date)) {
                            DayCardView(day: date)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
    
    private var isPreviousButtonDisabled: Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentDay = Calendar.current.component(.day, from: currentDate)
        let selectedMonth = Calendar.current.component(.month, from: selectedDate)
        let selectedDay = Calendar.current.component(.day, from: selectedDate)
        
        return selectedMonth == currentMonth && selectedDay <= currentDay
    }
}

// MARK: - Subviews

// MARK: - Month and Year Header View
struct MonthYearHeader: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack {
            Button(action: {
                self.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
            }) {
                Image(systemName: "chevron.left")
                    .opacity(isPreviousButtonDisabled ? 0.5 : 1.0)
            }
            .disabled(isPreviousButtonDisabled)
            
            HStack{
                Text(DateUtils.monthFormatter.string(from: selectedDate))
                    .font(.title3)
                    .bold()
                Text(DateUtils.yearFormatter.string(from: selectedDate))
                    .font(.footnote)
            }
            Spacer()
            
            Button(action: {
                self.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    private var isPreviousButtonDisabled: Bool {
        let currentDate = Calendar.current.startOfDay(for: Date())
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentDay = Calendar.current.component(.day, from: currentDate)
        let selectedMonth = Calendar.current.component(.month, from: selectedDate)
        let selectedDay = Calendar.current.component(.day, from: selectedDate)
        
        return selectedMonth == currentMonth && selectedDay <= currentDay
    }
}

// MARK: - Day Card View

struct DayCardView: View {
    
    let day: Date
    
    @FetchRequest(fetchRequest: Event.fetch(), animation: .bouncy)
    
    var events: FetchedResults<Event>
    
    
    var body: some View {
        
        let matchingEvents = events
            .filter { Calendar.current.isDate($0.dueDate_, inSameDayAs: day) }
            .filter {$0.dueDate_ > Date() }
        
        let hasEvent = !matchingEvents.isEmpty
        
        ZStack{
            VStack(spacing: 10){
                Text(DateUtils.abbreviatedDayOfWeekFormatter.string(from: day))
                Text(DateUtils.dayOfMonthFormatter.string(from: day))
            }
            .font(.callout)
            .bold()
            .frame(width: 40, height: 50)
            .foregroundColor(.primary)
            .modifier(RoundedRectangleModifier(cornerRadius: 10))
            
            if hasEvent {
                Circle()
                    .foregroundStyle(.secondary)
                    .frame(width: 20, height: 20)
                    .offset(x: 30, y: -30)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
