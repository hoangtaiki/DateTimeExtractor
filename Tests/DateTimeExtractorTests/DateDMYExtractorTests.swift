//
//  DateDMYExtractorTests.swift
//  
//
//  Created by Harry Tran on 19/12/2023.
//

import XCTest
@testable import DateTimeExtractor

final class DateDMYExtractorTests: XCTestCase {
    
    private let extractor = DateDMYExtractor()
    private let data = TestsData()

    func test_InvalidDate_MonthNumberString_ShouldNot_Recognize() {
        let dateStrings = [
            // Splash
            "32/31/23", "31/32/23", "12/00/23", "0/1/23", "12/31/213", "12/311/2023",
            "121/31/2023", "12/0/2023", "0/31/2023", "12/31/023", "12/31/203", "1/1/223",
            "d31/12/23", "31/12/23d", "d31/12/2023", "31/12/2023d",
            // Dot
            "32.31.23", "31.32.23", "12.00.23", "0.1.23", "12.31.213", "12.311.2023",
            "121.31.2023", "12.0.2023", "0.31.2023", "12.31.023", "12.31.203", "1.1.223",
            "d31.12.23", "31.12.23d", "d31.12.2023", "31.12.2023d",
            // Hyphen
            "32-31-23", "31-32-23", "12-00-23", "0-1-23", "12-31-213", "12-311-2023",
            "121-31-2023", "12-0-2023", "0-31-2023", "12-31-023", "12-31-203", "1-1-223",
            "d31-12-23", "31-12-23d", "d31-12-2023", "31-12-2023d",
            // Mixing
            "12.31/23", "12-31/23", "12.31/23", "12/31.23", "12-31.23", "12/31-23", "12/31-223",
            "12-31/2023", "12.31/2023", "12.31/2023", "12/31.2023", "12-31.2023", "12/31-2023", "31 12 2023"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_InvalidDate_MonthNameString_ShouldNot_Recognize() {
        let dateStrings = [
            // Splash
            "dec/32/23", "dec/0/23", "dec/00/23", "december/32/23", "december/0/23", "december/00/23",
            "dec/32/2023", "dec/0/2023", "dec/00/2023", "december/32/2023", "december/0/2023", "december/00/2023",
            "ddec/31/23", "ddecember/32/2023", "december/32/20232",
            "december/31/2023/2", "this is invalidecember/31/2023/december/31/2023",
            // Dot
            "dec.32.23", "dec.0.23", "dec.00.23", "december.32.23", "december.0.23", "december.00.23",
            "dec.32.2023", "dec.0.2023", "dec.00.2023", "december.32.2023", "december.0.2023", "december.00.2023",
            "ddec.31.23", "ddecember.32.2023", "december.32.20232", "december.31.2023.2",
            "this is invalidecember.31.2023.december.31.2023",
            // Hyphen
            "dec-32-23", "dec-0-23", "dec-00-23", "december-32-23", "december-0-23", "december-00-23",
            "dec-32-2023", "dec-0-2023", "dec-00-2023", "december-32-2023", "december-0-2023", "december-00-2023",
            "ddec-31-23", "ddecember-32-2023", "december-32-20232",
            "december-31-2023-2", "this is invalidecember-31-2023-2", "this is invalidecember-31-2023-dec-31-23",
            // Space
            "dec 32 23", "dec 0 23", "dec 00 23", "december 32 23", "december 0 23", "december 00 23",
            "dec 32 2023", "dec 0 2023", "dec 00 2023", "december 32 2023", "december 0 2023", "december 00 2023",
            "ddec 31 23", "ddecember 32 2023", "december 32 20232",
            "ddec31 23", "sdecember31 23", "dec31 233", " dec31 232 ", " december312 23",
            "dec 1 23", "december 1 2023", "dec 1 23", "december 1 23",
            "this is invalidecember 31 2023", "this is invalidec 31 23 december",
            // Mixing
            "dec 31/23", "december 31/23", "dec.31/23", "dec/31.23", "december-31.23", "dec/31-23", "dec/31-223",
            "dec 31/2023", "dec 31/2023", "dec.31/2023", "dec/31.2023", "dec-31.2023", "dec/31-2023",
            "dec31.23", "dec31-23", "dec31-2023", "december31/23"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_InvalidDate_DayMonthYear_ShouldNot_Recognize() {
        let dateStrings = [
            // Splash
            "31/02/2023", "31/feb/2023", "31/february/2023", "31/02/23", "31/feb/23", "31/february/23",
            "31/06/2023", "31/jun/2023", "31/06/23",  "31/jun/23",
            "31/09/2023", "31/sep/2023", "31/september/2023", "31/09/23", "31/sep/23", "31/september/23",
            "31/11/2023", "31/nov/2023", "31/november/2023", "31/11/23", "31/nov/23", "31/november/23",
            "31/2/2023", "31/2/23",
            "31/6/2023",
            "30/02/2023", "30/feb/2023", "30/february/2023", "30/02/23", "30/feb/23", "30/february/23",
            "30/2/2023", "30/2/23",
            "29/02/2023", "29/feb/2023", "29/february/2023", "29/02/23", "29/feb/23", "29/february/23",
            "29/2/2023", "29/2/23",
            // Dot
            "31.02.2023", "31.feb.2023", "31.february.2023", "31.02.23", "31.feb.23", "31.february.23",
            "31.06.2023", "31.jun.2023", "31.06.23",  "31.jun.23",
            "31.09.2023", "31.sep.2023", "31.september.2023", "31.09.23", "31.sep.23", "31.september.23",
            "31.11.2023", "31.nov.2023", "31.november.2023", "31.11.23", "31.nov.23", "31.november.23",
            "31.2.2023", "31.2.23",
            "31.6.2023",
            "30.02.2023", "30.feb.2023", "30.february.2023", "30.02.23", "30.feb.23", "30.february.23",
            "30.2.2023", "30.2.23",
            "29.02.2023", "29.feb.2023", "29.february.2023", "29.02.23", "29.feb.23", "29.february.23",
            "29.2.2023", "29.2.23",
            // Hyphen
            "31-02-2023", "31-feb-2023", "31-february-2023", "31-02-23", "31-feb-23", "31-february-23",
            "31-06-2023", "31-jun-2023", "31-06-23", "31-jun-23",
            "31-09-2023", "31-sep-2023", "31-september-2023", "31-09-23", "31-sep-23", "31-september-23",
            "31-11-2023", "31-nov-2023", "31-november-2023", "31-11-23", "31-nov-23", "31-november-23",
            "31-2-2023", "31-2-23",
            "31-6-2023",
            "30-02-2023", "30-feb-2023", "30-february-2023", "30-02-23", "30-feb-23", "30-february-23",
            "30-2-2023", "30-2-23",
            "29-02-2023", "29-feb-2023", "29-february-2023", "29-02-23", "29-feb-23", "29-february-23",
            "29-2-2023", "29-2-23",
            // Space
            "31 feb 2023", "31 february 2023", "31 feb 23", "31 february 23",
            "31 jun 2023", "31 jun 23",
            "31 sep 2023", "31 september 2023", "31 sep 23", "31 september 23",
            "31 nov 2023", "31 november 2023", "31 11 23", "31 nov 23", "31 november 23",
            "30 feb 2023", "30 february 2023", "30 feb 23", "30 february 23",
            "29 feb 2023", "29 february 2023", "29 feb 23", "29 february 23",
            // Invalid leap-year
            "29/02/1700", "29-02-1800", "29.02.1900", "29/feb/2001", "29-february-2100", "29.02.2200", "29/02/2300",
            "29-02-2500", "29.02.2600", "29/feb/01", "29-02-1803", "29.2.1905", "29/2/2007", "29-02-2109", "29.02.2211",
            "29/02/2323", "29-february-2425", "29.02.2537", "29/02/2649", "29-02-2761", "29.02.2873", "29/02/2985"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_ValidDate_SplashForm() {
        let originalStrings = data.originalStrings_LongYear_SplashForm
        let expectedResults = data.expectedResults

        for (index, originalString) in originalStrings.enumerated() {
            let result = extractor.extractDateStringAndFormat(string: originalString).first
            let message = "Fail with \(originalString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
            XCTAssertEqual(result?.range, expectedResult.range, message)
        }
    }
    
    func test_ValidDate_AddedWhiteSpace_SplashForm() {
        let originalStrings = data.originalStrings_LongYear_SplashForm
        let expectedResults = data.expectedResults
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
    
    func test_ValidDate_DotForm() {
        let originalStrings = data.originalStrings_LongYear_SplashForm
        let expectedResults = data.expectedResults
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = originalString.replacingOccurrences(of: "/", with: ".")
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
            XCTAssertEqual(result?.range, expectedResult.range, message)
        }
    }
    
    func test_ValidDate_AddedWhiteSpace_DotForm() {
        let originalStrings = data.originalStrings_LongYear_SplashForm
        let expectedResults = data.expectedResults
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString.replacingOccurrences(of: "/", with: ".")) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
    
    func test_ValidDate_HyphenForm() {
        let originalStrings = data.originalStrings_LongYear_SplashForm
        let expectedResults = data.expectedResults
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = originalString.replacingOccurrences(of: "/", with: "-")
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
            XCTAssertEqual(result?.range, expectedResult.range, message)
        }
    }
    
    func test_ValidDate_AddedWhiteSpace_HyphenForm() {
        let originalStrings = data.originalStrings_LongYear_SplashForm
        let expectedResults = data.expectedResults
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString.replacingOccurrences(of: "/", with: "-")) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
}

private struct TestsData {
    
    let originalStrings_LongYear_SplashForm = [
        "31/01/1600", "31/03/1999", "31/05/2000", "31/07/56", "31/08/78",
        "31/10/1999", "31/12/9999",  "31/jan/91", "31/january/01",
        "31/mar/2023", "31/march/23", "31/may/1756", "31/july/2023", "31/jul/2023", 
        "31/aug/2023", "31/august/2023", "31/oct/2023", "31/october/2023", "31/dec/2023", 
        "31/december/2023", "31/1/90", "31/3/2993", "31/5/1982", "31/7/1856", "31/8/2378",
        "30/01/2023", "30/03/23", "30/09/1920", "30/05/1920", "30/1/22", 
        "30/3/53", "30/9/19", "30/10/19", "30/11/1909", "30/12/1919",
        "30/12/1919", "30/jan/2023", "30/january/23", "30/mar/2023", "30/march/2023",
        "30/apr/2023", "30/april/2023", "30/may/2023", "30/jun/2023", "30/jul/2023", 
        "30/july/22", "30/aug/2023", "30/august/17",  "30/sep/25", "30/september/44",
        "30/oct/20", "30/october/21", "30/nov/10", "30/november/90", "30/dec/23", "30/december/23",
        "29/01/2023", "29/03/23", "29/09/1920", "29/05/1920", "29/1/22", 
        "29/3/53", "29/9/19", "29/10/19", "29/11/1909", "29/12/1919",
        "29/12/1919", "29/jan/2023", "29/january/23", "29/mar/2023", "29/march/2023",
        "29/apr/2023", "29/april/2023", "29/may/2023", "29/jun/2023", "29/jul/2023", 
        "29/july/22", "29/aug/2023", "29/august/17",  "29/sep/25", "29/september/44",
        "29/oct/20", "29/october/21", "29/nov/10", "29/november/90", "29/dec/23", "29/december/23",
        "29/02/24", "29/2/1600", "29/feb/1648", "29/february/2012",
        "01/09/1600", "09/01/1999", "1/9/2000", "9/1/9999", "01/jan/24", "09/sep/12",
        "1/oct/12", "9/dec/12", "1/10/09", "1/12/92", "01/11/12",
        "10/01/1699", "19/09/2999", "10/1/9000", "19/9/1800", "10/jan/11", "19/sep/1992", 
        "10/nov/11", "19/12/1992", "20/01/12", "28/09/08", "21/1/1902", "27/9/9212", 
        "22/nov/34", "26/dec/6790", "23/1/23", "24/10/1945", "25/11/9009"
    ]
    
    let expectedResults = [
        ExtractedDateResult(originalString: "31/01/1600", formatedString: "31/01/1600", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "31/03/1999", formatedString: "31/03/1999", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "31/05/2000", formatedString: "31/05/2000", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "31/07/56", formatedString: "31/07/56", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "31/08/78", formatedString: "31/08/78", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "31/10/1999", formatedString: "31/10/1999", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "31/12/9999", formatedString: "31/12/9999", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "31/jan/91", formatedString: "31/jan/91", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "31/january/01", formatedString: "31/january/01", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "31/mar/2023", formatedString: "31/mar/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/march/23", formatedString: "31/march/23", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/may/1756", formatedString: "31/may/1756", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/july/2023", formatedString: "31/july/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "31/jul/2023", formatedString: "31/jul/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/aug/2023", formatedString: "31/aug/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/august/2023", formatedString: "31/august/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "31/oct/2023", formatedString: "31/oct/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/october/2023", formatedString: "31/october/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "31/dec/2023", formatedString: "31/dec/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "31/december/2023", formatedString: "31/december/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 16)),
        ExtractedDateResult(originalString: "31/1/90", formatedString: "31/1/90", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "31/3/2993", formatedString: "31/3/2993", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "31/5/1982", formatedString: "31/5/1982", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "31/7/1856", formatedString: "31/7/1856", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "31/8/2378", formatedString: "31/8/2378", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "30/01/2023", formatedString: "30/01/2023", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/03/23", formatedString: "30/03/23", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "30/09/1920", formatedString: "30/09/1920", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/05/1920", formatedString: "30/05/1920", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/1/22", formatedString: "30/1/22", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "30/3/53", formatedString: "30/3/53", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "30/9/19", formatedString: "30/9/19", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "30/10/19", formatedString: "30/10/19", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "30/11/1909", formatedString: "30/11/1909", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/12/1919", formatedString: "30/12/1919", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/12/1919", formatedString: "30/12/1919", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/jan/2023", formatedString: "30/jan/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/january/23", formatedString: "30/january/23", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "30/mar/2023", formatedString: "30/mar/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/march/2023", formatedString: "30/march/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "30/apr/2023", formatedString: "30/apr/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/april/2023", formatedString: "30/april/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "30/may/2023", formatedString: "30/may/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/jun/2023", formatedString: "30/jun/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/jul/2023", formatedString: "30/jul/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/july/22", formatedString: "30/july/22", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "30/aug/2023", formatedString: "30/aug/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "30/august/17", formatedString: "30/august/17", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "30/sep/25", formatedString: "30/sep/25", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "30/september/44", formatedString: "30/september/44", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "30/oct/20", formatedString: "30/oct/20", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "30/october/21", formatedString: "30/october/21", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "30/nov/10", formatedString: "30/nov/10", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "30/november/90", formatedString: "30/november/90", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "30/dec/23", formatedString: "30/dec/23", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "30/december/23", formatedString: "30/december/23", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "29/01/2023", formatedString: "29/01/2023", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/03/23", formatedString: "29/03/23", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "29/09/1920", formatedString: "29/09/1920", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/05/1920", formatedString: "29/05/1920", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/1/22", formatedString: "29/1/22", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "29/3/53", formatedString: "29/3/53", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "29/9/19", formatedString: "29/9/19", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "29/10/19", formatedString: "29/10/19", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "29/11/1909", formatedString: "29/11/1909", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/12/1919", formatedString: "29/12/1919", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/12/1919", formatedString: "29/12/1919", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/jan/2023", formatedString: "29/jan/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/january/23", formatedString: "29/january/23", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "29/mar/2023", formatedString: "29/mar/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/march/2023", formatedString: "29/march/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "29/apr/2023", formatedString: "29/apr/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/april/2023", formatedString: "29/april/2023", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "29/may/2023", formatedString: "29/may/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/jun/2023", formatedString: "29/jun/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/jul/2023", formatedString: "29/jul/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/july/22", formatedString: "29/july/22", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "29/aug/2023", formatedString: "29/aug/2023", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/august/17", formatedString: "29/august/17", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "29/sep/25", formatedString: "29/sep/25", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "29/september/44", formatedString: "29/september/44", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "29/oct/20", formatedString: "29/oct/20", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "29/october/21", formatedString: "29/october/21", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "29/nov/10", formatedString: "29/nov/10", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "29/november/90", formatedString: "29/november/90", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "29/dec/23", formatedString: "29/dec/23", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "29/december/23", formatedString: "29/december/23", dateFormat: "dd/MMMM/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "29/02/24", formatedString: "29/02/24", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "29/2/1600", formatedString: "29/2/1600", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "29/feb/1648", formatedString: "29/feb/1648", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "29/february/2012", formatedString: "29/february/2012", dateFormat: "dd/MMMM/yyyy", range: NSMakeRange(0, 16)),
        ExtractedDateResult(originalString: "01/09/1600", formatedString: "01/09/1600", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "09/01/1999", formatedString: "09/01/1999", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "1/9/2000", formatedString: "1/9/2000", dateFormat: "d/M/yyyy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "9/1/9999", formatedString: "9/1/9999", dateFormat: "d/M/yyyy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "01/jan/24", formatedString: "01/jan/24", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "09/sep/12", formatedString: "09/sep/12", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "1/oct/12", formatedString: "1/oct/12", dateFormat: "d/MMM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "9/dec/12", formatedString: "9/dec/12", dateFormat: "d/MMM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "1/10/09", formatedString: "1/10/09", dateFormat: "d/MM/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "1/12/92", formatedString: "1/12/92", dateFormat: "d/MM/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "01/11/12", formatedString: "01/11/12", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "10/01/1699", formatedString: "10/01/1699", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "19/09/2999", formatedString: "19/09/2999", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "10/1/9000", formatedString: "10/1/9000", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "19/9/1800", formatedString: "19/9/1800", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "10/jan/11", formatedString: "10/jan/11", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "19/sep/1992", formatedString: "19/sep/1992", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "10/nov/11", formatedString: "10/nov/11", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "19/12/1992", formatedString: "19/12/1992", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "20/01/12", formatedString: "20/01/12", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "28/09/08", formatedString: "28/09/08", dateFormat: "dd/MM/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "21/1/1902", formatedString: "21/1/1902", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "27/9/9212", formatedString: "27/9/9212", dateFormat: "dd/M/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "22/nov/34", formatedString: "22/nov/34", dateFormat: "dd/MMM/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "26/dec/6790", formatedString: "26/dec/6790", dateFormat: "dd/MMM/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "23/1/23", formatedString: "23/1/23", dateFormat: "dd/M/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "24/10/1945", formatedString: "24/10/1945", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "25/11/9009", formatedString: "25/11/9009", dateFormat: "dd/MM/yyyy", range: NSMakeRange(0, 10))
    ]
}
