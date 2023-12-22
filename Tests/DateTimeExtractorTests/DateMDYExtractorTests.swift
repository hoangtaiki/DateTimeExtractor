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
        ExtractedDateResult(originalString: "01/31/1600", range: NSRange(location: 114, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "01", yearValue: "1600", formatType: .MDY)),
        ExtractedDateResult(originalString: "03/31/1999", range: NSRange(location: 125, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "03", yearValue: "1999", formatType: .MDY)),
        ExtractedDateResult(originalString: "05/31/2000", range: NSRange(location: 136, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2000", formatType: .MDY)),
        ExtractedDateResult(originalString: "07/31/56", range: NSRange(location: 147, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "07", yearValue: "56", formatType: .MDY)),
        ExtractedDateResult(originalString: "08/31/78", range: NSRange(location: 156, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "08", yearValue: "78", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/31/1999", range: NSRange(location: 165, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "10", yearValue: "1999", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/31/9999", range: NSRange(location: 176, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "12", yearValue: "9999", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/91", range: NSRange(location: 187, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "91", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/31/01", range: NSRange(location: 197, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "01", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/31/2023", range: NSRange(location: 211, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march/31/23", range: NSRange(location: 224, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "march", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/1756", range: NSRange(location: 236, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "1756", formatType: .MDY)),
        ExtractedDateResult(originalString: "july/31/2023", range: NSRange(location: 248, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "july", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul/31/2023", range: NSRange(location: 261, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug/31/2023", range: NSRange(location: 273, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august/31/2023", range: NSRange(location: 285, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "august", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/31/2023", range: NSRange(location: 300, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "oct", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "october/31/2023", range: NSRange(location: 312, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "october", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/31/2023", range: NSRange(location: 328, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "december/31/2023", range: NSRange(location: 340, length: 16),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "december", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/31/90", range: NSRange(location: 357, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "1", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "3/31/2993", range: NSRange(location: 365, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "3", yearValue: "2993", formatType: .MDY)),
        ExtractedDateResult(originalString: "5/31/1982", range: NSRange(location: 375, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "5", yearValue: "1982", formatType: .MDY)),
        ExtractedDateResult(originalString: "7/31/1856", range: NSRange(location: 385, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "7", yearValue: "1856", formatType: .MDY)),
        ExtractedDateResult(originalString: "8/31/2378", range: NSRange(location: 395, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "8", yearValue: "2378", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/30/2023", range: NSRange(location: 405, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "01", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "03/30/23", range: NSRange(location: 416, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "03", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/30/1920", range: NSRange(location: 425, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "09", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "05/30/1920", range: NSRange(location: 437, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "05", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/30/22", range: NSRange(location: 448, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "1", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "3/30/53", range: NSRange(location: 456, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "3", yearValue: "53", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/30/19", range: NSRange(location: 464, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "9", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/30/19", range: NSRange(location: 472, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "10", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/30/1909", range: NSRange(location: 481, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "11", yearValue: "1909", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/30/1919", range: NSRange(location: 492, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/30/1919", range: NSRange(location: 503, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/30/2023", range: NSRange(location: 514, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/30/23", range: NSRange(location: 526, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/30/2023", range: NSRange(location: 540, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march/30/2023", range: NSRange(location: 552, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr/30/2023", range: NSRange(location: 566, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april/30/2023", range: NSRange(location: 578, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/30/2023", range: NSRange(location: 592, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun/30/2023", range: NSRange(location: 604, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul/30/2023", range: NSRange(location: 616, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july/30/22", range: NSRange(location: 628, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug/30/2023", range: NSRange(location: 639, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august/30/17", range: NSRange(location: 651, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/30/25", range: NSRange(location: 664, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september/30/44", range: NSRange(location: 674, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/30/20", range: NSRange(location: 690, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october/30/21", range: NSRange(location: 700, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/30/10", range: NSRange(location: 714, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november/30/90", range: NSRange(location: 724, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/30/23", range: NSRange(location: 739, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december/30/23", range: NSRange(location: 749, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/29/2023", range: NSRange(location: 764, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "01", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "03/29/23", range: NSRange(location: 775, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "03", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/29/1920", range: NSRange(location: 784, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "09", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "05/29/1920", range: NSRange(location: 795, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "05", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/29/22", range: NSRange(location: 806, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "1", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "3/29/53", range: NSRange(location: 814, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "3", yearValue: "53", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/29/19", range: NSRange(location: 822, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "9", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/29/19", range: NSRange(location: 830, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "10", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/29/1909", range: NSRange(location: 839, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "11", yearValue: "1909", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/29/1919", range: NSRange(location: 850, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/29/1919", range: NSRange(location: 861, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/29/2023", range: NSRange(location: 872, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/29/23", range: NSRange(location: 884, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/29/2023", range: NSRange(location: 898, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march/29/2023", range: NSRange(location: 910, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr/29/2023", range: NSRange(location: 924, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april/29/2023", range: NSRange(location: 936, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/29/2023", range: NSRange(location: 950, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun/29/2023", range: NSRange(location: 962, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul/29/2023", range: NSRange(location: 974, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july/29/22", range: NSRange(location: 986, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug/29/2023", range: NSRange(location: 997, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august/29/17", range: NSRange(location: 1009, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/29/25", range: NSRange(location: 1022, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september/29/44", range: NSRange(location: 1032, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/29/20", range: NSRange(location: 1048, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october/29/21", range: NSRange(location: 1058, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/29/10", range: NSRange(location: 1072, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november/29/90", range: NSRange(location: 1082, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/29/23", range: NSRange(location: 1097, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december/29/23", range: NSRange(location: 1107, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "02/29/24", range: NSRange(location: 1122, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "02", yearValue: "24", formatType: .MDY)),
        ExtractedDateResult(originalString: "2/29/1600", range: NSRange(location: 1131, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "2", yearValue: "1600", formatType: .MDY)),
        ExtractedDateResult(originalString: "feb/29/1648", range: NSRange(location: 1141, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "feb", yearValue: "1648", formatType: .MDY)),
        ExtractedDateResult(originalString: "february/29/2012", range: NSRange(location: 1153, length: 16),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2012", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/01/1600", range: NSRange(location: 1170, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "09", yearValue: "1600", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/09/1999", range: NSRange(location: 1181, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "01", yearValue: "1999", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/1/2000", range: NSRange(location: 1192, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "9", yearValue: "2000", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/9/9999", range: NSRange(location: 1201, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "1", yearValue: "9999", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/01/24", range: NSRange(location: 1210, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "jan", yearValue: "24", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/09/12", range: NSRange(location: 1220, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "sep", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/1/12", range: NSRange(location: 1230, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "oct", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/9/12", range: NSRange(location: 1239, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "dec", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/1/09", range: NSRange(location: 1248, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "10", yearValue: "09", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/1/92", range: NSRange(location: 1256, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "12", yearValue: "92", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/01/12", range: NSRange(location: 1264, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "11", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/10/1699", range: NSRange(location: 1273, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "01", yearValue: "1699", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/19/2999", range: NSRange(location: 1284, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "09", yearValue: "2999", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/10/9000", range: NSRange(location: 1295, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "1", yearValue: "9000", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/19/1800", range: NSRange(location: 1305, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "9", yearValue: "1800", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/10/11", range: NSRange(location: 1315, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "jan", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/19/1992", range: NSRange(location: 1325, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "sep", yearValue: "1992", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/10/11", range: NSRange(location: 1337, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "nov", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/19/1992", range: NSRange(location: 1347, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "12", yearValue: "1992", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/20/12", range: NSRange(location: 1358, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "20", monthValue: "01", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/28/08", range: NSRange(location: 1367, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "28", monthValue: "09", yearValue: "08", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/21/1902", range: NSRange(location: 1376, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "21", monthValue: "1", yearValue: "1902", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/27/9212", range: NSRange(location: 1386, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "27", monthValue: "9", yearValue: "9212", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/22/34", range: NSRange(location: 1396, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "22", monthValue: "nov", yearValue: "34", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/26/6790", range: NSRange(location: 1406, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "26", monthValue: "dec", yearValue: "6790", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/23/23", range: NSRange(location: 1418, length: 7),
                            formatComponents: DateFormatComponents(dayValue: "23", monthValue: "1", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/24/1945", range: NSRange(location: 1426, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "24", monthValue: "10", yearValue: "1945", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/25/9009", range: NSRange(location: 1437, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "25", monthValue: "11", yearValue: "9009", formatType: .MDY)),
        ExtractedDateResult(originalString: "JUNE/20/2023", range: NSRange(location: 1449, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "20", monthValue: "JUNE", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "June/23/23", range: NSRange(location: 1462, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "23", monthValue: "June", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "January/24/2022", range: NSRange(location: 1473, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "24", monthValue: "January", yearValue: "2022", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/31/2023", range: NSRange(location: 1556, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/23", range: NSRange(location: 1568, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/28/2023", range: NSRange(location: 1578, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "28", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/2023", range: NSRange(location: 1590, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/31/2023", range: NSRange(location: 1602, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/2023", range: NSRange(location: 1614, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/31/2023", range: NSRange(location: 1626, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/05", range: NSRange(location: 1638, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "05", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/31/31", range: NSRange(location: 1653, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "31", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/31", range: NSRange(location: 1676, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "31", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/23", range: NSRange(location: 1688, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/2023", range: NSRange(location: 1698, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/31/23", range: NSRange(location: 1710, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "23", formatType: .MDY))
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
    """
    
    let expectedResults_SpaceFormat = [
        ExtractedDateResult(originalString: "jan 31 91", range: NSRange(location: 57, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "91", formatType: .MDY)),
        ExtractedDateResult(originalString: "january 31 01", range: NSRange(location: 67, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "01", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar 31 2023", range: NSRange(location: 81, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "March 31 23", range: NSRange(location: 93, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "March", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "may 31 1756", range: NSRange(location: 105, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "1756", formatType: .MDY)),
        ExtractedDateResult(originalString: "july 31 2023", range: NSRange(location: 117, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "july", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul 31 2023", range: NSRange(location: 130, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug 31 2023", range: NSRange(location: 142, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august 31 2023", range: NSRange(location: 154, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "august", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 31 2023", range: NSRange(location: 169, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "oct", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "october 31 2023", range: NSRange(location: 181, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "october", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 31 2023", range: NSRange(location: 197, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "december 31 2023", range: NSRange(location: 209, length: 16),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "december", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 30 2023", range: NSRange(location: 226, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january 30 23", range: NSRange(location: 238, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar 30 2023", range: NSRange(location: 252, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march 30 2023", range: NSRange(location: 264, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr 30 2023", range: NSRange(location: 278, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april 30 2023", range: NSRange(location: 290, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may 30 2023", range: NSRange(location: 304, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun 30 2023", range: NSRange(location: 316, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul 30 2023", range: NSRange(location: 328, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july 30 22", range: NSRange(location: 340, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug 30 2023", range: NSRange(location: 351, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august 30 17", range: NSRange(location: 363, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 30 25", range: NSRange(location: 376, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "September 30 44", range: NSRange(location: 386, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "September", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 30 20", range: NSRange(location: 402, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october 30 21", range: NSRange(location: 412, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 30 10", range: NSRange(location: 426, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november 30 90", range: NSRange(location: 436, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 30 23", range: NSRange(location: 451, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december 30 23", range: NSRange(location: 461, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 29 2023", range: NSRange(location: 476, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "JANUARY 29 23", range: NSRange(location: 488, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "JANUARY", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar 29 2023", range: NSRange(location: 502, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march 29 2023", range: NSRange(location: 514, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "Apr 29 2023", range: NSRange(location: 528, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "Apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april 29 2023", range: NSRange(location: 540, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may 29 2023", range: NSRange(location: 554, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun 29 2023", range: NSRange(location: 566, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul 29 2023", range: NSRange(location: 578, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "July 29 22", range: NSRange(location: 590, length: 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "July", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug 29 2023", range: NSRange(location: 601, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august 29 17", range: NSRange(location: 613, length: 12),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 29 25", range: NSRange(location: 626, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september 29 44", range: NSRange(location: 636, length: 15),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 29 20", range: NSRange(location: 652, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october 29 21", range: NSRange(location: 662, length: 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 29 10", range: NSRange(location: 676, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november 29 90", range: NSRange(location: 686, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 29 23", range: NSRange(location: 701, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december 29 23", range: NSRange(location: 711, length: 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "feb 29 1648", range: NSRange(location: 726, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "feb", yearValue: "1648", formatType: .MDY)),
        ExtractedDateResult(originalString: "february 29 2012", range: NSRange(location: 738, length: 16),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2012", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 01 24", range: NSRange(location: 755, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "jan", yearValue: "24", formatType: .MDY)),
        ExtractedDateResult(originalString: "SEP 09 12", range: NSRange(location: 765, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "SEP", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 1 12", range: NSRange(location: 775, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "oct", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "DEC 9 12", range: NSRange(location: 784, length: 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "DEC", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 10 11", range: NSRange(location: 793, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "jan", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 19 1992", range: NSRange(location: 803, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "sep", yearValue: "1992", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 10 11", range: NSRange(location: 815, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "nov", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 22 34", range: NSRange(location: 825, length: 9),
                            formatComponents: DateFormatComponents(dayValue: "22", monthValue: "nov", yearValue: "34", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 26 6790", range: NSRange(location: 835, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "26", monthValue: "dec", yearValue: "6790", formatType: .MDY)),
        ExtractedDateResult(originalString: "JAN 24 2022", range: NSRange(location: 847, length: 11),
                            formatComponents: DateFormatComponents(dayValue: "24", monthValue: "JAN", yearValue: "2022", formatType: .MDY))
    ]
}
