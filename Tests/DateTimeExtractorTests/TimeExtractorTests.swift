//
//  TimeExtractorTests.swift
//  
//
//  Created by Harry Tran on 20/12/2023.
//

import XCTest
@testable import DateTimeExtractor

final class TimeExtractorTests: XCTestCase {
    
    private let extractor = TimeExtractor()

    func test_InvalidDateString_12HourFormat() {
        let dateStrings = [
            "12a", "59a", "12", "23",
            "24:59", "0:20a", "0:20p", "11:60a", "11:60p", " 11:59ap", " 11:59pa",
            "00:53a", "00:53p", "00:53am", "00:53pm",
            "12:1a", "1:1a", "12:1p", "1:1p", "12:1am", "1:1am", "12:1pm", "1:1pm",
            "13:59pm", "13:00am", "111:59pm", "112:00am", "110:00 pm",
            "00:53:00a", "00:53:00p", "00:53:59am", "00:53:01pm",
            "1:01:1a", "12:12:0p", "23:23:9 am", "20:9:20 pm"
        ]
        
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index) \(results)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_InvalidDateString_24HourFormat() {
        let dateStrings = [
            "12:1", "1:1:1", "1:1:01", "12:0:0", "1:01:1", "02:2:02", "23:03:04a", "13:20:45am",
            "12:12:0", "23:23:9", "20:9:20", "24:00:00", "23:60:60", "00:00:1", "23:30:12pm"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index) \(results)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_ValidDate() {
        let paragraph = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        These are correct date: 12:00:00 am 12:09:01a 12:59 am 12:59:59am 1:00a 01:00:00 am 01:59am
        2:10 02:30 3:00 am 3:45:00A 4:00:59 05:50:00AM 09:00 am 10:12 10:25:35 11:12:15 AM
        11:59 am 11:59:59am 12:00 12:00p 12:00:00 pm 12:01 12:01:01pm 12:59:59p 13:12:12 1:34p 01:45P
        08:20:30 PM 14:12 11:00pm 11:01:59PM 23:33:32 23:59 23:59:59 11:59 pm
        These are incorrect date: 00:50:00a 24:23:12 12:12:0p 13:10:10am 14:15:59pm
        These are correct date with hyphen character between them: 3:45pm-5:15pm 02:12:45-13:43:56
        """
        
        let expectedResults = [
            ExtractedTimeResult(original: "12:00:00 am", range: NSRange(location: 81, length: 11), hour: "12", minute: "00", second: "00", ampm: "a"),
            ExtractedTimeResult(original: "12:09:01a", range: NSRange(location: 93, length: 9), hour: "12", minute: "09", second: "01", ampm: "a"),
            ExtractedTimeResult(original: "12:59 am", range: NSRange(location: 103, length: 8), hour: "12", minute: "59", ampm: "a"),
            ExtractedTimeResult(original: "12:59:59am", range: NSRange(location: 112, length: 10), hour: "12", minute: "59", second: "59", ampm: "a"),
            ExtractedTimeResult(original: "1:00a", range: NSRange(location: 123, length: 5), hour: "1", minute: "00", ampm: "a"),
            ExtractedTimeResult(original: "01:00:00 am", range: NSRange(location: 129, length: 11), hour: "01", minute: "00", second: "00", ampm: "a"),
            ExtractedTimeResult(original: "01:59am", range: NSRange(location: 141, length: 7), hour: "01", minute: "59", ampm: "a"),
            ExtractedTimeResult(original: "2:10", range: NSRange(location: 149, length: 4), hour: "2", minute: "10"),
            ExtractedTimeResult(original: "02:30", range: NSRange(location: 154, length: 5), hour: "02", minute: "30"),
            ExtractedTimeResult(original: "3:00 am", range: NSRange(location: 160, length: 7), hour: "3", minute: "00", ampm: "a"),
            ExtractedTimeResult(original: "3:45:00A", range: NSRange(location: 168, length: 8), hour: "3", minute: "45", second: "00", ampm: "a"),
            ExtractedTimeResult(original: "4:00:59", range: NSRange(location: 177, length: 7), hour: "4", minute: "00", second: "59", ampm: ""),
            ExtractedTimeResult(original: "05:50:00AM", range: NSRange(location: 185, length: 10), hour: "05", minute: "50", second: "00", ampm: "a"),
            ExtractedTimeResult(original: "09:00 am", range: NSRange(location: 196, length: 8), hour: "09", minute: "00", ampm: "a"),
            ExtractedTimeResult(original: "10:12", range: NSRange(location: 205, length: 5), hour: "10", minute: "12"),
            ExtractedTimeResult(original: "10:25:35", range: NSRange(location: 211, length: 8), hour: "10", minute: "25", second: "35"),
            ExtractedTimeResult(original: "11:12:15 AM", range: NSRange(location: 220, length: 11), hour: "11", minute: "12", second: "15", ampm: "a"),
            ExtractedTimeResult(original: "11:59 am", range: NSRange(location: 232, length: 8), hour: "11", minute: "59", second: "", ampm: "a"),
            ExtractedTimeResult(original: "11:59:59am", range: NSRange(location: 241, length: 10), hour: "11", minute: "59", second: "59", ampm: "a"),
            ExtractedTimeResult(original: "12:00", range: NSRange(location: 252, length: 5), hour: "12", minute: "00"),
            ExtractedTimeResult(original: "12:00p", range: NSRange(location: 258, length: 6), hour: "12", minute: "00", ampm: "p"),
            ExtractedTimeResult(original: "12:00:00 pm", range: NSRange(location: 265, length: 11), hour: "12", minute: "00", second: "00", ampm: "p"),
            ExtractedTimeResult(original: "12:01", range: NSRange(location: 277, length: 5), hour: "12", minute: "01"),
            ExtractedTimeResult(original: "12:01:01pm", range: NSRange(location: 283, length: 10), hour: "12", minute: "01", second: "01", ampm: "p"),
            ExtractedTimeResult(original: "12:59:59p", range: NSRange(location: 294, length: 9), hour: "12", minute: "59", second: "59", ampm: "p"),
            ExtractedTimeResult(original: "13:12:12", range: NSRange(location: 304, length: 8), hour: "13", minute: "12", second: "12"),
            ExtractedTimeResult(original: "1:34p", range: NSRange(location: 313, length: 5), hour: "1", minute: "34", ampm: "p"),
            ExtractedTimeResult(original: "01:45P", range: NSRange(location: 319, length: 6), hour: "01", minute: "45", ampm: "p"),
            ExtractedTimeResult(original: "08:20:30 PM", range: NSRange(location: 326, length: 11), hour: "08", minute: "20", second: "30", ampm: "p"),
            ExtractedTimeResult(original: "14:12", range: NSRange(location: 338, length: 5), hour: "14", minute: "12"),
            ExtractedTimeResult(original: "11:00pm", range: NSRange(location: 344, length: 7), hour: "11", minute: "00", ampm: "p"),
            ExtractedTimeResult(original: "11:01:59PM", range: NSRange(location: 352, length: 10), hour: "11", minute: "01", second: "59", ampm: "p"),
            ExtractedTimeResult(original: "23:33:32", range: NSRange(location: 363, length: 8), hour: "23", minute: "33", second: "32"),
            ExtractedTimeResult(original: "23:59", range: NSRange(location: 372, length: 5), hour: "23", minute: "59"),
            ExtractedTimeResult(original: "23:59:59", range: NSRange(location: 378, length: 8), hour: "23", minute: "59", second: "59"),
            ExtractedTimeResult(original: "11:59 pm", range: NSRange(location: 387, length: 8), hour: "11", minute: "59", ampm: "p"),
            ExtractedTimeResult(original: "3:45pm", range: NSRange(location: 531, length: 6), hour: "3", minute: "45", ampm: "p"),
            ExtractedTimeResult(original: "5:15pm", range: NSRange(location: 538, length: 6), hour: "5", minute: "15", ampm: "p"),
            ExtractedTimeResult(original: "02:12:45", range: NSRange(location: 545, length: 8), hour: "02", minute: "12", second: "45"),
            ExtractedTimeResult(original: "13:43:56", range: NSRange(location: 554, length: 8), hour: "13", minute: "43", second: "56")
        ]
        
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location } )

        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}
