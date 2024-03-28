//
//  Utils.swift
//  Applied
//
//  Created by Negin Zahedi on 2024-03-27.
//

import Foundation

struct Utils {
    static func formatDateToMonthDayYear(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
