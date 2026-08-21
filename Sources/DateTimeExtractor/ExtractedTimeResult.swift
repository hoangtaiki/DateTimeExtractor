//
//  ExtractedTimeResult.swift
//
//
//  Created by Harry Tran on 21/12/2023.
//

import Foundation

public struct ExtractedTimeResult: Equatable {
    public let originalString: String
    public let range: NSRange
    public let formatComponents: TimeFormatComponents

    public static func == (lhs: ExtractedTimeResult, rhs: ExtractedTimeResult) -> Bool {
        return lhs.originalString == rhs.originalString
            && lhs.range == rhs.range
            && lhs.formatComponents.getFormat() == rhs.formatComponents.getFormat()
            && lhs.formatComponents.getFormattedString() == rhs.formatComponents.getFormattedString()
    }

    public init(originalString: String, range: NSRange, formatComponents: TimeFormatComponents) {
        self.originalString = originalString
        self.range = range
        self.formatComponents = formatComponents
    }

    public init(original: String, range: NSRange, hour: String, minute: String, second: String = "", ampm: String = "") {
        originalString = original
        self.range = range
        formatComponents = TimeFormatComponents(hourValue: hour, minuteValue: minute, secondValue: second, ampm: ampm)
    }
}

public extension ExtractedTimeResult {
    func setTimeForDate(date: Date = Date(), timezone: TimeZone) -> Date? {
        let dateFormat = "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: date)

        let dateTimeString = "\(formattedDate) \(formatComponents.getFormattedString())"
        let dateTimeFormat = "\(dateFormat) \(formatComponents.getFormat())"
        dateFormatter.dateFormat = dateTimeFormat
        return dateFormatter.date(from: dateTimeString)
    }
}
