//
//  DateExtractorTests.swift
//
//
//  Created by Harry Tran on 21/12/2023.
//

@testable import DateTimeExtractor
import XCTest

// swiftlint:disable line_length

struct MockDateExtracter: DateExtractable {
    func extractDateStringAndFormat(string _: String) -> [ExtractedDateResult] {
        return []
    }
}

final class DateExtractorTests: XCTestCase {
    func testRegisterDefaultExtractors() {
        var dateExtractor = DateExtractor()
        dateExtractor.registerDefaultExtractors()

        XCTAssertEqual(dateExtractor.extractors.count, 3)
        XCTAssertTrue(dateExtractor.extractors.contains { $0 is DateDMYExtractor })
        XCTAssertTrue(dateExtractor.extractors.contains { $0 is DateMDYExtractor })
        XCTAssertTrue(dateExtractor.extractors.contains { $0 is DateYMDExtractor })
    }

    func testRegisterExtractor() {
        var dateExtractor = DateExtractor()
        let customExtractor = MockDateExtracter()
        dateExtractor.registerExtractor(customExtractor)

        XCTAssertEqual(dateExtractor.extractors.count, 1)
        XCTAssertTrue(dateExtractor.extractors.contains { $0 is MockDateExtracter })
    }

    func testChangePrioritizedFormatType() {
        var dateExtractor = DateExtractor()
        XCTAssertEqual(dateExtractor.prioritizedFormatType, .MDY)
        dateExtractor.setPrioritizedFormatType(.DMY)
        XCTAssertEqual(dateExtractor.prioritizedFormatType, .DMY)
        dateExtractor.setPrioritizedFormatType(.YMD)
        XCTAssertEqual(dateExtractor.prioritizedFormatType, .YMD)
        dateExtractor.setPrioritizedFormatType(.MDY)
        XCTAssertEqual(dateExtractor.prioritizedFormatType, .MDY)
    }

    func testDateExtractorWithPrioritizedFormatTypeIsDMY() {
        let paragraph = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        Dates: 01/01/01 09/09/23 1.9.19 10-10-24 12.12.12 11-11-2011 11-9-11 is valid for both dd/mm/yy and mm/dd/yy
        Dates: 04/13/2033 11/28/11 21/12/23 still can be recognized as mm/dd/yy because second component > 12
        Dates: 01-august-1920 12-sep-23 february-29-2024 01 june 23 31/10/1999 01-AUGUST-18 24 JAN 2022 are acceptable
        Dates: 2023-12-27 2023-12-09 2023-07-10 are acceptable but 2023-27-12 2023-12-9 2023-7-10 are not acceptable
        """
        let expectedResults = [
            ExtractedDateResult(original: "01/01/01", range: NSRange(location: 64, length: 8), day: "01", month: "01", year: "01", formatType: .DMY),
            ExtractedDateResult(original: "09/09/23", range: NSRange(location: 73, length: 8), day: "09", month: "09", year: "23", formatType: .DMY),
            ExtractedDateResult(original: "1.9.19", range: NSRange(location: 82, length: 6), day: "1", month: "9", year: "19", formatType: .DMY),
            ExtractedDateResult(original: "10-10-24", range: NSRange(location: 89, length: 8), day: "10", month: "10", year: "24", formatType: .DMY),
            ExtractedDateResult(original: "12.12.12", range: NSRange(location: 98, length: 8), day: "12", month: "12", year: "12", formatType: .DMY),
            ExtractedDateResult(original: "11-11-2011", range: NSRange(location: 107, length: 10), day: "11", month: "11", year: "2011", formatType: .DMY),
            ExtractedDateResult(original: "11-9-11", range: NSRange(location: 118, length: 7), day: "11", month: "9", year: "11", formatType: .DMY),
            ExtractedDateResult(original: "04/13/2033", range: NSRange(location: 173, length: 10), day: "13", month: "04", year: "2033", formatType: .MDY),
            ExtractedDateResult(original: "11/28/11", range: NSRange(location: 184, length: 8), day: "28", month: "11", year: "11", formatType: .MDY),
            ExtractedDateResult(original: "21/12/23", range: NSRange(location: 193, length: 8), day: "21", month: "12", year: "23", formatType: .DMY),
            ExtractedDateResult(original: "01-august-1920", range: NSRange(location: 275, length: 14), day: "01", month: "august", year: "1920", formatType: .DMY),
            ExtractedDateResult(original: "12-sep-23", range: NSRange(location: 290, length: 9), day: "12", month: "sep", year: "23", formatType: .DMY),
            ExtractedDateResult(original: "february-29-2024", range: NSRange(location: 300, length: 16), day: "29", month: "february", year: "2024", formatType: .MDY),
            ExtractedDateResult(original: "01 june 23", range: NSRange(location: 317, length: 10), day: "01", month: "june", year: "23", formatType: .DMY),
            ExtractedDateResult(original: "june 23 31", range: NSRange(location: 320, length: 10), day: "23", month: "june", year: "31", formatType: .MDY),
            ExtractedDateResult(original: "31/10/1999", range: NSRange(location: 328, length: 10), day: "31", month: "10", year: "1999", formatType: .DMY),
            ExtractedDateResult(original: "01-AUGUST-18", range: NSRange(location: 339, length: 12), day: "01", month: "AUGUST", year: "18", formatType: .DMY),
            ExtractedDateResult(original: "24 JAN 2022", range: NSRange(location: 352, length: 11), day: "24", month: "JAN", year: "2022", formatType: .DMY),
            ExtractedDateResult(original: "2023-12-27", range: NSRange(location: 386, length: 10), day: "27", month: "12", year: "2023", formatType: .YMD),
            ExtractedDateResult(original: "2023-12-09", range: NSRange(location: 397, length: 10), day: "09", month: "12", year: "2023", formatType: .YMD),
            ExtractedDateResult(original: "2023-07-10", range: NSRange(location: 408, length: 10), day: "10", month: "07", year: "2023", formatType: .YMD)
        ]
        var extractor = DateExtractor(prioritizedFormatType: .DMY)
        extractor.registerDefaultExtractors()
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }

    func testDateExtractorWithPrioritizedFormatTypeIsMDY() {
        let paragraph = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        Dates: 01/01/01 09/09/23 1.9.19 10-10-24 12.12.12 11-11-2011 11-9-11 is valid for both dd/mm/yy and mm/dd/yy
        Dates: 04/13/2033 11/28/11 21/12/23 still can be recognized as mm/dd/yy because second component > 12
        Dates: august-01-1920 sep-12-23 February-29-2024 june 01 23 10/31/1999 AUGUST-01-18 JAN 24 2022 are acceptable
        Dates: 2023-12-27 2023-12-09 2023-07-10 are acceptable but 2023-27-12 2023-12-9 2023-7-10 are not acceptable
        """
        let expectedResults = [
            ExtractedDateResult(original: "01/01/01", range: NSRange(location: 64, length: 8), day: "01", month: "01", year: "01", formatType: .MDY),
            ExtractedDateResult(original: "09/09/23", range: NSRange(location: 73, length: 8), day: "09", month: "09", year: "23", formatType: .MDY),
            ExtractedDateResult(original: "1.9.19", range: NSRange(location: 82, length: 6), day: "9", month: "1", year: "19", formatType: .MDY),
            ExtractedDateResult(original: "10-10-24", range: NSRange(location: 89, length: 8), day: "10", month: "10", year: "24", formatType: .MDY),
            ExtractedDateResult(original: "12.12.12", range: NSRange(location: 98, length: 8), day: "12", month: "12", year: "12", formatType: .MDY),
            ExtractedDateResult(original: "11-11-2011", range: NSRange(location: 107, length: 10), day: "11", month: "11", year: "2011", formatType: .MDY),
            ExtractedDateResult(original: "11-9-11", range: NSRange(location: 118, length: 7), day: "9", month: "11", year: "11", formatType: .MDY),
            ExtractedDateResult(original: "04/13/2033", range: NSRange(location: 173, length: 10), day: "13", month: "04", year: "2033", formatType: .MDY),
            ExtractedDateResult(original: "11/28/11", range: NSRange(location: 184, length: 8), day: "28", month: "11", year: "11", formatType: .MDY),
            ExtractedDateResult(original: "21/12/23", range: NSRange(location: 193, length: 8), day: "21", month: "12", year: "23", formatType: .DMY),
            ExtractedDateResult(original: "august-01-1920", range: NSRange(location: 275, length: 14), day: "01", month: "august", year: "1920", formatType: .MDY),
            ExtractedDateResult(original: "sep-12-23", range: NSRange(location: 290, length: 9), day: "12", month: "sep", year: "23", formatType: .MDY),
            ExtractedDateResult(original: "February-29-2024", range: NSRange(location: 300, length: 16), day: "29", month: "February", year: "2024", formatType: .MDY),
            ExtractedDateResult(original: "june 01 23", range: NSRange(location: 317, length: 10), day: "01", month: "june", year: "23", formatType: .MDY),
            ExtractedDateResult(original: "10/31/1999", range: NSRange(location: 328, length: 10), day: "31", month: "10", year: "1999", formatType: .MDY),
            ExtractedDateResult(original: "AUGUST-01-18", range: NSRange(location: 339, length: 12), day: "01", month: "AUGUST", year: "18", formatType: .MDY),
            ExtractedDateResult(original: "18 JAN 24", range: NSRange(location: 349, length: 9), day: "18", month: "JAN", year: "24", formatType: .DMY),
            ExtractedDateResult(original: "JAN 24 2022", range: NSRange(location: 352, length: 11), day: "24", month: "JAN", year: "2022", formatType: .MDY),
            ExtractedDateResult(original: "2023-12-27", range: NSRange(location: 386, length: 10), day: "27", month: "12", year: "2023", formatType: .YMD),
            ExtractedDateResult(original: "2023-12-09", range: NSRange(location: 397, length: 10), day: "09", month: "12", year: "2023", formatType: .YMD),
            ExtractedDateResult(original: "2023-07-10", range: NSRange(location: 408, length: 10), day: "10", month: "07", year: "2023", formatType: .YMD)
        ]
        var extractor = DateExtractor(prioritizedFormatType: .MDY)
        extractor.registerDefaultExtractors()
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}
