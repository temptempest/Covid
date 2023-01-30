//
//  Date+Extension.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

extension Date {
    static var today: Date {
        return Date()
    }
    static var lastMonth: Date {
        return Date().monthAgo
    }
    func stringValue() -> String {
        return String("\(self)".prefix(10))
    }
    var monthAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

extension DateFormatter {
    enum DateFormat: String {
        case long = "yyyy-MM-dd'T'HH:mm:ssZ"
        case heavy = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        case yearMonth = "yyyy/MM"
        case yearMonthDay = "yy/MM/dd"
    }
    static func getFormattedDate(string format: String) -> DateFormatter {
        let dateformat = DateFormatter()
        dateformat.timeZone = TimeZone(abbreviation: "GMT")
        dateformat.locale = NSLocale.current
        dateformat.dateFormat = format
        return dateformat
    }
    
    static func getFormattedDate(format: DateFormat) -> DateFormatter {
        return getFormattedDate(string: format.rawValue)
    }
}
