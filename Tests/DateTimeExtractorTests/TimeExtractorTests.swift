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
            ExtractedTimeResult(originalString: "12:00:00 am", range: NSMakeRange(81, 11), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "00", secondValue: "00", ampm: "a")),
            ExtractedTimeResult(originalString: "12:09:01a", range: NSMakeRange(93, 9), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "09", secondValue: "01", ampm: "a")),
            ExtractedTimeResult(originalString: "12:59 am", range: NSMakeRange(103, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "59", secondValue: "", ampm: "a")),
            ExtractedTimeResult(originalString: "12:59:59am", range: NSMakeRange(112, 10), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "59", secondValue: "59", ampm: "a")),
            ExtractedTimeResult(originalString: "1:00a", range: NSMakeRange(123, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "1", minuteValue: "00", secondValue: "", ampm: "a")),
            ExtractedTimeResult(originalString: "01:00:00 am", range: NSMakeRange(129, 11), 
                                formatComponents: TimeFormatComponents(hourValue: "01", minuteValue: "00", secondValue: "00", ampm: "a")),
            ExtractedTimeResult(originalString: "01:59am", range: NSMakeRange(141, 7), 
                                formatComponents: TimeFormatComponents(hourValue: "01", minuteValue: "59", secondValue: "", ampm: "a")),
            ExtractedTimeResult(originalString: "2:10", range: NSMakeRange(149, 4), 
                                formatComponents: TimeFormatComponents(hourValue: "2", minuteValue: "10", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "02:30", range: NSMakeRange(154, 5),
                                formatComponents: TimeFormatComponents(hourValue: "02", minuteValue: "30", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "3:00 am", range: NSMakeRange(160, 7), 
                                formatComponents: TimeFormatComponents(hourValue: "3", minuteValue: "00", secondValue: "", ampm: "a")),
            ExtractedTimeResult(originalString: "3:45:00a", range: NSMakeRange(168, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "3", minuteValue: "45", secondValue: "00", ampm: "a")),
            ExtractedTimeResult(originalString: "4:00:59", range: NSMakeRange(177, 7),
                                formatComponents: TimeFormatComponents(hourValue: "4", minuteValue: "00", secondValue: "59", ampm: "")),
            ExtractedTimeResult(originalString: "05:50:00a", range: NSMakeRange(185, 9), 
                                formatComponents: TimeFormatComponents(hourValue: "05", minuteValue: "50", secondValue: "00", ampm: "a")),
            ExtractedTimeResult(originalString: "09:00 am", range: NSMakeRange(195, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "09", minuteValue: "00", secondValue: "", ampm: "a")),
            ExtractedTimeResult(originalString: "10:12", range: NSMakeRange(204, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "10", minuteValue: "12", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "10:25:35", range: NSMakeRange(210, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "10", minuteValue: "25", secondValue: "35", ampm: "")),
            ExtractedTimeResult(originalString: "11:12:15a", range: NSMakeRange(219, 9), 
                                formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "12", secondValue: "15", ampm: "a")),
            ExtractedTimeResult(originalString: "11:59 am", range: NSMakeRange(229, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "59", secondValue: "", ampm: "a")),
            ExtractedTimeResult(originalString: "11:59:59am", range: NSMakeRange(238, 10), 
                                formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "59", secondValue: "59", ampm: "a")),
            ExtractedTimeResult(originalString: "12:00", range: NSMakeRange(249, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "00", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "12:00p", range: NSMakeRange(255, 6), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "00", secondValue: "", ampm: "p")),
            ExtractedTimeResult(originalString: "12:00:00 pm", range: NSMakeRange(262, 11), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "00", secondValue: "00", ampm: "p")),
            ExtractedTimeResult(originalString: "12:01", range: NSMakeRange(274, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "01", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "12:01:01pm", range: NSMakeRange(280, 10), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "01", secondValue: "01", ampm: "p")),
            ExtractedTimeResult(originalString: "12:59:59p", range: NSMakeRange(291, 9), 
                                formatComponents: TimeFormatComponents(hourValue: "12", minuteValue: "59", secondValue: "59", ampm: "p")),
            ExtractedTimeResult(originalString: "13:12:12", range: NSMakeRange(301, 8),
                                formatComponents: TimeFormatComponents(hourValue: "13", minuteValue: "12", secondValue: "12", ampm: "")),
            ExtractedTimeResult(originalString: "1:34p", range: NSMakeRange(310, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "1", minuteValue: "34", secondValue: "", ampm: "p")),
            ExtractedTimeResult(originalString: "14:12", range: NSMakeRange(316, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "14", minuteValue: "12", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "11:00pm", range: NSMakeRange(322, 7), 
                                formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "00", secondValue: "", ampm: "p")),
            ExtractedTimeResult(originalString: "11:01:59p", range: NSMakeRange(330, 9), 
                                formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "01", secondValue: "59", ampm: "p")),
            ExtractedTimeResult(originalString: "23:33:32", range: NSMakeRange(340, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "23", minuteValue: "33", secondValue: "32", ampm: "")),
            ExtractedTimeResult(originalString: "23:59", range: NSMakeRange(349, 5), 
                                formatComponents: TimeFormatComponents(hourValue: "23", minuteValue: "59", secondValue: "", ampm: "")),
            ExtractedTimeResult(originalString: "23:59:59", range: NSMakeRange(355, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "23", minuteValue: "59", secondValue: "59", ampm: "")),
            ExtractedTimeResult(originalString: "11:59 pm", range: NSMakeRange(364, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "11", minuteValue: "59", secondValue: "", ampm: "p")),
            ExtractedTimeResult(originalString: "3:45pm", range: NSMakeRange(508, 6), 
                                formatComponents: TimeFormatComponents(hourValue: "3", minuteValue: "45", secondValue: "", ampm: "p")),
            ExtractedTimeResult(originalString: "5:15pm", range: NSMakeRange(515, 6), 
                                formatComponents: TimeFormatComponents(hourValue: "5", minuteValue: "15", secondValue: "", ampm: "p")),
            ExtractedTimeResult(originalString: "02:12:45", range: NSMakeRange(522, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "02", minuteValue: "12", secondValue: "45", ampm: "")),
            ExtractedTimeResult(originalString: "13:43:56", range: NSMakeRange(531, 8), 
                                formatComponents: TimeFormatComponents(hourValue: "13", minuteValue: "43", secondValue: "56", ampm: ""))
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
