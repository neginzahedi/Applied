import Foundation

struct DateUtils {
    // MARK: - Date Formatters
    
    /// Date formatter for formatting dates to "dd MMMM yyyy" format.
    static let monthDayYearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    /// Date formatter for formatting dates to abbreviated day of the week format ("E").
    static let abbreviatedDayOfWeekFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter
    }()
    
    /// Date formatter for formatting dates to day of the month format ("d").
    static let dayOfMonthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    /// Date formatter for formatting dates to 12-hour format with "am" or "pm" ("h:mm a").
    static let twelveHourFormatFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter
    }()
    
    /// Date formatter for formatting dates to month format ("MMMM").
    static let monthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }()
    
    /// Date formatter for formatting dates to year format ("yyyy").
    static let yearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }()
    
    // MARK: - Date Manipulation
    
    /// Get an array of dates representing the days in the month of the given date.
    /// - Parameter date: The date for which to get the days of the month.
    /// - Returns: An array of dates representing the days in the month of the given date.
    static func getDaysInMonth(date: Date) -> [Date] {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        var days: [Date] = []
        
        if currentDate >= firstDayOfMonth {
            // If the current date is after or equal to the first day of the month, start from the current date
            let range = calendar.range(of: .day, in: .month, for: date)!
            let startingDay = calendar.component(.day, from: currentDate)
            days = (startingDay..<range.upperBound).compactMap { calendar.date(bySetting: .day, value: $0, of: date) }
        } else {
            // If the current date is before the first day of the month, start from the first day of the month
            let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
            days = range.map { calendar.date(bySetting: .day, value: $0, of: firstDayOfMonth)! }
        }
        
        return days
    }
}
