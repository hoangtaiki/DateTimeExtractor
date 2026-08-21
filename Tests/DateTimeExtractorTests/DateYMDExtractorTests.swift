//
//  DateYMDExtractorTests.swift
//
//
//  Created by Harry Tran on 27/12/2023.
//

@testable import DateTimeExtractor
import XCTest

// swiftlint:disable line_length

final class DateYMDExtractorTests: XCTestCase {
    private let extractor = DateYMDExtractor()

    func testInvalidDateShouldNotRecognize() {
        let dateStrings = [
            "2023-12-32", "2023-13-00", "2023-12-0", "1599-01-01", "10001-2-28", "2023-2-12", "2023-12-1", "23-12-12"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }

    func testInvalidDateMonthNameStringShouldNotRecognize() {
        let dateStrings = [
            // Hyphen
            "2023-02-31", "2023-06-31", "2023-09-31", "2023-11-31", "2023-02-30", "2023-02-29",
            // Invalid leap-year
            "1700-02-29", "1800-02-29", "1900-02-29", "2200-02-29", "2300-02-29",
            "2500-02-29", "2600-02-29", "1803-02-29", "1905-02-29", "2007-02-29", "2109-02-29", "2211-02-29",
            "2323-02-29", "2537-02-29", "2649-02-29", "2761-02-29", "2873-02-29", "2985-02-29"
        ]

        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }

    func testValidDate() {
        let paragraph = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        1. These are many single dates which can be recognized:
        1600-01-31 1999-03-31 2000-05-31 1999-10-31 9999-12-31
        2023-01-30 2023-03-30 1920-09-30 1920-05-30 1909-11-30 1919-12-30
        2009-10-01 1992-12-01 2012-01-11 1699-01-10 2999-09-19 9000-01-10 1800-09-19
        1992-12-19 2012-01-20 2008-09-28 1902-01-21 9212-09-27 1945-10-24 9009-11-25
        """

        let expectedResults = [
            ExtractedDateResult(original: "1600-01-31", range: NSRange(location: 113, length: 10), day: "31", month: "01", year: "1600", formatType: .YMD),
            ExtractedDateResult(original: "1999-03-31", range: NSRange(location: 124, length: 10), day: "31", month: "03", year: "1999", formatType: .YMD),
            ExtractedDateResult(original: "2000-05-31", range: NSRange(location: 135, length: 10), day: "31", month: "05", year: "2000", formatType: .YMD),
            ExtractedDateResult(original: "1999-10-31", range: NSRange(location: 146, length: 10), day: "31", month: "10", year: "1999", formatType: .YMD),
            ExtractedDateResult(original: "9999-12-31", range: NSRange(location: 157, length: 10), day: "31", month: "12", year: "9999", formatType: .YMD),
            ExtractedDateResult(original: "2023-01-30", range: NSRange(location: 168, length: 10), day: "30", month: "01", year: "2023", formatType: .YMD),
            ExtractedDateResult(original: "2023-03-30", range: NSRange(location: 179, length: 10), day: "30", month: "03", year: "2023", formatType: .YMD),
            ExtractedDateResult(original: "1920-09-30", range: NSRange(location: 190, length: 10), day: "30", month: "09", year: "1920", formatType: .YMD),
            ExtractedDateResult(original: "1920-05-30", range: NSRange(location: 201, length: 10), day: "30", month: "05", year: "1920", formatType: .YMD),
            ExtractedDateResult(original: "1909-11-30", range: NSRange(location: 212, length: 10), day: "30", month: "11", year: "1909", formatType: .YMD),
            ExtractedDateResult(original: "1919-12-30", range: NSRange(location: 223, length: 10), day: "30", month: "12", year: "1919", formatType: .YMD),
            ExtractedDateResult(original: "2009-10-01", range: NSRange(location: 234, length: 10), day: "01", month: "10", year: "2009", formatType: .YMD),
            ExtractedDateResult(original: "1992-12-01", range: NSRange(location: 245, length: 10), day: "01", month: "12", year: "1992", formatType: .YMD),
            ExtractedDateResult(original: "2012-01-11", range: NSRange(location: 256, length: 10), day: "11", month: "01", year: "2012", formatType: .YMD),
            ExtractedDateResult(original: "1699-01-10", range: NSRange(location: 267, length: 10), day: "10", month: "01", year: "1699", formatType: .YMD),
            ExtractedDateResult(original: "2999-09-19", range: NSRange(location: 278, length: 10), day: "19", month: "09", year: "2999", formatType: .YMD),
            ExtractedDateResult(original: "9000-01-10", range: NSRange(location: 289, length: 10), day: "10", month: "01", year: "9000", formatType: .YMD),
            ExtractedDateResult(original: "1800-09-19", range: NSRange(location: 300, length: 10), day: "19", month: "09", year: "1800", formatType: .YMD),
            ExtractedDateResult(original: "1992-12-19", range: NSRange(location: 311, length: 10), day: "19", month: "12", year: "1992", formatType: .YMD),
            ExtractedDateResult(original: "2012-01-20", range: NSRange(location: 322, length: 10), day: "20", month: "01", year: "2012", formatType: .YMD),
            ExtractedDateResult(original: "2008-09-28", range: NSRange(location: 333, length: 10), day: "28", month: "09", year: "2008", formatType: .YMD),
            ExtractedDateResult(original: "1902-01-21", range: NSRange(location: 344, length: 10), day: "21", month: "01", year: "1902", formatType: .YMD),
            ExtractedDateResult(original: "9212-09-27", range: NSRange(location: 355, length: 10), day: "27", month: "09", year: "9212", formatType: .YMD),
            ExtractedDateResult(original: "1945-10-24", range: NSRange(location: 366, length: 10), day: "24", month: "10", year: "1945", formatType: .YMD),
            ExtractedDateResult(original: "9009-11-25", range: NSRange(location: 377, length: 10), day: "25", month: "11", year: "9009", formatType: .YMD)
        ]

        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}
