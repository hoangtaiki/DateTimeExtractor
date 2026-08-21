//
//  CustomDateExtractorTests.swift
//  DateTimeExtractorDemoTests
//
//  Created by Harry Tran on 25/12/2023.
//

import DateTimeExtractor
@testable import DateTimeExtractorDemo
import Foundation
import XCTest

// swiftlint:disable line_length

final class CustomDateExtractorTests: XCTestCase {
    private let extractor = CustomDateExtractor()

    func testValidDate() {
        let paragraph = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        jan31' 91 january31' 01 mar31' 2023 March' 31 JANUARY29' 23 february29' 2012
        October21' 2023 JANUARY01' 23
        """
        let expectedResults = [
            ExtractedDateResult(original: "jan31' 91", range: NSRange(location: 57, length: 9), day: "31", month: "jan", year: "91", formatType: .DMY),
            ExtractedDateResult(original: "january31' 01", range: NSRange(location: 67, length: 13), day: "31", month: "january", year: "01", formatType: .DMY),
            ExtractedDateResult(original: "mar31' 2023", range: NSRange(location: 81, length: 11), day: "31", month: "mar", year: "2023", formatType: .DMY),
            ExtractedDateResult(original: "JANUARY29' 23", range: NSRange(location: 103, length: 13), day: "29", month: "JANUARY", year: "23", formatType: .DMY),
            ExtractedDateResult(original: "february29' 2012", range: NSRange(location: 117, length: 16), day: "29", month: "february", year: "2012", formatType: .DMY),
            ExtractedDateResult(original: "October21' 2023", range: NSRange(location: 134, length: 15), day: "21", month: "October", year: "2023", formatType: .DMY),
            ExtractedDateResult(original: "JANUARY01' 23", range: NSRange(location: 150, length: 13), day: "01", month: "JANUARY", year: "23", formatType: .DMY)
        ]

        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}
