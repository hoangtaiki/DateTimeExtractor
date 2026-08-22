//
//  ExtractedDateResult.swift
//
//
//  Created by Harry Tran on 21/12/2023.
//

import Foundation

/// Caches `DateFormatter` instances keyed by format string + timezone.
///
/// `DateFormatter` is one of the most expensive Foundation objects to allocate, and this package
/// creates one per matched result. The finite set of format/timezone combinations makes a cache a
/// safe bounded win. The lock guards only the dictionary; `DateFormatter`'s formatting/parsing
/// methods are themselves thread-safe as long as the instance is not mutated after configuration.
enum DateFormatterCache {
    private static let lock = NSLock()
    private static var cache = [String: DateFormatter]()

    static func formatter(format: String, timezone: TimeZone) -> DateFormatter {
        let key = "\(format)|\(timezone.identifier)"
        lock.lock()
        defer { lock.unlock() }
        if let existing = cache[key] {
            return existing
        }
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = format
        cache[key] = formatter
        return formatter
    }
}

public struct ExtractedDateResult: Equatable {
    public let originalString: String
    public let range: NSRange
    public let formatComponents: DateFormatComponents

    public init(originalString: String, range: NSRange, formatComponents: DateFormatComponents) {
        self.originalString = originalString
        self.range = range
        self.formatComponents = formatComponents
    }

    public static func == (lhs: ExtractedDateResult, rhs: ExtractedDateResult) -> Bool {
        return lhs.originalString == rhs.originalString
            && lhs.range == rhs.range
            && lhs.formatComponents.getFormat() == rhs.formatComponents.getFormat()
            && lhs.formatComponents.getFormattedString() == rhs.formatComponents.getFormattedString()
    }

    public init(original: String, range: NSRange, day: String, month: String, year: String, formatType: DateFormatType) {
        originalString = original
        self.range = range
        formatComponents = DateFormatComponents(dayValue: day, monthValue: month, yearValue: year, formatType: formatType)
    }
}

public extension ExtractedDateResult {
    func getDate(timezone: TimeZone) -> Date? {
        let dateFormatter = DateFormatterCache.formatter(format: formatComponents.getFormat(), timezone: timezone)
        return dateFormatter.date(from: formatComponents.getFormattedString())
    }

    func getDate(withTimeResult timeResult: ExtractedTimeResult, timezone: TimeZone) -> Date? {
        let dateTimeString = "\(formatComponents.getFormattedString()) \(timeResult.formatComponents.getFormattedString())"
        let dateTimeFormat = "\(formatComponents.getFormat()) \(timeResult.formatComponents.getFormat())"
        let dateFormatter = DateFormatterCache.formatter(format: dateTimeFormat, timezone: timezone)
        return dateFormatter.date(from: dateTimeString)
    }
}

public extension Array where Iterator.Element == ExtractedDateResult {
    func groupResultsBySameRange() -> [[ExtractedDateResult]] {
        let sortedElements = sorted(by: { $0.range.location < $1.range.location })

        if sortedElements.isEmpty {
            return []
        }

        if sortedElements.count == 1 {
            return [self]
        }

        var sameRangeElements: [[ExtractedDateResult]] = [[sortedElements[0]]]
        for index in 1 ..< sortedElements.count {
            let currentElement = sortedElements[index]
            let previousElement = sortedElements[index - 1]

            if currentElement.range == previousElement.range {
                sameRangeElements[sameRangeElements.count - 1].append(currentElement)
            } else {
                sameRangeElements.append([currentElement])
            }
        }

        return sameRangeElements
    }
}
