//
//  DateExtractorTests.swift
//
//
//  Created by Harry Tran on 21/12/2023.
//

import XCTest
@testable import DateTimeExtractor

struct MockDateExtracter: DateExtractable {
    
    func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        return []
    }
}

final class DateExtractorTests: XCTestCase {
    
    func testRegisterDefaultExtractors() {
        var dateExtractor = DateExtractor()
        dateExtractor.registerDefaultExtractors()
        
        XCTAssertEqual(dateExtractor.extractors.count, 2)
        XCTAssertTrue(dateExtractor.extractors.contains { $0 is DateDMYExtractor })
        XCTAssertTrue(dateExtractor.extractors.contains { $0 is DateMDYExtractor })
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
        Dates: 01-august-1920 12-sep-23 february-29-2024 01 june 23 31/10/1999 are acceptable
        """
        let expectedResults = [
            ExtractedDateResult(originalString: "01/01/01", range: NSMakeRange(64, 8),
                                formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "01", formatType: .DMY)),
            ExtractedDateResult(originalString: "09/09/23", range: NSMakeRange(73, 8),
                                formatComponents: DateFormatComponents(dayValue: "09", monthValue: "09", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "1.9.19", range: NSMakeRange(82, 6),
                                formatComponents: DateFormatComponents(dayValue: "1", monthValue: "9", yearValue: "19", formatType: .DMY)),
            ExtractedDateResult(originalString: "10-10-24", range: NSMakeRange(89, 8),
                                formatComponents: DateFormatComponents(dayValue: "10", monthValue: "10", yearValue: "24", formatType: .DMY)),
            ExtractedDateResult(originalString: "12.12.12", range: NSMakeRange(98, 8),
                                formatComponents: DateFormatComponents(dayValue: "12", monthValue: "12", yearValue: "12", formatType: .DMY)),
            ExtractedDateResult(originalString: "11-11-2011", range: NSMakeRange(107, 10),
                                formatComponents: DateFormatComponents(dayValue: "11", monthValue: "11", yearValue: "2011", formatType: .DMY)),
            ExtractedDateResult(originalString: "11-9-11", range: NSMakeRange(118, 7),
                                formatComponents: DateFormatComponents(dayValue: "11", monthValue: "9", yearValue: "11", formatType: .DMY)),
            ExtractedDateResult(originalString: "04/13/2033", range: NSMakeRange(173, 10),
                                formatComponents: DateFormatComponents(dayValue: "13", monthValue: "04", yearValue: "2033", formatType: .MDY)),
            ExtractedDateResult(originalString: "11/28/11", range: NSMakeRange(184, 8),
                                formatComponents: DateFormatComponents(dayValue: "28", monthValue: "11", yearValue: "11", formatType: .MDY)),
            ExtractedDateResult(originalString: "21/12/23", range: NSMakeRange(193, 8),
                                formatComponents: DateFormatComponents(dayValue: "21", monthValue: "12", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "01-august-1920", range: NSMakeRange(275, 14),
                                formatComponents: DateFormatComponents(dayValue: "01", monthValue: "august", yearValue: "1920", formatType: .DMY)),
            ExtractedDateResult(originalString: "12-sep-23", range: NSMakeRange(290, 9),
                                formatComponents: DateFormatComponents(dayValue: "12", monthValue: "sep", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "february-29-2024", range: NSMakeRange(300, 16),
                                formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2024", formatType: .MDY)),
            ExtractedDateResult(originalString: "01 june 23", range: NSMakeRange(317, 10),
                                formatComponents: DateFormatComponents(dayValue: "01", monthValue: "june", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "june 23 31", range: NSMakeRange(320, 10),
                                formatComponents: DateFormatComponents(dayValue: "23", monthValue: "june", yearValue: "31", formatType: .MDY)),
            ExtractedDateResult(originalString: "31/10/1999", range: NSMakeRange(328, 10),
                                formatComponents: DateFormatComponents(dayValue: "31", monthValue: "10", yearValue: "1999", formatType: .DMY)),
        ]
        var extractor = DateExtractor(prioritizedFormatType: .DMY)
        extractor.registerDefaultExtractors()
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
            .sorted(by: { $0.range.location < $1.range.location } )
        
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
        Dates: 01-august-1920 12-sep-23 february-29-2024 01 june 23 31/10/1999 are acceptable
        """
        let expectedResults = [
            ExtractedDateResult(originalString: "01/01/01", range: NSMakeRange(64, 8),
                                formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "01", formatType: .MDY)),
            ExtractedDateResult(originalString: "09/09/23", range: NSMakeRange(73, 8),
                                formatComponents: DateFormatComponents(dayValue: "09", monthValue: "09", yearValue: "23", formatType: .MDY)),
            ExtractedDateResult(originalString: "1.9.19", range: NSMakeRange(82, 6),
                                formatComponents: DateFormatComponents(dayValue: "9", monthValue: "1", yearValue: "19", formatType: .MDY)),
            ExtractedDateResult(originalString: "10-10-24", range: NSMakeRange(89, 8),
                                formatComponents: DateFormatComponents(dayValue: "10", monthValue: "10", yearValue: "24", formatType: .MDY)),
            ExtractedDateResult(originalString: "12.12.12", range: NSMakeRange(98, 8),
                                formatComponents: DateFormatComponents(dayValue: "12", monthValue: "12", yearValue: "12", formatType: .MDY)),
            ExtractedDateResult(originalString: "11-11-2011", range: NSMakeRange(107, 10),
                                formatComponents: DateFormatComponents(dayValue: "11", monthValue: "11", yearValue: "2011", formatType: .MDY)),
            ExtractedDateResult(originalString: "11-9-11", range: NSMakeRange(118, 7),
                                formatComponents: DateFormatComponents(dayValue: "9", monthValue: "11", yearValue: "11", formatType: .MDY)),
            ExtractedDateResult(originalString: "04/13/2033", range: NSMakeRange(173, 10),
                                formatComponents: DateFormatComponents(dayValue: "13", monthValue: "04", yearValue: "2033", formatType: .MDY)),
            ExtractedDateResult(originalString: "11/28/11", range: NSMakeRange(184, 8),
                                formatComponents: DateFormatComponents(dayValue: "28", monthValue: "11", yearValue: "11", formatType: .MDY)),
            ExtractedDateResult(originalString: "21/12/23", range: NSMakeRange(193, 8),
                                formatComponents: DateFormatComponents(dayValue: "21", monthValue: "12", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "01-august-1920", range: NSMakeRange(275, 14),
                                formatComponents: DateFormatComponents(dayValue: "01", monthValue: "august", yearValue: "1920", formatType: .DMY)),
            ExtractedDateResult(originalString: "12-sep-23", range: NSMakeRange(290, 9),
                                formatComponents: DateFormatComponents(dayValue: "12", monthValue: "sep", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "february-29-2024", range: NSMakeRange(300, 16),
                                formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2024", formatType: .MDY)),
            ExtractedDateResult(originalString: "01 june 23", range: NSMakeRange(317, 10),
                                formatComponents: DateFormatComponents(dayValue: "01", monthValue: "june", yearValue: "23", formatType: .DMY)),
            ExtractedDateResult(originalString: "june 23 31", range: NSMakeRange(320, 10),
                                formatComponents: DateFormatComponents(dayValue: "23", monthValue: "june", yearValue: "31", formatType: .MDY)),
            ExtractedDateResult(originalString: "31/10/1999", range: NSMakeRange(328, 10),
                                formatComponents: DateFormatComponents(dayValue: "31", monthValue: "10", yearValue: "1999", formatType: .DMY))
        ]
        var extractor = DateExtractor(prioritizedFormatType: .MDY)
        extractor.registerDefaultExtractors()
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
            .sorted(by: { $0.range.location < $1.range.location } )
        
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}


