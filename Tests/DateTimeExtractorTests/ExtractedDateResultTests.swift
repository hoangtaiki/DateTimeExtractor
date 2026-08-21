//
//  ExtractedDateResultTests.swift
//
//
//  Created by Harry Tran on 21/12/2023.
//

@testable import DateTimeExtractor
import XCTest

// swiftlint:disable line_length

final class ExtractedDateResultTests: XCTestCase {
    func testEquality() {
        let result1 = ExtractedDateResult(original: "2023-01-01", range: NSRange(location: 0, length: 10),
                                          day: "01", month: "01", year: "2023", formatType: .DMY)
        let result2 = ExtractedDateResult(original: "2023-01-01", range: NSRange(location: 0, length: 10),
                                          day: "01", month: "01", year: "2023", formatType: .DMY)
        XCTAssertEqual(result1, result2)
    }

    func testEmptyArray() {
        let emptyArray: [ExtractedDateResult] = []
        XCTAssertTrue(emptyArray.groupResultsBySameRange().isEmpty)
    }

    func testInequalityDifferentRange() {
        let result1 = ExtractedDateResult(original: "2023-01-01", range: NSRange(location: 0, length: 10),
                                          day: "01", month: "01", year: "2023", formatType: .DMY)
        let result2 = ExtractedDateResult(original: "2023-01-01", range: NSRange(location: 11, length: 21),
                                          day: "01", month: "01", year: "2023", formatType: .DMY)
        XCTAssertNotEqual(result1, result2)
    }

    func testSingleElementArray() {
        let result = ExtractedDateResult(original: "12-12-12",
                                         range: NSRange(location: 0, length: 8),
                                         day: "12", month: "12", year: "12", formatType: .DMY)
        let singleElementArray = [result]

        XCTAssertEqual(singleElementArray.groupResultsBySameRange(), [[result]])
    }

    func testGetResultsWithSameRange() {
        let result1 = ExtractedDateResult(original: "01-01-01", range: NSRange(location: 0, length: 8),
                                          day: "01", month: "01", year: "01", formatType: .DMY)
        let result2 = ExtractedDateResult(original: "01-02-03", range: NSRange(location: 9, length: 17),
                                          day: "01", month: "02", year: "03", formatType: .DMY)
        let result3 = ExtractedDateResult(original: "01-01-01", range: NSRange(location: 0, length: 8),
                                          day: "01", month: "01", year: "01", formatType: .MDY)
        let result4 = ExtractedDateResult(original: "01-01-01", range: NSRange(location: 0, length: 8),
                                          day: "01", month: "01", year: "01", formatType: .YMD)
        let result5 = ExtractedDateResult(original: "01-02-03", range: NSRange(location: 9, length: 17),
                                          day: "02", month: "01", year: "03", formatType: .MDY)
        let result6 = ExtractedDateResult(original: "21-12-25", range: NSRange(location: 18, length: 26),
                                          day: "21", month: "12", year: "25", formatType: .DMY)

        let inputArray = [result1, result2, result3, result4, result5, result6]
        let sameRangeResults = inputArray.groupResultsBySameRange()

        XCTAssertEqual(sameRangeResults.count, 3)
        XCTAssertEqual(sameRangeResults[0], [result1, result3, result4])
        XCTAssertEqual(sameRangeResults[1], [result2, result5])
        XCTAssertEqual(sameRangeResults[2], [result6])
    }

    func testGetDate() throws {
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
        let expectedDate = Date(month: 11, day: 5, year: 2023, timezone: laTimezone)
        let extractedDateResult = ExtractedDateResult(originalString: "05/11/23", range: NSRange(location: 0, length: 8),
                                                      formatComponents: DateFormatComponents(dayValue: "05", monthValue: "11", yearValue: "23",
                                                                                             formatType: .DMY))
        let result = extractedDateResult.getDate(timezone: laTimezone)
        XCTAssertEqual(result, expectedDate)
    }

    func testGetDateWithTimeResult() throws {
        let laTimezone = try XCTUnwrap(TimeZone(identifier: "America/Los_Angeles"))
        let extractedDateResult = ExtractedDateResult(originalString: "05/11/23", range: NSRange(location: 0, length: 8),
                                                      formatComponents: DateFormatComponents(dayValue: "05", monthValue: "11", yearValue: "23",
                                                                                             formatType: .DMY))
        let extractedTimeResult = ExtractedTimeResult(originalString: "11:30:30 pm", range: NSRange(location: 0, length: 11),
                                                      formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "30", secondValue: "30", ampm: "pm"))
        let expectedDate = Date(month: 11, day: 5, year: 2023, hour: 23, minute: 30, second: 30, timezone: laTimezone)

        let result = extractedDateResult.getDate(withTimeResult: extractedTimeResult, timezone: laTimezone)
        XCTAssertEqual(result, expectedDate)
    }
}
