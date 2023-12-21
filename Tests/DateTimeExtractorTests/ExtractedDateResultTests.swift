//
//  ExtractedDateResultTests.swift
//  
//
//  Created by Harry Tran on 21/12/2023.
//

import XCTest
@testable import DateTimeExtractor

final class ExtractedDateResultTests: XCTestCase {

    func testEquality() {
        let result1 = ExtractedDateResult(originalString: "2023-01-01", range: NSRange(location: 0, length: 10),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "2023", formatType: .DMY))
        let result2 = ExtractedDateResult(originalString: "2023-01-01", range: NSRange(location: 0, length: 10),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "2023", formatType: .DMY))
        XCTAssertEqual(result1, result2)
    }
    
    func testEmptyArray() {
        let emptyArray: [ExtractedDateResult] = []
        XCTAssertTrue(emptyArray.groupResultsBySameRange().isEmpty)
    }
    
    func testInequalityDifferentRange() {
        let result1 = ExtractedDateResult(originalString: "2023-01-01", range: NSRange(location: 0, length: 10),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "2023", formatType: .DMY))
        let result2 = ExtractedDateResult(originalString: "2023-01-01", range: NSRange(location: 11, length: 21),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "2023", formatType: .DMY))
        XCTAssertNotEqual(result1, result2)
    }
    
    func testSingleElementArray() {
        let result = ExtractedDateResult(originalString: "12-12-12",
                                         range: NSRange(location: 0, length: 8),
                                         formatComponents: DateFormatComponents(dayValue: "12", monthValue: "12", yearValue: "12", formatType: .DMY))
        let singleElementArray = [result]
        
        XCTAssertEqual(singleElementArray.groupResultsBySameRange(), [[result]])
    }
    
    func testGetResultsWithSameRange() {
        let result1 = ExtractedDateResult(originalString: "01-01-01", range: NSRange(location: 0, length: 8),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "01", formatType: .DMY))
        let result2 = ExtractedDateResult(originalString: "01-02-03", range: NSRange(location: 9, length: 17),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "02", yearValue: "03", formatType: .DMY))
        let result3 = ExtractedDateResult(originalString: "01-01-01", range: NSRange(location: 0, length: 8),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "01", formatType: .MDY))
        let result4 = ExtractedDateResult(originalString: "01-01-01", range: NSRange(location: 0, length: 8),
                                          formatComponents: DateFormatComponents(dayValue: "01", monthValue: "01", yearValue: "01", formatType: .YMD))
        let result5 = ExtractedDateResult(originalString: "01-02-03", range: NSRange(location: 9, length: 17),
                                          formatComponents: DateFormatComponents(dayValue: "02", monthValue: "01", yearValue: "03", formatType: .MDY))
        let result6 = ExtractedDateResult(originalString: "21-12-25", range: NSRange(location: 18, length: 26),
                                          formatComponents: DateFormatComponents(dayValue: "21", monthValue: "12", yearValue: "25", formatType: .DMY))
        
        let inputArray = [result1, result2, result3, result4, result5, result6]
        let sameRangeResults = inputArray.groupResultsBySameRange()
        
        XCTAssertEqual(sameRangeResults.count, 3)
        XCTAssertEqual(sameRangeResults[0], [result1, result3, result4])
        XCTAssertEqual(sameRangeResults[1], [result2, result5])
        XCTAssertEqual(sameRangeResults[2], [result6])
    }
}
