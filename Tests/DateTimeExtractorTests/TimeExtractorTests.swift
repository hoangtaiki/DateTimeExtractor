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
        2:10 02:30 3:00 am 3:45:00a 4:00:59 05:50:00a 09:00 am 10:12 10:25:35 11:12:15a
        11:59 am 11:59:59am 12:00 12:00p 12:00:00 pm 12:01 12:01:01pm 12:59:59p 13:12:12 1:34p
        14:12 11:00pm 11:01:59p 23:33:32 23:59 23:59:59 11:59 pm
        These are incorrect date: 00:50:00a 24:23:12 12:12:0p 13:10:10am 14:15:59pm
        These are correct date with hyphen character between them: 3:45pm-5:15pm 02:12:45-13:43:56
        """
        
        let expectedResults = [
            ExtractedDateResult(originalString: "12:00:00 am", formatedString: "12:00:00 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(81, 11)),
            ExtractedDateResult(originalString: "12:09:01a", formatedString: "12:09:01 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(93, 9)),
            ExtractedDateResult(originalString: "12:59 am", formatedString: "12:59 AM", dateFormat: "hh:mm a", range: NSMakeRange(103, 8)),
            ExtractedDateResult(originalString: "12:59:59am", formatedString: "12:59:59 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(112, 10)),
            ExtractedDateResult(originalString: "1:00a", formatedString: "1:00 AM", dateFormat: "h:mm a", range: NSMakeRange(123, 5)),
            ExtractedDateResult(originalString: "01:00:00 am", formatedString: "01:00:00 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(129, 11)),
            ExtractedDateResult(originalString: "01:59am", formatedString: "01:59 AM", dateFormat: "hh:mm a", range: NSMakeRange(141, 7)),
            ExtractedDateResult(originalString: "2:10", formatedString: "2:10", dateFormat: "h:mm", range: NSMakeRange(149, 4)),
            ExtractedDateResult(originalString: "02:30", formatedString: "02:30", dateFormat: "hh:mm", range: NSMakeRange(154, 5)),
            ExtractedDateResult(originalString: "3:00 am", formatedString: "3:00 AM", dateFormat: "h:mm a", range: NSMakeRange(160, 7)),
            ExtractedDateResult(originalString: "3:45:00a", formatedString: "3:45:00 AM", dateFormat: "h:mm:ss a", range: NSMakeRange(168, 8)),
            ExtractedDateResult(originalString: "4:00:59", formatedString: "4:00:59", dateFormat: "h:mm:ss", range: NSMakeRange(177, 7)),
            ExtractedDateResult(originalString: "05:50:00a", formatedString: "05:50:00 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(185, 9)),
            ExtractedDateResult(originalString: "09:00 am", formatedString: "09:00 AM", dateFormat: "hh:mm a", range: NSMakeRange(195, 8)),
            ExtractedDateResult(originalString: "10:12", formatedString: "10:12", dateFormat: "hh:mm", range: NSMakeRange(204, 5)),
            ExtractedDateResult(originalString: "10:25:35", formatedString: "10:25:35", dateFormat: "hh:mm:ss", range: NSMakeRange(210, 8)),
            ExtractedDateResult(originalString: "11:12:15a", formatedString: "11:12:15 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(219, 9)),
            ExtractedDateResult(originalString: "11:59 am", formatedString: "11:59 AM", dateFormat: "hh:mm a", range: NSMakeRange(229, 8)),
            ExtractedDateResult(originalString: "11:59:59am", formatedString: "11:59:59 AM", dateFormat: "hh:mm:ss a", range: NSMakeRange(238, 10)),
            ExtractedDateResult(originalString: "12:00", formatedString: "12:00", dateFormat: "hh:mm", range: NSMakeRange(249, 5)),
            ExtractedDateResult(originalString: "12:00p", formatedString: "12:00 PM", dateFormat: "hh:mm a", range: NSMakeRange(255, 6)),
            ExtractedDateResult(originalString: "12:00:00 pm", formatedString: "12:00:00 PM", dateFormat: "hh:mm:ss a", range: NSMakeRange(262, 11)),
            ExtractedDateResult(originalString: "12:01", formatedString: "12:01", dateFormat: "hh:mm", range: NSMakeRange(274, 5)),
            ExtractedDateResult(originalString: "12:01:01pm", formatedString: "12:01:01 PM", dateFormat: "hh:mm:ss a", range: NSMakeRange(280, 10)),
            ExtractedDateResult(originalString: "12:59:59p", formatedString: "12:59:59 PM", dateFormat: "hh:mm:ss a", range: NSMakeRange(291, 9)),
            ExtractedDateResult(originalString: "13:12:12", formatedString: "13:12:12", dateFormat: "hh:mm:ss", range: NSMakeRange(301, 8)),
            ExtractedDateResult(originalString: "1:34p", formatedString: "1:34 PM", dateFormat: "h:mm a", range: NSMakeRange(310, 5)),
            ExtractedDateResult(originalString: "14:12", formatedString: "14:12", dateFormat: "hh:mm", range: NSMakeRange(316, 5)),
            ExtractedDateResult(originalString: "11:00pm", formatedString: "11:00 PM", dateFormat: "hh:mm a", range: NSMakeRange(322, 7)),
            ExtractedDateResult(originalString: "11:01:59p", formatedString: "11:01:59 PM", dateFormat: "hh:mm:ss a", range: NSMakeRange(330, 9)),
            ExtractedDateResult(originalString: "23:33:32", formatedString: "23:33:32", dateFormat: "hh:mm:ss", range: NSMakeRange(340, 8)),
            ExtractedDateResult(originalString: "23:59", formatedString: "23:59", dateFormat: "hh:mm", range: NSMakeRange(349, 5)),
            ExtractedDateResult(originalString: "23:59:59", formatedString: "23:59:59", dateFormat: "hh:mm:ss", range: NSMakeRange(355, 8)),
            ExtractedDateResult(originalString: "11:59 pm", formatedString: "11:59 PM", dateFormat: "hh:mm a", range: NSMakeRange(364, 8)),
            ExtractedDateResult(originalString: "3:45pm", formatedString: "3:45 PM", dateFormat: "h:mm a", range: NSMakeRange(508, 6)),
            ExtractedDateResult(originalString: "5:15pm", formatedString: "5:15 PM", dateFormat: "h:mm a", range: NSMakeRange(515, 6)),
            ExtractedDateResult(originalString: "02:12:45", formatedString: "02:12:45", dateFormat: "hh:mm:ss", range: NSMakeRange(522, 8)),
            ExtractedDateResult(originalString: "13:43:56", formatedString: "13:43:56", dateFormat: "hh:mm:ss", range: NSMakeRange(531, 8))
        ]
        
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
            .sorted(by: { $0.range.location < $1.range.location } )

        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}
