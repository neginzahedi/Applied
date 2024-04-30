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
    
    static func dayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // Use "E" for abbreviated day of the week
        return dateFormatter.string(from: date)
    }
    
    static func dayOfMonth(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Use "d" for the day of the month as a number
        return dateFormatter.string(from: date)
    }
    
    static func hourIn12HourFormat(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a" // Use "h a" for the hour in 12-hour format with "am" or "pm"
        return dateFormatter.string(from: date)
    }
}
