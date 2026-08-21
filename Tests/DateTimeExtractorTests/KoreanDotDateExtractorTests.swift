//
//  KoreanDotDateExtractorTests.swift
//  DateTimeExtractorTests
//

@testable import DateTimeExtractor
import XCTest

final class KoreanDotDateExtractorTests: XCTestCase {
    private let extractor = KoreanDotDateExtractor()
    private let utc = TimeZone(identifier: "UTC")!

    func test_parsesDottedYMD() throws {
        let results = extractor.extractDateStringAndFormat(string: "결제일 2026.08.21")
        XCTAssertEqual(results.count, 1)

        let date = results.first?.getDate(timezone: utc)
        XCTAssertNotNil(date)
        let comps = try Calendar(identifier: .gregorian).dateComponents(in: utc, from: XCTUnwrap(date))
        XCTAssertEqual(comps.year, 2026)
        XCTAssertEqual(comps.month, 8)
        XCTAssertEqual(comps.day, 21)
    }

    func test_ignoresDashSeparatedAndInvalid() {
        XCTAssertTrue(extractor.extractDateStringAndFormat(string: "2026-08-21").isEmpty)
        XCTAssertTrue(extractor.extractDateStringAndFormat(string: "2026.13.40").isEmpty)
        XCTAssertTrue(extractor.extractDateStringAndFormat(string: "no date here").isEmpty)
    }
}
