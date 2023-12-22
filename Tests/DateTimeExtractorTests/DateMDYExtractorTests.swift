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
        let paragraph = data.paragraphSlashFormat
        let expectedResults = data.expectedResults_SlashFormat
        
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location } )
        
        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
    
    func test_ValidDate_DotFormat() {
        let paragraph = data.paragraphSlashFormat.replacingOccurrences(of: "/", with: ".")
        let expectedResults = data.expectedResults_SlashFormat
        
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location } )
        
        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result.range, expectedResult.range, message)
            XCTAssertEqual(result.formatComponents.getFormat(), expectedResult.formatComponents.getFormat(), message)
            XCTAssertEqual(result.formatComponents.getFormattedString(), expectedResult.formatComponents.getFormattedString(), message)
        }
    }

    func test_ValidDate_HyphenFormat() {
        let paragraph = data.paragraphSlashFormat.replacingOccurrences(of: "/", with: "-")
        let expectedResults = data.expectedResults_SlashFormat
        
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location } )
        
        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result.range, expectedResult.range, message)
            XCTAssertEqual(result.formatComponents.getFormat(), expectedResult.formatComponents.getFormat(), message)
            XCTAssertEqual(result.formatComponents.getFormattedString(), expectedResult.formatComponents.getFormattedString(), message)
        }
    }
    
    func test_ValidDate_SpaceFormat() {
        let paragraph = data.paragraphSpaceFormat
        let expectedResults = data.expectedResults_SpaceFormat
        
        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location } )
        
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }
}

private struct TestsData {
    
    let paragraphSlashFormat = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    1. These are many single dates which can be recognized:

    01/31/1600 03/31/1999 05/31/2000 07/31/56 08/31/78 10/31/1999 12/31/9999 jan/31/91 january/31/01 mar/31/2023 
    march/31/23 may/31/1756 july/31/2023 jul/31/2023 aug/31/2023 august/31/2023 oct/31/2023 october/31/2023
    dec/31/2023 december/31/2023 1/31/90 3/31/2993 5/31/1982 7/31/1856 8/31/2378 01/30/2023 03/30/23 09/30/1920 
    05/30/1920 1/30/22 3/30/53 9/30/19 10/30/19 11/30/1909 12/30/1919 12/30/1919 jan/30/2023 january/30/23
    mar/30/2023 march/30/2023 apr/30/2023 april/30/2023 may/30/2023 jun/30/2023 jul/30/2023 july/30/22 aug/30/2023
    august/30/17 sep/30/25 september/30/44 oct/30/20 october/30/21 nov/30/10 november/30/90 dec/30/23 december/30/23
    01/29/2023 03/29/23 09/29/1920 05/29/1920 1/29/22 3/29/53 9/29/19 10/29/19 11/29/1909 12/29/1919 12/29/1919
    jan/29/2023 january/29/23 mar/29/2023 march/29/2023 apr/29/2023 april/29/2023 may/29/2023 jun/29/2023 jul/29/2023
    july/29/22 aug/29/2023 august/29/17 sep/29/25 september/29/44 oct/29/20 october/29/21 nov/29/10 november/29/90
    dec/29/23 december/29/23 02/29/24 2/29/1600 feb/29/1648 february/29/2012 09/01/1600 01/09/1999 9/1/2000 1/9/9999
    jan/01/24 sep/09/12 oct/1/12 dec/9/12 10/1/09 12/1/92 11/01/12 01/10/1699 09/19/2999 1/10/9000 9/19/1800
    jan/10/11 sep/19/1992 nov/10/11 12/19/1992 01/20/12 09/28/08 1/21/1902 9/27/9212 nov/22/34
    dec/26/6790 1/23/23 10/24/1945 11/25/9009  JUNE/20/2023 June/23/23 January/24/2022
    2. But some dates with sepecial characters still can be recognized
    dec/31/2023 jan/31/23
    dec/28/2023-may/31/2023
    mar/31/2023/may/31/2023
    mar/31/2023+may/31/05/2023
    january/31/31/may/2023
    jan/31/31/0
    jan/31/23/may/31/2023
    dec/31/23/
    """
    
    let expectedResults_SlashFormat = [
        ExtractedDateResult(original: "01/31/1600", range: NSRange(location: 114, length: 10), day: "31", month: "01", year: "1600", formatType: .MDY),
        ExtractedDateResult(original: "03/31/1999", range: NSRange(location: 125, length: 10), day: "31", month: "03", year: "1999", formatType: .MDY),
        ExtractedDateResult(original: "05/31/2000", range: NSRange(location: 136, length: 10), day: "31", month: "05", year: "2000", formatType: .MDY),
        ExtractedDateResult(original: "07/31/56", range: NSRange(location: 147, length: 8), day: "31", month: "07", year: "56", formatType: .MDY),
        ExtractedDateResult(original: "08/31/78", range: NSRange(location: 156, length: 8), day: "31", month: "08", year: "78", formatType: .MDY),
        ExtractedDateResult(original: "10/31/1999", range: NSRange(location: 165, length: 10), day: "31", month: "10", year: "1999", formatType: .MDY),
        ExtractedDateResult(original: "12/31/9999", range: NSRange(location: 176, length: 10), day: "31", month: "12", year: "9999", formatType: .MDY),
        ExtractedDateResult(original: "jan/31/91", range: NSRange(location: 187, length: 9), day: "31", month: "jan", year: "91", formatType: .MDY),
        ExtractedDateResult(original: "january/31/01", range: NSRange(location: 197, length: 13), day: "31", month: "january", year: "01", formatType: .MDY),
        ExtractedDateResult(original: "mar/31/2023", range: NSRange(location: 211, length: 11), day: "31", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "march/31/23", range: NSRange(location: 224, length: 11), day: "31", month: "march", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "may/31/1756", range: NSRange(location: 236, length: 11), day: "31", month: "may", year: "1756", formatType: .MDY),
        ExtractedDateResult(original: "july/31/2023", range: NSRange(location: 248, length: 12), day: "31", month: "july", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jul/31/2023", range: NSRange(location: 261, length: 11), day: "31", month: "jul", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "aug/31/2023", range: NSRange(location: 273, length: 11), day: "31", month: "aug", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "august/31/2023", range: NSRange(location: 285, length: 14), day: "31", month: "august", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "oct/31/2023", range: NSRange(location: 300, length: 11), day: "31", month: "oct", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "october/31/2023", range: NSRange(location: 312, length: 15), day: "31", month: "october", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "dec/31/2023", range: NSRange(location: 328, length: 11), day: "31", month: "dec", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "december/31/2023", range: NSRange(location: 340, length: 16), day: "31", month: "december", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "1/31/90", range: NSRange(location: 357, length: 7), day: "31", month: "1", year: "90", formatType: .MDY),
        ExtractedDateResult(original: "3/31/2993", range: NSRange(location: 365, length: 9), day: "31", month: "3", year: "2993", formatType: .MDY),
        ExtractedDateResult(original: "5/31/1982", range: NSRange(location: 375, length: 9), day: "31", month: "5", year: "1982", formatType: .MDY),
        ExtractedDateResult(original: "7/31/1856", range: NSRange(location: 385, length: 9), day: "31", month: "7", year: "1856", formatType: .MDY),
        ExtractedDateResult(original: "8/31/2378", range: NSRange(location: 395, length: 9), day: "31", month: "8", year: "2378", formatType: .MDY),
        ExtractedDateResult(original: "01/30/2023", range: NSRange(location: 405, length: 10), day: "30", month: "01", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "03/30/23", range: NSRange(location: 416, length: 8), day: "30", month: "03", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "09/30/1920", range: NSRange(location: 425, length: 10), day: "30", month: "09", year: "1920", formatType: .MDY),
        ExtractedDateResult(original: "05/30/1920", range: NSRange(location: 437, length: 10), day: "30", month: "05", year: "1920", formatType: .MDY),
        ExtractedDateResult(original: "1/30/22", range: NSRange(location: 448, length: 7), day: "30", month: "1", year: "22", formatType: .MDY),
        ExtractedDateResult(original: "3/30/53", range: NSRange(location: 456, length: 7), day: "30", month: "3", year: "53", formatType: .MDY),
        ExtractedDateResult(original: "9/30/19", range: NSRange(location: 464, length: 7), day: "30", month: "9", year: "19", formatType: .MDY),
        ExtractedDateResult(original: "10/30/19", range: NSRange(location: 472, length: 8), day: "30", month: "10", year: "19", formatType: .MDY),
        ExtractedDateResult(original: "11/30/1909", range: NSRange(location: 481, length: 10), day: "30", month: "11", year: "1909", formatType: .MDY),
        ExtractedDateResult(original: "12/30/1919", range: NSRange(location: 492, length: 10), day: "30", month: "12", year: "1919", formatType: .MDY),
        ExtractedDateResult(original: "12/30/1919", range: NSRange(location: 503, length: 10), day: "30", month: "12", year: "1919", formatType: .MDY),
        ExtractedDateResult(original: "jan/30/2023", range: NSRange(location: 514, length: 11), day: "30", month: "jan", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "january/30/23", range: NSRange(location: 526, length: 13), day: "30", month: "january", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "mar/30/2023", range: NSRange(location: 540, length: 11), day: "30", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "march/30/2023", range: NSRange(location: 552, length: 13), day: "30", month: "march", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "apr/30/2023", range: NSRange(location: 566, length: 11), day: "30", month: "apr", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "april/30/2023", range: NSRange(location: 578, length: 13), day: "30", month: "april", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may/30/2023", range: NSRange(location: 592, length: 11), day: "30", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jun/30/2023", range: NSRange(location: 604, length: 11), day: "30", month: "jun", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jul/30/2023", range: NSRange(location: 616, length: 11), day: "30", month: "jul", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "july/30/22", range: NSRange(location: 628, length: 10), day: "30", month: "july", year: "22", formatType: .MDY),
        ExtractedDateResult(original: "aug/30/2023", range: NSRange(location: 639, length: 11), day: "30", month: "aug", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "august/30/17", range: NSRange(location: 651, length: 12), day: "30", month: "august", year: "17", formatType: .MDY),
        ExtractedDateResult(original: "sep/30/25", range: NSRange(location: 664, length: 9), day: "30", month: "sep", year: "25", formatType: .MDY),
        ExtractedDateResult(original: "september/30/44", range: NSRange(location: 674, length: 15), day: "30", month: "september", year: "44", formatType: .MDY),
        ExtractedDateResult(original: "oct/30/20", range: NSRange(location: 690, length: 9), day: "30", month: "oct", year: "20", formatType: .MDY),
        ExtractedDateResult(original: "october/30/21", range: NSRange(location: 700, length: 13), day: "30", month: "october", year: "21", formatType: .MDY),
        ExtractedDateResult(original: "nov/30/10", range: NSRange(location: 714, length: 9), day: "30", month: "nov", year: "10", formatType: .MDY),
        ExtractedDateResult(original: "november/30/90", range: NSRange(location: 724, length: 14), day: "30", month: "november", year: "90", formatType: .MDY),
        ExtractedDateResult(original: "dec/30/23", range: NSRange(location: 739, length: 9), day: "30", month: "dec", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "december/30/23", range: NSRange(location: 749, length: 14), day: "30", month: "december", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "01/29/2023", range: NSRange(location: 764, length: 10), day: "29", month: "01", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "03/29/23", range: NSRange(location: 775, length: 8), day: "29", month: "03", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "09/29/1920", range: NSRange(location: 784, length: 10), day: "29", month: "09", year: "1920", formatType: .MDY),
        ExtractedDateResult(original: "05/29/1920", range: NSRange(location: 795, length: 10), day: "29", month: "05", year: "1920", formatType: .MDY),
        ExtractedDateResult(original: "1/29/22", range: NSRange(location: 806, length: 7), day: "29", month: "1", year: "22", formatType: .MDY),
        ExtractedDateResult(original: "3/29/53", range: NSRange(location: 814, length: 7), day: "29", month: "3", year: "53", formatType: .MDY),
        ExtractedDateResult(original: "9/29/19", range: NSRange(location: 822, length: 7), day: "29", month: "9", year: "19", formatType: .MDY),
        ExtractedDateResult(original: "10/29/19", range: NSRange(location: 830, length: 8), day: "29", month: "10", year: "19", formatType: .MDY),
        ExtractedDateResult(original: "11/29/1909", range: NSRange(location: 839, length: 10), day: "29", month: "11", year: "1909", formatType: .MDY),
        ExtractedDateResult(original: "12/29/1919", range: NSRange(location: 850, length: 10), day: "29", month: "12", year: "1919", formatType: .MDY),
        ExtractedDateResult(original: "12/29/1919", range: NSRange(location: 861, length: 10), day: "29", month: "12", year: "1919", formatType: .MDY),
        ExtractedDateResult(original: "jan/29/2023", range: NSRange(location: 872, length: 11), day: "29", month: "jan", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "january/29/23", range: NSRange(location: 884, length: 13), day: "29", month: "january", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "mar/29/2023", range: NSRange(location: 898, length: 11), day: "29", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "march/29/2023", range: NSRange(location: 910, length: 13), day: "29", month: "march", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "apr/29/2023", range: NSRange(location: 924, length: 11), day: "29", month: "apr", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "april/29/2023", range: NSRange(location: 936, length: 13), day: "29", month: "april", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may/29/2023", range: NSRange(location: 950, length: 11), day: "29", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jun/29/2023", range: NSRange(location: 962, length: 11), day: "29", month: "jun", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jul/29/2023", range: NSRange(location: 974, length: 11), day: "29", month: "jul", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "july/29/22", range: NSRange(location: 986, length: 10), day: "29", month: "july", year: "22", formatType: .MDY),
        ExtractedDateResult(original: "aug/29/2023", range: NSRange(location: 997, length: 11), day: "29", month: "aug", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "august/29/17", range: NSRange(location: 1009, length: 12), day: "29", month: "august", year: "17", formatType: .MDY),
        ExtractedDateResult(original: "sep/29/25", range: NSRange(location: 1022, length: 9), day: "29", month: "sep", year: "25", formatType: .MDY),
        ExtractedDateResult(original: "september/29/44", range: NSRange(location: 1032, length: 15), day: "29", month: "september", year: "44", formatType: .MDY),
        ExtractedDateResult(original: "oct/29/20", range: NSRange(location: 1048, length: 9), day: "29", month: "oct", year: "20", formatType: .MDY),
        ExtractedDateResult(original: "october/29/21", range: NSRange(location: 1058, length: 13), day: "29", month: "october", year: "21", formatType: .MDY),
        ExtractedDateResult(original: "nov/29/10", range: NSRange(location: 1072, length: 9), day: "29", month: "nov", year: "10", formatType: .MDY),
        ExtractedDateResult(original: "november/29/90", range: NSRange(location: 1082, length: 14), day: "29", month: "november", year: "90", formatType: .MDY),
        ExtractedDateResult(original: "dec/29/23", range: NSRange(location: 1097, length: 9), day: "29", month: "dec", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "december/29/23", range: NSRange(location: 1107, length: 14), day: "29", month: "december", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "02/29/24", range: NSRange(location: 1122, length: 8), day: "29", month: "02", year: "24", formatType: .MDY),
        ExtractedDateResult(original: "2/29/1600", range: NSRange(location: 1131, length: 9), day: "29", month: "2", year: "1600", formatType: .MDY),
        ExtractedDateResult(original: "feb/29/1648", range: NSRange(location: 1141, length: 11), day: "29", month: "feb", year: "1648", formatType: .MDY),
        ExtractedDateResult(original: "february/29/2012", range: NSRange(location: 1153, length: 16), day: "29", month: "february", year: "2012", formatType: .MDY),
        ExtractedDateResult(original: "09/01/1600", range: NSRange(location: 1170, length: 10), day: "01", month: "09", year: "1600", formatType: .MDY),
        ExtractedDateResult(original: "01/09/1999", range: NSRange(location: 1181, length: 10), day: "09", month: "01", year: "1999", formatType: .MDY),
        ExtractedDateResult(original: "9/1/2000", range: NSRange(location: 1192, length: 8), day: "1", month: "9", year: "2000", formatType: .MDY),
        ExtractedDateResult(original: "1/9/9999", range: NSRange(location: 1201, length: 8), day: "9", month: "1", year: "9999", formatType: .MDY),
        ExtractedDateResult(original: "jan/01/24", range: NSRange(location: 1210, length: 9), day: "01", month: "jan", year: "24", formatType: .MDY),
        ExtractedDateResult(original: "sep/09/12", range: NSRange(location: 1220, length: 9), day: "09", month: "sep", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "oct/1/12", range: NSRange(location: 1230, length: 8), day: "1", month: "oct", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "dec/9/12", range: NSRange(location: 1239, length: 8), day: "9", month: "dec", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "10/1/09", range: NSRange(location: 1248, length: 7), day: "1", month: "10", year: "09", formatType: .MDY),
        ExtractedDateResult(original: "12/1/92", range: NSRange(location: 1256, length: 7), day: "1", month: "12", year: "92", formatType: .MDY),
        ExtractedDateResult(original: "11/01/12", range: NSRange(location: 1264, length: 8), day: "01", month: "11", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "01/10/1699", range: NSRange(location: 1273, length: 10), day: "10", month: "01", year: "1699", formatType: .MDY),
        ExtractedDateResult(original: "09/19/2999", range: NSRange(location: 1284, length: 10), day: "19", month: "09", year: "2999", formatType: .MDY),
        ExtractedDateResult(original: "1/10/9000", range: NSRange(location: 1295, length: 9), day: "10", month: "1", year: "9000", formatType: .MDY),
        ExtractedDateResult(original: "9/19/1800", range: NSRange(location: 1305, length: 9), day: "19", month: "9", year: "1800", formatType: .MDY),
        ExtractedDateResult(original: "jan/10/11", range: NSRange(location: 1315, length: 9), day: "10", month: "jan", year: "11", formatType: .MDY),
        ExtractedDateResult(original: "sep/19/1992", range: NSRange(location: 1325, length: 11), day: "19", month: "sep", year: "1992", formatType: .MDY),
        ExtractedDateResult(original: "nov/10/11", range: NSRange(location: 1337, length: 9), day: "10", month: "nov", year: "11", formatType: .MDY),
        ExtractedDateResult(original: "12/19/1992", range: NSRange(location: 1347, length: 10), day: "19", month: "12", year: "1992", formatType: .MDY),
        ExtractedDateResult(original: "01/20/12", range: NSRange(location: 1358, length: 8), day: "20", month: "01", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "09/28/08", range: NSRange(location: 1367, length: 8), day: "28", month: "09", year: "08", formatType: .MDY),
        ExtractedDateResult(original: "1/21/1902", range: NSRange(location: 1376, length: 9), day: "21", month: "1", year: "1902", formatType: .MDY),
        ExtractedDateResult(original: "9/27/9212", range: NSRange(location: 1386, length: 9), day: "27", month: "9", year: "9212", formatType: .MDY),
        ExtractedDateResult(original: "nov/22/34", range: NSRange(location: 1396, length: 9), day: "22", month: "nov", year: "34", formatType: .MDY),
        ExtractedDateResult(original: "dec/26/6790", range: NSRange(location: 1406, length: 11), day: "26", month: "dec", year: "6790", formatType: .MDY),
        ExtractedDateResult(original: "1/23/23", range: NSRange(location: 1418, length: 7), day: "23", month: "1", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "10/24/1945", range: NSRange(location: 1426, length: 10), day: "24", month: "10", year: "1945", formatType: .MDY),
        ExtractedDateResult(original: "11/25/9009", range: NSRange(location: 1437, length: 10), day: "25", month: "11", year: "9009", formatType: .MDY),
        ExtractedDateResult(original: "JUNE/20/2023", range: NSRange(location: 1449, length: 12), day: "20", month: "JUNE", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "June/23/23", range: NSRange(location: 1462, length: 10), day: "23", month: "June", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "January/24/2022", range: NSRange(location: 1473, length: 15), day: "24", month: "January", year: "2022", formatType: .MDY),
        ExtractedDateResult(original: "dec/31/2023", range: NSRange(location: 1556, length: 11), day: "31", month: "dec", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jan/31/23", range: NSRange(location: 1568, length: 9), day: "31", month: "jan", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "dec/28/2023", range: NSRange(location: 1578, length: 11), day: "28", month: "dec", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may/31/2023", range: NSRange(location: 1590, length: 11), day: "31", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "mar/31/2023", range: NSRange(location: 1602, length: 11), day: "31", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may/31/2023", range: NSRange(location: 1614, length: 11), day: "31", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "mar/31/2023", range: NSRange(location: 1626, length: 11), day: "31", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may/31/05", range: NSRange(location: 1638, length: 9), day: "31", month: "may", year: "05", formatType: .MDY),
        ExtractedDateResult(original: "january/31/31", range: NSRange(location: 1653, length: 13), day: "31", month: "january", year: "31", formatType: .MDY),
        ExtractedDateResult(original: "jan/31/31", range: NSRange(location: 1676, length: 9), day: "31", month: "jan", year: "31", formatType: .MDY),
        ExtractedDateResult(original: "jan/31/23", range: NSRange(location: 1688, length: 9), day: "31", month: "jan", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "may/31/2023", range: NSRange(location: 1698, length: 11), day: "31", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "dec/31/23", range: NSRange(location: 1710, length: 9), day: "31", month: "dec", year: "23", formatType: .MDY)
    ]
    
    let paragraphSpaceFormat = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    jan 31 91 january 31 01 mar 31 2023 March 31 23 may 31 1756 july 31 2023 jul 31 2023 aug 31 2023
    august 31 2023 oct 31 2023 october 31 2023 dec 31 2023 december 31 2023 jan 30 2023 january 30 23
    mar 30 2023 march 30 2023 apr 30 2023 april 30 2023 may 30 2023 jun 30 2023 jul 30 2023 july 30 22
    aug 30 2023 august 30 17 sep 30 25 September 30 44 oct 30 20 october 30 21 nov 30 10 november 30 90
    dec 30 23 december 30 23 jan 29 2023 JANUARY 29 23 mar 29 2023 march 29 2023 Apr 29 2023 april 29 2023
    may 29 2023 jun 29 2023 jul 29 2023 July 29 22 aug 29 2023 august 29 17 sep 29 25 september 29 44 oct 29 20
    october 29 21 nov 29 10 november 29 90 dec 29 23 december 29 23 feb 29 1648 february 29 2012 jan 01 24
    SEP 09 12 oct 1 12 DEC 9 12 jan 10 11 sep 19 1992 nov 10 11 nov 22 34 dec 26 6790 JAN 24 2022
    October 21, 2023 JANUARY 01, 23 July 08, 1920
    """
    
    let expectedResults_SpaceFormat = [
        ExtractedDateResult(original: "jan 31 91", range: NSRange(location: 57, length: 9), day: "31", month: "jan", year: "91", formatType: .MDY),
        ExtractedDateResult(original: "january 31 01", range: NSRange(location: 67, length: 13), day: "31", month: "january", year: "01", formatType: .MDY),
        ExtractedDateResult(original: "mar 31 2023", range: NSRange(location: 81, length: 11), day: "31", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "March 31 23", range: NSRange(location: 93, length: 11), day: "31", month: "March", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "may 31 1756", range: NSRange(location: 105, length: 11), day: "31", month: "may", year: "1756", formatType: .MDY),
        ExtractedDateResult(original: "july 31 2023", range: NSRange(location: 117, length: 12), day: "31", month: "july", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jul 31 2023", range: NSRange(location: 130, length: 11), day: "31", month: "jul", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "aug 31 2023", range: NSRange(location: 142, length: 11), day: "31", month: "aug", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "august 31 2023", range: NSRange(location: 154, length: 14), day: "31", month: "august", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "oct 31 2023", range: NSRange(location: 169, length: 11), day: "31", month: "oct", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "october 31 2023", range: NSRange(location: 181, length: 15), day: "31", month: "october", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "dec 31 2023", range: NSRange(location: 197, length: 11), day: "31", month: "dec", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "december 31 2023", range: NSRange(location: 209, length: 16), day: "31", month: "december", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jan 30 2023", range: NSRange(location: 226, length: 11), day: "30", month: "jan", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "january 30 23", range: NSRange(location: 238, length: 13), day: "30", month: "january", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "mar 30 2023", range: NSRange(location: 252, length: 11), day: "30", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "march 30 2023", range: NSRange(location: 264, length: 13), day: "30", month: "march", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "apr 30 2023", range: NSRange(location: 278, length: 11), day: "30", month: "apr", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "april 30 2023", range: NSRange(location: 290, length: 13), day: "30", month: "april", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may 30 2023", range: NSRange(location: 304, length: 11), day: "30", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jun 30 2023", range: NSRange(location: 316, length: 11), day: "30", month: "jun", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jul 30 2023", range: NSRange(location: 328, length: 11), day: "30", month: "jul", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "july 30 22", range: NSRange(location: 340, length: 10), day: "30", month: "july", year: "22", formatType: .MDY),
        ExtractedDateResult(original: "aug 30 2023", range: NSRange(location: 351, length: 11), day: "30", month: "aug", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "august 30 17", range: NSRange(location: 363, length: 12), day: "30", month: "august", year: "17", formatType: .MDY),
        ExtractedDateResult(original: "sep 30 25", range: NSRange(location: 376, length: 9), day: "30", month: "sep", year: "25", formatType: .MDY),
        ExtractedDateResult(original: "September 30 44", range: NSRange(location: 386, length: 15), day: "30", month: "September", year: "44", formatType: .MDY),
        ExtractedDateResult(original: "oct 30 20", range: NSRange(location: 402, length: 9), day: "30", month: "oct", year: "20", formatType: .MDY),
        ExtractedDateResult(original: "october 30 21", range: NSRange(location: 412, length: 13), day: "30", month: "october", year: "21", formatType: .MDY),
        ExtractedDateResult(original: "nov 30 10", range: NSRange(location: 426, length: 9), day: "30", month: "nov", year: "10", formatType: .MDY),
        ExtractedDateResult(original: "november 30 90", range: NSRange(location: 436, length: 14), day: "30", month: "november", year: "90", formatType: .MDY),
        ExtractedDateResult(original: "dec 30 23", range: NSRange(location: 451, length: 9), day: "30", month: "dec", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "december 30 23", range: NSRange(location: 461, length: 14), day: "30", month: "december", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "jan 29 2023", range: NSRange(location: 476, length: 11), day: "29", month: "jan", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "JANUARY 29 23", range: NSRange(location: 488, length: 13), day: "29", month: "JANUARY", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "mar 29 2023", range: NSRange(location: 502, length: 11), day: "29", month: "mar", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "march 29 2023", range: NSRange(location: 514, length: 13), day: "29", month: "march", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "Apr 29 2023", range: NSRange(location: 528, length: 11), day: "29", month: "Apr", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "april 29 2023", range: NSRange(location: 540, length: 13), day: "29", month: "april", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "may 29 2023", range: NSRange(location: 554, length: 11), day: "29", month: "may", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jun 29 2023", range: NSRange(location: 566, length: 11), day: "29", month: "jun", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "jul 29 2023", range: NSRange(location: 578, length: 11), day: "29", month: "jul", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "July 29 22", range: NSRange(location: 590, length: 10), day: "29", month: "July", year: "22", formatType: .MDY),
        ExtractedDateResult(original: "aug 29 2023", range: NSRange(location: 601, length: 11), day: "29", month: "aug", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "august 29 17", range: NSRange(location: 613, length: 12), day: "29", month: "august", year: "17", formatType: .MDY),
        ExtractedDateResult(original: "sep 29 25", range: NSRange(location: 626, length: 9), day: "29", month: "sep", year: "25", formatType: .MDY),
        ExtractedDateResult(original: "september 29 44", range: NSRange(location: 636, length: 15), day: "29", month: "september", year: "44", formatType: .MDY),
        ExtractedDateResult(original: "oct 29 20", range: NSRange(location: 652, length: 9), day: "29", month: "oct", year: "20", formatType: .MDY),
        ExtractedDateResult(original: "october 29 21", range: NSRange(location: 662, length: 13), day: "29", month: "october", year: "21", formatType: .MDY),
        ExtractedDateResult(original: "nov 29 10", range: NSRange(location: 676, length: 9), day: "29", month: "nov", year: "10", formatType: .MDY),
        ExtractedDateResult(original: "november 29 90", range: NSRange(location: 686, length: 14), day: "29", month: "november", year: "90", formatType: .MDY),
        ExtractedDateResult(original: "dec 29 23", range: NSRange(location: 701, length: 9), day: "29", month: "dec", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "december 29 23", range: NSRange(location: 711, length: 14), day: "29", month: "december", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "feb 29 1648", range: NSRange(location: 726, length: 11), day: "29", month: "feb", year: "1648", formatType: .MDY),
        ExtractedDateResult(original: "february 29 2012", range: NSRange(location: 738, length: 16), day: "29", month: "february", year: "2012", formatType: .MDY),
        ExtractedDateResult(original: "jan 01 24", range: NSRange(location: 755, length: 9), day: "01", month: "jan", year: "24", formatType: .MDY),
        ExtractedDateResult(original: "SEP 09 12", range: NSRange(location: 765, length: 9), day: "09", month: "SEP", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "oct 1 12", range: NSRange(location: 775, length: 8), day: "1", month: "oct", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "DEC 9 12", range: NSRange(location: 784, length: 8), day: "9", month: "DEC", year: "12", formatType: .MDY),
        ExtractedDateResult(original: "jan 10 11", range: NSRange(location: 793, length: 9), day: "10", month: "jan", year: "11", formatType: .MDY),
        ExtractedDateResult(original: "sep 19 1992", range: NSRange(location: 803, length: 11), day: "19", month: "sep", year: "1992", formatType: .MDY),
        ExtractedDateResult(original: "nov 10 11", range: NSRange(location: 815, length: 9), day: "10", month: "nov", year: "11", formatType: .MDY),
        ExtractedDateResult(original: "nov 22 34", range: NSRange(location: 825, length: 9), day: "22", month: "nov", year: "34", formatType: .MDY),
        ExtractedDateResult(original: "dec 26 6790", range: NSRange(location: 835, length: 11), day: "26", month: "dec", year: "6790", formatType: .MDY),
        ExtractedDateResult(original: "JAN 24 2022", range: NSRange(location: 847, length: 11), day: "24", month: "JAN", year: "2022", formatType: .MDY),
        ExtractedDateResult(original: "October 21, 2023", range: NSRange(location: 859, length: 16), day: "21,", month: "October", year: "2023", formatType: .MDY),
        ExtractedDateResult(original: "JANUARY 01, 23", range: NSRange(location: 876, length: 14), day: "01,", month: "JANUARY", year: "23", formatType: .MDY),
        ExtractedDateResult(original: "July 08, 1920", range: NSRange(location: 891, length: 13), day: "08,", month: "July", year: "1920", formatType: .MDY)
    ]
}
