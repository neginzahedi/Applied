//
//  CalendarView.swift
//  Applied
//

import SwiftUI

struct CalendarView: View {
    
    @State private var selectedDate = Date()
    private let getMMMMDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    @State private var events: [Event] = [] // Sample events
    
    
    private let getYYYYDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Button(action: {
                    self.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedDate)!
                }) {
                    Image(systemName: "chevron.left")
                        .opacity(isPreviousButtonDisabled ? 0.5 : 1.0)
                }
                .disabled(isPreviousButtonDisabled)
                
                HStack{
                    Text(getMMMMDate.string(from: selectedDate))
                        .font(.title3)
                        .bold()
                    Text(getYYYYDate.string(from: selectedDate))
                        .font(.footnote)
                }
                Spacer()
                
                Button(action: {
                    self.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedDate)!
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.top,20)
            .padding(.horizontal,20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(getDaysInMonth(date: selectedDate), id: \.self) { day in
                        CardView(day: day)
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
    
    func getDaysInMonth(date: Date) -> [Date] {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        var days: [Date] = []
        
        if currentDate >= firstDayOfMonth {
            // If current date is after or equal to the first day of the month, start from current date
            let range = calendar.range(of: .day, in: .month, for: date)!
            let startingDay = calendar.component(.day, from: currentDate)
            days = (startingDay..<range.upperBound).compactMap { calendar.date(bySetting: .day, value: $0, of: date) }
        } else {
            // If current date is before the first day of the month, start from the first day of the month
            let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
            days = range.map { calendar.date(bySetting: .day, value: $0, of: firstDayOfMonth)! }
        }
        
        return days
    }
    
    
}

struct CardView: View {
    
    let day: Date
    
    @FetchRequest(fetchRequest: Event.fetch(), animation: .bouncy)
    
    var events: FetchedResults<Event>
    
    
    private static let getEDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    private static let getDDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        
        let matchingEvents = events.filter { Calendar.current.isDate($0.dueDate_, inSameDayAs: day) }
        let hasEvent = !matchingEvents.isEmpty
        
        ZStack{
            VStack(spacing: 10){
                Text(Self.getEDate.string(from: day))
                Text(Self.getDDate.string(from: day))
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
