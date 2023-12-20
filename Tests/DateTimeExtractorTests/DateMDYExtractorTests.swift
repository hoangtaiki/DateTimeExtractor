//
//  DateMDYExtractorTests.swift
//  
//
//  Created by Harry Tran on 20/12/2023.
//

import XCTest
@testable import DateTimeExtractor

final class DateMDYExtractorTests: XCTestCase {
    
    private let extractor = DateMDYExtractor()
    private let data = TestsData()
    
    func test_InvalidDate_ShouldNot_Recognize() {
        let dateStrings = [
            // Slash
            "12/32/23", "12/32/2023", "12/00/23", "12/0/2023", "01/01/1599", "2/28/10001",
            "jan/32/23", "november/0/2023", "dec/00/23", "december/01/20234", "1/301/1923",
            "d12/31/2023", "12/31/2023d", "12/31/23d", "31/invalidecember/2023", "1/01/223",
            // Dot
            "12.32.23", "12.32.2023", "12.00.23", "12.0.2023", "01.01.1599", "2.28.10001",
            "jan.32.23", "november.0.2023", "dec.00.23", "december.01.20234", "1.301.1923",
            "d12.31.2023", "12.31.2023d", "12.31.23d", "31.invalidecember.2023", "1.01.223",
            // Hyphen
            "12-32-23", "12-32-2023", "12-00-23", "12-0-2023", "01-01-1599", "2-28-10001",
            "jan-32-23", "november-0-2023", "dec-00-23", "december-01-20234", "1-301-1923",
            "d12-31-2023", "12-31-2023d", "12-31-23d", "31-invalidecember-2023", "1-01-223",
            // Space
            "12 32 23", "12 32 2023", "12 00 23", "12 0 2023", "01 01 1599", "2 28 10001",
            "jan 32 23", "november 0 2023", "dec 00 23", "december 01 20234", "1 301 1923",
            "d12 31 2023", "12 31 2023d", "12 31 23d", "31 invalidecember 2023", "1 01 223",
            // Mixing
            "12.31/23", "02 01/1992", "2-28/1898", "5/1.12", "oct 30.1782", "feb-28.2024",
            "may/02-13", "september.30-1990", "02 10-23", "01 01 23", "12 31 2023",
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_InvalidDate_MonthNameString_ShouldNot_Recognize() {
        let dateStrings = [
            // Slash
            "02/31/2023", "feb/31/2023", "february/31/2023", "02/31/23", "feb/31/23", "february/31/23",
            "06/31/2023", "jun/31/2023", "06/31/23", "jun/31/23",
            "09/31/2023", "sep/31/2023", "september/31/2023", "09/31/23", "sep/31/23", "september/31/23",
            "11/31/2023", "nov/31/2023", "november/31/2023", "11/31/23", "nov/31/23", "november/31/23",
            "2/31/2023", "2/31/23",
            "6/31/2023",
            "02/30/2023", "feb/30/2023", "february/30/2023", "02/30/23", "feb/30/23", "february/30/23",
            "2/30/2023", "2/30/23",
            "02/29/2023", "feb/29/2023", "february/29/2023", "02/29/23", "feb/29/23", "february/29/23",
            "2/29/2023", "2/29/23",
            // Dot
            "02.31.2023", "feb.31.2023", "february.31.2023", "02.31.23", "feb.31.23", "february.31.23",
            "06.31.2023", "jun.31.2023", "06.31.23", "jun.31.23",
            "09.31.2023", "sep.31.2023", "september.31.2023", "09.31.23", "sep.31.23", "september.31.23",
            "11.31.2023", "nov.31.2023", "november.31.2023", "11.31.23", "nov.31.23", "november.31.23",
            "2.31.2023", "2.31.23",
            "6.31.2023",
            "02.30.2023", "feb.30.2023", "february.30.2023", "02.30.23", "feb.30.23", "february.30.23",
            "2.30.2023", "2.30.23",
            "02.29.2023", "feb.29.2023", "february.29.2023", "02.29.23", "feb.29.23", "february.29.23",
            "2.29.2023", "2.29.23",
            // Hyphen
            "02-31-2023", "feb-31-2023", "february-31-2023", "02-31-23", "feb-31-23", "february-31-23",
            "06-31-2023", "jun-31-2023", "06-31-23", "jun-31-23",
            "09-31-2023", "sep-31-2023", "september-31-2023", "09-31-23", "sep-31-23", "september-31-23",
            "11-31-2023", "nov-31-2023", "november-31-2023", "11-31-23", "nov-31-23", "november-31-23",
            "2-31-2023", "2-31-23",
            "6-31-2023",
            "02-30-2023", "feb-30-2023", "february-30-2023", "02-30-23", "feb-30-23", "february-30-23",
            "2-30-2023", "2-30-23",
            "02-29-2023", "feb-29-2023", "february-29-2023", "02-29-23", "feb-29-23", "february-29-23",
            "2-29-2023", "2-29-23",
            // Space
            "feb 31 2023", "february 31 2023", "feb 31 23", "february 31 23",
            "jun 31 2023", "jun 31 23",
            "sep 31 2023", "september 31 2023", "sep 31 23", "september 31 23",
            "nov 31 2023", "november 31 2023", "11 31 23", "nov 31 23", "november 31 23",
            "feb 30 2023", "february 30 2023", "feb 30 23", "february 30 23",
            "feb 29 2023", "february 29 2023", "feb 29 23", "february 29 23",
            // Invalid leap-year
            "02/29/1700", "02-29-1800", "02.29.1900", "feb/29/2001", "february-29-2100", "02.29.2200", "02/29/2300",
            "02-29-2500", "02.29.2600", "feb/29/01", "02-29-1803", "2.29.1905", "2/29/2007", "02-29-2109", "02.29.2211",
            "02/29/2323", "february-29-2425", "02.29.2537", "02/29/2649", "02-29-2761", "02.29.2873", "02/29/2985"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_ValidDate_SlashFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
        for (index, originalString) in originalStrings.enumerated() {
            let result = extractor.extractDateStringAndFormat(string: originalString).first
            let message = "Fail with \(originalString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
            XCTAssertEqual(result?.range, expectedResult.range, message)
        }
    }
    
    func test_ValidDate_AddedWhiteSpace_SlashFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
    
    func test_ValidDate_DotFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
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
    
    func test_ValidDate_AddedWhiteSpace_DotFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString.replacingOccurrences(of: "/", with: ".")) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
    
    func test_ValidDate_HyphenFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
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
    
    func test_ValidDate_AddedWhiteSpace_HyphenFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString.replacingOccurrences(of: "/", with: "-")) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
    
    func test_ValidDate_SpaceFormat() {
        let originalStrings = data.originalStrings_SpaceFormat
        let expectedResults = data.expectedResults_SpaceFormat
        
        for (index, originalString) in originalStrings.enumerated() {
            let result = extractor.extractDateStringAndFormat(string: originalString).first
            let message = "Fail with \(originalString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
            XCTAssertEqual(result?.range, expectedResult.range, message)
        }
    }
    
    func test_ValidDate_AddedWhiteSpace_SpaceFormat() {
        let originalStrings = data.originalStrings_SlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
        for (index, originalString) in originalStrings.enumerated() {
            let modifiedString = " \(originalString) "
            let result = extractor.extractDateStringAndFormat(string: modifiedString).first
            let message = "Fail with \(modifiedString). Index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result?.formatedString, expectedResult.formatedString, message)
            XCTAssertEqual(result?.dateFormat, expectedResult.dateFormat, message)
        }
    }
}

private struct TestsData {
    
    let originalStrings_SlashFormat = [
        "01/31/1600", "03/31/1999", "05/31/2000", "07/31/56", "08/31/78",
        "10/31/1999", "12/31/9999", "jan/31/91", "january/31/01",
        "mar/31/2023", "march/31/23", "may/31/1756", "july/31/2023", "jul/31/2023",
        "aug/31/2023", "august/31/2023", "oct/31/2023", "october/31/2023", "dec/31/2023",
        "december/31/2023", "1/31/90", "3/31/2993", "5/31/1982", "7/31/1856", "8/31/2378",
        "01/30/2023", "03/30/23", "09/30/1920", "05/30/1920", "1/30/22",
        "3/30/53", "9/30/19", "10/30/19", "11/30/1909", "12/30/1919",
        "12/30/1919", "jan/30/2023", "january/30/23", "mar/30/2023", "march/30/2023",
        "apr/30/2023", "april/30/2023", "may/30/2023", "jun/30/2023", "jul/30/2023",
        "july/30/22", "aug/30/2023", "august/30/17", "sep/30/25", "september/30/44",
        "oct/30/20", "october/30/21", "nov/30/10", "november/30/90", "dec/30/23", "december/30/23",
        "01/29/2023", "03/29/23", "09/29/1920", "05/29/1920", "1/29/22",
        "3/29/53", "9/29/19", "10/29/19", "11/29/1909", "12/29/1919",
        "12/29/1919", "jan/29/2023", "january/29/23", "mar/29/2023", "march/29/2023",
        "apr/29/2023", "april/29/2023", "may/29/2023", "jun/29/2023", "jul/29/2023",
        "july/29/22", "aug/29/2023", "august/29/17", "sep/29/25", "september/29/44",
        "oct/29/20", "october/29/21", "nov/29/10", "november/29/90", "dec/29/23", "december/29/23",
        "02/29/24", "2/29/1600", "feb/29/1648", "february/29/2012",
        "09/01/1600", "01/09/1999", "9/1/2000", "1/9/9999", "jan/01/24", "sep/09/12",
        "oct/1/12", "dec/9/12", "10/1/09", "12/1/92", "11/01/12",
        "01/10/1699", "09/19/2999", "1/10/9000", "9/19/1800", "jan/10/11", "sep/19/1992",
        "nov/10/11", "12/19/1992", "01/20/12", "09/28/08", "1/21/1902", "9/27/9212",
        "nov/22/34", "dec/26/6790", "1/23/23", "10/24/1945", "11/25/9009"
    ]
    
    let expectedResults_SlashFormat = [
        ExtractedDateResult(originalString: "01/31/1600", formatedString: "01/31/1600", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "03/31/1999", formatedString: "03/31/1999", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "05/31/2000", formatedString: "05/31/2000", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "07/31/56", formatedString: "07/31/56", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "08/31/78", formatedString: "08/31/78", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "10/31/1999", formatedString: "10/31/1999", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "12/31/9999", formatedString: "12/31/9999", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "jan/31/91", formatedString: "jan/31/91", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "january/31/01", formatedString: "january/31/01", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "mar/31/2023", formatedString: "mar/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "march/31/23", formatedString: "march/31/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "may/31/1756", formatedString: "may/31/1756", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "july/31/2023", formatedString: "july/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "jul/31/2023", formatedString: "jul/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "aug/31/2023", formatedString: "aug/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "august/31/2023", formatedString: "august/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "oct/31/2023", formatedString: "oct/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "october/31/2023", formatedString: "october/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "dec/31/2023", formatedString: "dec/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "december/31/2023", formatedString: "december/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 16)),
        ExtractedDateResult(originalString: "1/31/90", formatedString: "1/31/90", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "3/31/2993", formatedString: "3/31/2993", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "5/31/1982", formatedString: "5/31/1982", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "7/31/1856", formatedString: "7/31/1856", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "8/31/2378", formatedString: "8/31/2378", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "01/30/2023", formatedString: "01/30/2023", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "03/30/23", formatedString: "03/30/23", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "09/30/1920", formatedString: "09/30/1920", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "05/30/1920", formatedString: "05/30/1920", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "1/30/22", formatedString: "1/30/22", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "3/30/53", formatedString: "3/30/53", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "9/30/19", formatedString: "9/30/19", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "10/30/19", formatedString: "10/30/19", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "11/30/1909", formatedString: "11/30/1909", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "12/30/1919", formatedString: "12/30/1919", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "12/30/1919", formatedString: "12/30/1919", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "jan/30/2023", formatedString: "jan/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "january/30/23", formatedString: "january/30/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "mar/30/2023", formatedString: "mar/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "march/30/2023", formatedString: "march/30/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "apr/30/2023", formatedString: "apr/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "april/30/2023", formatedString: "april/30/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "may/30/2023", formatedString: "may/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jun/30/2023", formatedString: "jun/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jul/30/2023", formatedString: "jul/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "july/30/22", formatedString: "july/30/22", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "aug/30/2023", formatedString: "aug/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "august/30/17", formatedString: "august/30/17", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "sep/30/25", formatedString: "sep/30/25", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "september/30/44", formatedString: "september/30/44", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "oct/30/20", formatedString: "oct/30/20", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "october/30/21", formatedString: "october/30/21", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "nov/30/10", formatedString: "nov/30/10", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "november/30/90", formatedString: "november/30/90", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "dec/30/23", formatedString: "dec/30/23", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "december/30/23", formatedString: "december/30/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "01/29/2023", formatedString: "01/29/2023", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "03/29/23", formatedString: "03/29/23", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "09/29/1920", formatedString: "09/29/1920", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "05/29/1920", formatedString: "05/29/1920", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "1/29/22", formatedString: "1/29/22", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "3/29/53", formatedString: "3/29/53", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "9/29/19", formatedString: "9/29/19", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "10/29/19", formatedString: "10/29/19", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "11/29/1909", formatedString: "11/29/1909", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "12/29/1919", formatedString: "12/29/1919", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "12/29/1919", formatedString: "12/29/1919", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "jan/29/2023", formatedString: "jan/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "january/29/23", formatedString: "january/29/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "mar/29/2023", formatedString: "mar/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "march/29/2023", formatedString: "march/29/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "apr/29/2023", formatedString: "apr/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "april/29/2023", formatedString: "april/29/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "may/29/2023", formatedString: "may/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jun/29/2023", formatedString: "jun/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jul/29/2023", formatedString: "jul/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "july/29/22", formatedString: "july/29/22", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "aug/29/2023", formatedString: "aug/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "august/29/17", formatedString: "august/29/17", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "sep/29/25", formatedString: "sep/29/25", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "september/29/44", formatedString: "september/29/44", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "oct/29/20", formatedString: "oct/29/20", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "october/29/21", formatedString: "october/29/21", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "nov/29/10", formatedString: "nov/29/10", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "november/29/90", formatedString: "november/29/90", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "dec/29/23", formatedString: "dec/29/23", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "december/29/23", formatedString: "december/29/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "02/29/24", formatedString: "02/29/24", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "2/29/1600", formatedString: "2/29/1600", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "feb/29/1648", formatedString: "feb/29/1648", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "february/29/2012", formatedString: "february/29/2012", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 16)),
        ExtractedDateResult(originalString: "09/01/1600", formatedString: "09/01/1600", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "01/09/1999", formatedString: "01/09/1999", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "9/1/2000", formatedString: "9/1/2000", dateFormat: "M/d/yyyy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "1/9/9999", formatedString: "1/9/9999", dateFormat: "M/d/yyyy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "jan/01/24", formatedString: "jan/01/24", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "sep/09/12", formatedString: "sep/09/12", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "oct/1/12", formatedString: "oct/1/12", dateFormat: "MMM/d/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "dec/9/12", formatedString: "dec/9/12", dateFormat: "MMM/d/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "10/1/09", formatedString: "10/1/09", dateFormat: "MM/d/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "12/1/92", formatedString: "12/1/92", dateFormat: "MM/d/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "11/01/12", formatedString: "11/01/12", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "01/10/1699", formatedString: "01/10/1699", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "09/19/2999", formatedString: "09/19/2999", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "1/10/9000", formatedString: "1/10/9000", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "9/19/1800", formatedString: "9/19/1800", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "jan/10/11", formatedString: "jan/10/11", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "sep/19/1992", formatedString: "sep/19/1992", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "nov/10/11", formatedString: "nov/10/11", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "12/19/1992", formatedString: "12/19/1992", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "01/20/12", formatedString: "01/20/12", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "09/28/08", formatedString: "09/28/08", dateFormat: "MM/dd/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "1/21/1902", formatedString: "1/21/1902", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "9/27/9212", formatedString: "9/27/9212", dateFormat: "M/dd/yyyy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "nov/22/34", formatedString: "nov/22/34", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "dec/26/6790", formatedString: "dec/26/6790", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "1/23/23", formatedString: "1/23/23", dateFormat: "M/dd/yy", range: NSMakeRange(0, 7)),
        ExtractedDateResult(originalString: "10/24/1945", formatedString: "10/24/1945", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "11/25/9009", formatedString: "11/25/9009", dateFormat: "MM/dd/yyyy", range: NSMakeRange(0, 10))
    ]
    
    let originalStrings_SpaceFormat = [
        "jan 31 91", "january 31 01", "mar 31 2023", "march 31 23", "may 31 1756",
        "july 31 2023", "jul 31 2023", "aug 31 2023", "august 31 2023", "oct 31 2023",
        "october 31 2023", "dec 31 2023", "december 31 2023",
        "jan 30 2023", "january 30 23", "mar 30 2023", "march 30 2023",
        "apr 30 2023", "april 30 2023", "may 30 2023", "jun 30 2023", "jul 30 2023",
        "july 30 22", "aug 30 2023", "august 30 17",  "sep 30 25", "september 30 44",
        "oct 30 20", "october 30 21", "nov 30 10", "november 30 90", "dec 30 23", "december 30 23",
        "jan 29 2023", "january 29 23", "mar 29 2023", "march 29 2023",
        "apr 29 2023", "april 29 2023", "may 29 2023", "jun 29 2023", "jul 29 2023",
        "july 29 22", "aug 29 2023", "august 29 17",  "sep 29 25", "september 29 44",
        "oct 29 20", "october 29 21", "nov 29 10", "november 29 90", "dec 29 23", "december 29 23",
        "feb 29 1648", "february 29 2012", "jan 01 24", "sep 09 12",
        "oct 1 12", "dec 9 12", "jan 10 11", "sep 19 1992", "nov 10 11", "nov 22 34", "dec 26 6790"
    ]
    
    let expectedResults_SpaceFormat = [
        ExtractedDateResult(originalString: "jan 31 91", formatedString: "jan/31/91", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "january 31 01", formatedString: "january/31/01", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "mar 31 2023", formatedString: "mar/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "march 31 23", formatedString: "march/31/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "may 31 1756", formatedString: "may/31/1756", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "july 31 2023", formatedString: "july/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "jul 31 2023", formatedString: "jul/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "aug 31 2023", formatedString: "aug/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "august 31 2023", formatedString: "august/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "oct 31 2023", formatedString: "oct/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "october 31 2023", formatedString: "october/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "dec 31 2023", formatedString: "dec/31/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "december 31 2023", formatedString: "december/31/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 16)),
        ExtractedDateResult(originalString: "jan 30 2023", formatedString: "jan/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "january 30 23", formatedString: "january/30/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "mar 30 2023", formatedString: "mar/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "march 30 2023", formatedString: "march/30/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "apr 30 2023", formatedString: "apr/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "april 30 2023", formatedString: "april/30/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "may 30 2023", formatedString: "may/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jun 30 2023", formatedString: "jun/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jul 30 2023", formatedString: "jul/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "july 30 22", formatedString: "july/30/22", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "aug 30 2023", formatedString: "aug/30/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "august 30 17", formatedString: "august/30/17", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "sep 30 25", formatedString: "sep/30/25", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "september 30 44", formatedString: "september/30/44", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "oct 30 20", formatedString: "oct/30/20", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "october 30 21", formatedString: "october/30/21", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "nov 30 10", formatedString: "nov/30/10", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "november 30 90", formatedString: "november/30/90", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "dec 30 23", formatedString: "dec/30/23", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "december 30 23", formatedString: "december/30/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "jan 29 2023", formatedString: "jan/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "january 29 23", formatedString: "january/29/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "mar 29 2023", formatedString: "mar/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "march 29 2023", formatedString: "march/29/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "apr 29 2023", formatedString: "apr/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "april 29 2023", formatedString: "april/29/2023", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "may 29 2023", formatedString: "may/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jun 29 2023", formatedString: "jun/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "jul 29 2023", formatedString: "jul/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "july 29 22", formatedString: "july/29/22", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 10)),
        ExtractedDateResult(originalString: "aug 29 2023", formatedString: "aug/29/2023", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "august 29 17", formatedString: "august/29/17", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 12)),
        ExtractedDateResult(originalString: "sep 29 25", formatedString: "sep/29/25", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "september 29 44", formatedString: "september/29/44", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 15)),
        ExtractedDateResult(originalString: "oct 29 20", formatedString: "oct/29/20", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "october 29 21", formatedString: "october/29/21", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 13)),
        ExtractedDateResult(originalString: "nov 29 10", formatedString: "nov/29/10", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "november 29 90", formatedString: "november/29/90", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "dec 29 23", formatedString: "dec/29/23", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "december 29 23", formatedString: "december/29/23", dateFormat: "MMMM/dd/yy", range: NSMakeRange(0, 14)),
        ExtractedDateResult(originalString: "feb 29 1648", formatedString: "feb/29/1648", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "february 29 2012", formatedString: "february/29/2012", dateFormat: "MMMM/dd/yyyy", range: NSMakeRange(0, 16)),
        ExtractedDateResult(originalString: "jan 01 24", formatedString: "jan/01/24", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "sep 09 12", formatedString: "sep/09/12", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "oct 1 12", formatedString: "oct/1/12", dateFormat: "MMM/d/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "dec 9 12", formatedString: "dec/9/12", dateFormat: "MMM/d/yy", range: NSMakeRange(0, 8)),
        ExtractedDateResult(originalString: "jan 10 11", formatedString: "jan/10/11", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "sep 19 1992", formatedString: "sep/19/1992", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11)),
        ExtractedDateResult(originalString: "nov 10 11", formatedString: "nov/10/11", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "nov 22 34", formatedString: "nov/22/34", dateFormat: "MMM/dd/yy", range: NSMakeRange(0, 9)),
        ExtractedDateResult(originalString: "dec 26 6790", formatedString: "dec/26/6790", dateFormat: "MMM/dd/yyyy", range: NSMakeRange(0, 11))
    ]
}
