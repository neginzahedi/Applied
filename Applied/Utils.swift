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
}
