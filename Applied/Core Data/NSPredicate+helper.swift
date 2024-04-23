//
//  NSPredicate+helper.swift
//  Applied
//
//  Created by Negin Zahedi on 2024-04-23.
//

import Foundation

extension NSPredicate {
    static let all = NSPredicate(format: "TRUEPREDICATE")
    static let none = NSPredicate(format: "FALSEPREDICATE")
}
