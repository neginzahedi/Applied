//
//  Utils.swift
//  Applied
//

import Foundation

struct Utils {
    static func formatDateToMonthDayYear(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    static let dayOfWeek: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // Use "E" for abbreviated day of the week
        return dateFormatter
    }()
    
    static let dayOfMonth: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Use "d" for the day of the month as a number
        return dateFormatter
    }()
    
    static func hourIn12HourFormat(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // Use "h a" for the hour in 12-hour format with "am" or "pm"
        return dateFormatter.string(from: date)
    }
    
    static func test(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy h a" // Use "h a" for the hour in 12-hour format with "am" or "pm"
        return dateFormatter.string(from: date)
    }
    
    static let month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
}
