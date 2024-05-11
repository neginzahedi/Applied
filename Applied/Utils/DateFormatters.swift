//
//  DateFormatters.swift
//  Applied
//

import Foundation

struct DateFormatters {
    
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
}
