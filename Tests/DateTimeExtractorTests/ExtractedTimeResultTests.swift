//
//  ExtractedTimeResultTests.swift
//
//
//  Created by Harry Tran on 26/12/2023.
//

@testable import DateTimeExtractor
import XCTest

// swiftlint:disable line_length

final class ExtractedTimeResultTests: XCTestCase {
    func testSetTimeForDate() throws {
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
        let date = Date(month: 6, day: 6, year: 2023, timezone: laTimezone)

        let extractedTimeResult = ExtractedTimeResult(originalString: "12:30:30", range: NSRange(location: 0, length: 8),
                                                      formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "30", secondValue: "30", ampm: ""))
        let expectedDate = Date(month: 6, day: 6, year: 2023, hour: 12, minute: 30, second: 30, timezone: laTimezone)

        let result = extractedTimeResult.setTimeForDate(date: date, timezone: laTimezone)
        XCTAssertEqual(result, expectedDate)
    }
}

extension Date {
    init(month: Int, day: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, timezone: TimeZone) {
        var dateComponents = DateComponents()
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.year = year
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.timeZone = timezone
        dateComponents.calendar = .current
        self = Calendar.current.date(from: dateComponents)!
    }
}
