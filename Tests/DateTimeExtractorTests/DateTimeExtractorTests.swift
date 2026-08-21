@testable import DateTimeExtractor
import XCTest

final class DateTimeExtractorTests: XCTestCase {
    func testPrioritizedFormatTypeIsDMY() throws {
        let paragragh = """
        1. Date match with both MDY and DMY 09-01-2023 23:59:59
        2. When time - date - time: 1:30:00 March 23 2023 11:30:45 PM
        3. Valid date and time: jun 23, 2023 1:23:56PM
        4. Today is 23/12/2023
        5. Current time is 11:47 AM
        6. Combine of them is 23/12/2023 11:47 AM
        7. In 2024, Labor Day will be on Monday, September 2, 2024 and Thanksgiving will be observed on Thursday, November 28 2024
        """

        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))

        let expectedDates = [
            createDate(day: 9, month: 1, year: 2023, hour: 23, minute: 59, second: 59, timeZone: laTimezone),
            createDate(day: 23, month: 3, year: 2023, hour: 1, minute: 30, second: 00, timeZone: laTimezone),
            createDate(day: 23, month: 6, year: 2023, hour: 13, minute: 23, second: 56, timeZone: laTimezone),
            createDate(day: 23, month: 12, year: 2023, hour: 0, minute: 0, second: 0, timeZone: laTimezone),
            createDate(day: 23, month: 12, year: 2023, hour: 11, minute: 47, second: 0, timeZone: laTimezone),
            createDate(day: 2, month: 9, year: 2024, hour: 0, minute: 0, second: 0, timeZone: laTimezone),
            createDate(day: 28, month: 11, year: 2024, hour: 0, minute: 0, second: 0, timeZone: laTimezone)
        ]

        let sut = createSUT(prioritizedFormatType: .DMY,
                            supportedDateTimeTypes: [.bothDateAndTime, .onlyDate],
                            timezone: laTimezone)
        let dates = sut.extractDate(string: paragragh).sorted(by: { $0 < $1 })
        XCTAssertEqual(dates.count, expectedDates.count)
        for (index, date) in expectedDates.enumerated() {
            XCTAssertEqual(dates[index], date)
        }
    }

    func testPrioritizedFormatTypeIsMDY() throws {
        let paragragh = """
        1. Date match with both MDY and DMY 09-01-2023 23:59:59
        2. When time - date - time: 1:30:00 March 23 2023 11:30:45 PM
        3. Valid date and time: jun 23, 2023 1:23:56PM
        4. Today is 23/12/2023
        5. Current time is 11:47 AM
        6. Combine of them is 23/12/2023 11:47 AM
        7. In 2024, Labor Day will be on Monday, September 2, 2024 and Thanksgiving will be observed on Thursday, November 28 2024
        """

        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))

        let expectedDates = [
            createDate(day: 23, month: 3, year: 2023, hour: 1, minute: 30, second: 00, timeZone: laTimezone),
            createDate(day: 23, month: 6, year: 2023, hour: 13, minute: 23, second: 56, timeZone: laTimezone),
            createDate(day: 1, month: 9, year: 2023, hour: 23, minute: 59, second: 59, timeZone: laTimezone),
            createDate(day: 23, month: 12, year: 2023, hour: 11, minute: 47, second: 0, timeZone: laTimezone)
        ]

        let sut = createSUT(prioritizedFormatType: .MDY,
                            supportedDateTimeTypes: [.bothDateAndTime],
                            timezone: laTimezone)
        let dates = sut.extractDate(string: paragragh).sorted(by: { $0 < $1 })
        XCTAssertEqual(dates.count, expectedDates.count)
        for (index, date) in expectedDates.enumerated() {
            XCTAssertEqual(dates[index], date)
        }
    }

    /// A time preceding its date must pair with the correct time even when the
    /// date's index in `dateResults` differs from the time's index in
    /// `timeResults`. Here there is a single time (index 0) but two dates, and
    /// the time-before-date pairing targets the second date (index 1); the old
    /// code indexed `timeResults[1]` and crashed.
    func testTimeBeforeDateWithDivergingIndices() throws {
        let paragraph = "01/02/2023 then 3:45pm 09/06/2023"
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))

        let expectedDates = [
            createDate(day: 1, month: 2, year: 2023, hour: 0, minute: 0, second: 0, timeZone: laTimezone),
            createDate(day: 9, month: 6, year: 2023, hour: 15, minute: 45, second: 0, timeZone: laTimezone)
        ]

        let sut = createSUT(prioritizedFormatType: .DMY,
                            supportedDateTimeTypes: [.bothDateAndTime, .onlyDate],
                            timezone: laTimezone)
        let dates = sut.extractDate(string: paragraph).sorted(by: { $0 < $1 })
        XCTAssertEqual(dates.count, expectedDates.count)
        for (index, date) in expectedDates.enumerated() {
            XCTAssertEqual(dates[index], date)
        }
    }

    /// `.onlyTime` results are anchored to the current day, so assert on the
    /// time-of-day components rather than an absolute Date.
    func testOnlyTimeSupport() throws {
        let paragraph = "Current time is 11:47 AM"
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))

        let sut = createSUT(prioritizedFormatType: .DMY,
                            supportedDateTimeTypes: [.onlyTime],
                            timezone: laTimezone)
        let dates = sut.extractDate(string: paragraph)
        XCTAssertEqual(dates.count, 1)

        var calendar = Calendar.current
        calendar.timeZone = laTimezone
        let components = calendar.dateComponents([.hour, .minute], from: dates[0])
        XCTAssertEqual(components.hour, 11)
        XCTAssertEqual(components.minute, 47)
    }

    /// A comma + double space (gap of 3) between date and time must still merge.
    func testAdjacencyToleratesSmallSeparatorGap() throws {
        let paragraph = "23/12/2023,  11:47 AM"
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))

        let expected = createDate(day: 23, month: 12, year: 2023, hour: 11, minute: 47, second: 0, timeZone: laTimezone)

        let sut = createSUT(prioritizedFormatType: .DMY,
                            supportedDateTimeTypes: [.bothDateAndTime],
                            timezone: laTimezone)
        let dates = sut.extractDate(string: paragraph)
        XCTAssertEqual(dates.count, 1)
        XCTAssertEqual(dates.first, expected)
    }

    /// A date and time separated by many words must NOT be merged.
    func testDistantDateAndTimeDoNotMerge() throws {
        let paragraph = "23/12/2023 is the date and the time is 11:47 AM"
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))

        let sut = createSUT(prioritizedFormatType: .DMY,
                            supportedDateTimeTypes: [.bothDateAndTime],
                            timezone: laTimezone)
        let dates = sut.extractDate(string: paragraph)
        XCTAssertEqual(dates.count, 0)
    }
}

private extension DateTimeExtractorTests {
    // swiftlint:disable:next function_parameter_count
    func createDate(day: Int, month: Int, year: Int, hour: Int, minute: Int, second: Int, timeZone: TimeZone) -> Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = hour
        components.minute = minute
        components.second = second

        var calendar = Calendar.current
        calendar.timeZone = timeZone

        return calendar.date(from: components)
    }
}

private extension DateTimeExtractorTests {
    func createSUT(prioritizedFormatType: DateFormatType,
                   supportedDateTimeTypes: [SupportedDateTimeType] = [.bothDateAndTime, .onlyDate],
                   timezone: TimeZone) -> DateTimeExtractor {
        var dateExtractor = DateExtractor(prioritizedFormatType: prioritizedFormatType)
        dateExtractor.registerDefaultExtractors()
        return DateTimeExtractor(dateExtractor: dateExtractor,
                                 supportedDateTimeTypes: supportedDateTimeTypes,
                                 timezone: timezone)
    }
}
