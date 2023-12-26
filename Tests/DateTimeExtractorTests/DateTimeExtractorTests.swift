import XCTest
@testable import DateTimeExtractor

final class DateTimeExtractorTests: XCTestCase {
        
    func testPrioritizedFormatTypeIsDMY() {
        let paragragh = """
        1. Date match with both MDY and DMY 09-01-2023 23:59:59
        2. When time - date - time: 1:30:00 March 23 2023 11:30:45 PM
        3. Valid date and time: jun 23, 2023 1:23:56PM
        4. Today is 23/12/2023
        5. Current time is 11:47 AM
        6. Combine of them is 23/12/2023 11:47 AM
        7. In 2024, Labor Day will be on Monday, September 2, 2024 and Thanksgiving will be observed on Thursday, November 28 2024
        """
        
        let laTimezone = TimeZone(identifier: "America/Los_Angeles")!

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
    
    func testPrioritizedFormatTypeIsMDY() {
        let paragragh = """
        1. Date match with both MDY and DMY 09-01-2023 23:59:59
        2. When time - date - time: 1:30:00 March 23 2023 11:30:45 PM
        3. Valid date and time: jun 23, 2023 1:23:56PM
        4. Today is 23/12/2023
        5. Current time is 11:47 AM
        6. Combine of them is 23/12/2023 11:47 AM
        7. In 2024, Labor Day will be on Monday, September 2, 2024 and Thanksgiving will be observed on Thursday, November 28 2024
        """
        
        let laTimezone = TimeZone(identifier: "America/Los_Angeles")!
        
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
}

private extension DateTimeExtractorTests {
    
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
        let dateTimeExtractor = DateTimeExtractor(dateExtractor: dateExtractor,
                                                  supportedDateTimeTypes: supportedDateTimeTypes,
                                                  timezone: timezone)
        return dateTimeExtractor
    }
}
