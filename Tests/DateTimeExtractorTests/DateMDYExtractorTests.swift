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
        
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
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
        
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
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
        
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
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
        
        let results = extractor.extractDateStringAndFormat(string: paragraph.lowercased())
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
    dec/26/6790 1/23/23 10/24/1945 11/25/9009
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
        ExtractedDateResult(originalString: "01/31/1600", range: NSMakeRange(114, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "01", yearValue: "1600", formatType: .MDY)),
        ExtractedDateResult(originalString: "03/31/1999", range: NSMakeRange(125, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "03", yearValue: "1999", formatType: .MDY)),
        ExtractedDateResult(originalString: "05/31/2000", range: NSMakeRange(136, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2000", formatType: .MDY)),
        ExtractedDateResult(originalString: "07/31/56", range: NSMakeRange(147, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "07", yearValue: "56", formatType: .MDY)),
        ExtractedDateResult(originalString: "08/31/78", range: NSMakeRange(156, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "08", yearValue: "78", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/31/1999", range: NSMakeRange(165, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "10", yearValue: "1999", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/31/9999", range: NSMakeRange(176, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "12", yearValue: "9999", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/91", range: NSMakeRange(187, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "91", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/31/01", range: NSMakeRange(197, 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "01", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/31/2023", range: NSMakeRange(211, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march/31/23", range: NSMakeRange(224, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "march", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/1756", range: NSMakeRange(236, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "1756", formatType: .MDY)),
        ExtractedDateResult(originalString: "july/31/2023", range: NSMakeRange(248, 12),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "july", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul/31/2023", range: NSMakeRange(261, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug/31/2023", range: NSMakeRange(273, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august/31/2023", range: NSMakeRange(285, 14),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "august", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/31/2023", range: NSMakeRange(300, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "oct", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "october/31/2023", range: NSMakeRange(312, 15),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "october", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/31/2023", range: NSMakeRange(328, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "december/31/2023", range: NSMakeRange(340, 16),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "december", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/31/90", range: NSMakeRange(357, 7),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "1", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "3/31/2993", range: NSMakeRange(365, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "3", yearValue: "2993", formatType: .MDY)),
        ExtractedDateResult(originalString: "5/31/1982", range: NSMakeRange(375, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "5", yearValue: "1982", formatType: .MDY)),
        ExtractedDateResult(originalString: "7/31/1856", range: NSMakeRange(385, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "7", yearValue: "1856", formatType: .MDY)),
        ExtractedDateResult(originalString: "8/31/2378", range: NSMakeRange(395, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "8", yearValue: "2378", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/30/2023", range: NSMakeRange(405, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "01", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "03/30/23", range: NSMakeRange(416, 8),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "03", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/30/1920", range: NSMakeRange(425, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "09", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "05/30/1920", range: NSMakeRange(437, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "05", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/30/22", range: NSMakeRange(448, 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "1", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "3/30/53", range: NSMakeRange(456, 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "3", yearValue: "53", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/30/19", range: NSMakeRange(464, 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "9", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/30/19", range: NSMakeRange(472, 8),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "10", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/30/1909", range: NSMakeRange(481, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "11", yearValue: "1909", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/30/1919", range: NSMakeRange(492, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/30/1919", range: NSMakeRange(503, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/30/2023", range: NSMakeRange(514, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/30/23", range: NSMakeRange(526, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/30/2023", range: NSMakeRange(540, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march/30/2023", range: NSMakeRange(552, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr/30/2023", range: NSMakeRange(566, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april/30/2023", range: NSMakeRange(578, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/30/2023", range: NSMakeRange(592, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun/30/2023", range: NSMakeRange(604, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul/30/2023", range: NSMakeRange(616, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july/30/22", range: NSMakeRange(628, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug/30/2023", range: NSMakeRange(639, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august/30/17", range: NSMakeRange(651, 12),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/30/25", range: NSMakeRange(664, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september/30/44", range: NSMakeRange(674, 15),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/30/20", range: NSMakeRange(690, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october/30/21", range: NSMakeRange(700, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/30/10", range: NSMakeRange(714, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november/30/90", range: NSMakeRange(724, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/30/23", range: NSMakeRange(739, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december/30/23", range: NSMakeRange(749, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/29/2023", range: NSMakeRange(764, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "01", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "03/29/23", range: NSMakeRange(775, 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "03", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/29/1920", range: NSMakeRange(784, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "09", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "05/29/1920", range: NSMakeRange(795, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "05", yearValue: "1920", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/29/22", range: NSMakeRange(806, 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "1", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "3/29/53", range: NSMakeRange(814, 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "3", yearValue: "53", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/29/19", range: NSMakeRange(822, 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "9", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/29/19", range: NSMakeRange(830, 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "10", yearValue: "19", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/29/1909", range: NSMakeRange(839, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "11", yearValue: "1909", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/29/1919", range: NSMakeRange(850, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/29/1919", range: NSMakeRange(861, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "12", yearValue: "1919", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/29/2023", range: NSMakeRange(872, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/29/23", range: NSMakeRange(884, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/29/2023", range: NSMakeRange(898, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march/29/2023", range: NSMakeRange(910, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr/29/2023", range: NSMakeRange(924, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april/29/2023", range: NSMakeRange(936, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/29/2023", range: NSMakeRange(950, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun/29/2023", range: NSMakeRange(962, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul/29/2023", range: NSMakeRange(974, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july/29/22", range: NSMakeRange(986, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug/29/2023", range: NSMakeRange(997, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august/29/17", range: NSMakeRange(1009, 12),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/29/25", range: NSMakeRange(1022, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september/29/44", range: NSMakeRange(1032, 15),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/29/20", range: NSMakeRange(1048, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october/29/21", range: NSMakeRange(1058, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/29/10", range: NSMakeRange(1072, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november/29/90", range: NSMakeRange(1082, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/29/23", range: NSMakeRange(1097, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december/29/23", range: NSMakeRange(1107, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "02/29/24", range: NSMakeRange(1122, 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "02", yearValue: "24", formatType: .MDY)),
        ExtractedDateResult(originalString: "2/29/1600", range: NSMakeRange(1131, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "2", yearValue: "1600", formatType: .MDY)),
        ExtractedDateResult(originalString: "feb/29/1648", range: NSMakeRange(1141, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "feb", yearValue: "1648", formatType: .MDY)),
        ExtractedDateResult(originalString: "february/29/2012", range: NSMakeRange(1153, 16),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2012", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/01/1600", range: NSMakeRange(1170, 10),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "09", yearValue: "1600", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/09/1999", range: NSMakeRange(1181, 10),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "01", yearValue: "1999", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/1/2000", range: NSMakeRange(1192, 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "9", yearValue: "2000", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/9/9999", range: NSMakeRange(1201, 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "1", yearValue: "9999", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/01/24", range: NSMakeRange(1210, 9),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "jan", yearValue: "24", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/09/12", range: NSMakeRange(1220, 9),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "sep", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct/1/12", range: NSMakeRange(1230, 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "oct", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/9/12", range: NSMakeRange(1239, 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "dec", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/1/09", range: NSMakeRange(1248, 7),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "10", yearValue: "09", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/1/92", range: NSMakeRange(1256, 7),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "12", yearValue: "92", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/01/12", range: NSMakeRange(1264, 8),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "11", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/10/1699", range: NSMakeRange(1273, 10),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "01", yearValue: "1699", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/19/2999", range: NSMakeRange(1284, 10),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "09", yearValue: "2999", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/10/9000", range: NSMakeRange(1295, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "1", yearValue: "9000", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/19/1800", range: NSMakeRange(1305, 9),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "9", yearValue: "1800", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/10/11", range: NSMakeRange(1315, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "jan", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep/19/1992", range: NSMakeRange(1325, 11),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "sep", yearValue: "1992", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/10/11", range: NSMakeRange(1337, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "nov", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "12/19/1992", range: NSMakeRange(1347, 10),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "12", yearValue: "1992", formatType: .MDY)),
        ExtractedDateResult(originalString: "01/20/12", range: NSMakeRange(1358, 8),
                            formatComponents: DateFormatComponents(dayValue: "20", monthValue: "01", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "09/28/08", range: NSMakeRange(1367, 8),
                            formatComponents: DateFormatComponents(dayValue: "28", monthValue: "09", yearValue: "08", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/21/1902", range: NSMakeRange(1376, 9),
                            formatComponents: DateFormatComponents(dayValue: "21", monthValue: "1", yearValue: "1902", formatType: .MDY)),
        ExtractedDateResult(originalString: "9/27/9212", range: NSMakeRange(1386, 9),
                            formatComponents: DateFormatComponents(dayValue: "27", monthValue: "9", yearValue: "9212", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov/22/34", range: NSMakeRange(1396, 9),
                            formatComponents: DateFormatComponents(dayValue: "22", monthValue: "nov", yearValue: "34", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/26/6790", range: NSMakeRange(1406, 11),
                            formatComponents: DateFormatComponents(dayValue: "26", monthValue: "dec", yearValue: "6790", formatType: .MDY)),
        ExtractedDateResult(originalString: "1/23/23", range: NSMakeRange(1418, 7),
                            formatComponents: DateFormatComponents(dayValue: "23", monthValue: "1", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "10/24/1945", range: NSMakeRange(1426, 10),
                            formatComponents: DateFormatComponents(dayValue: "24", monthValue: "10", yearValue: "1945", formatType: .MDY)),
        ExtractedDateResult(originalString: "11/25/9009", range: NSMakeRange(1437, 10),
                            formatComponents: DateFormatComponents(dayValue: "25", monthValue: "11", yearValue: "9009", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/31/2023", range: NSMakeRange(1515, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/23", range: NSMakeRange(1527, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/28/2023", range: NSMakeRange(1537, 11),
                            formatComponents: DateFormatComponents(dayValue: "28", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/2023", range: NSMakeRange(1549, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/31/2023", range: NSMakeRange(1561, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/2023", range: NSMakeRange(1573, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar/31/2023", range: NSMakeRange(1585, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/05", range: NSMakeRange(1597, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "05", formatType: .MDY)),
        ExtractedDateResult(originalString: "january/31/31", range: NSMakeRange(1612, 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "31", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/31", range: NSMakeRange(1635, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "31", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan/31/23", range: NSMakeRange(1647, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "may/31/2023", range: NSMakeRange(1657, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec/31/23", range: NSMakeRange(1669, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "23", formatType: .MDY))
    ]
    
    let paragraphSpaceFormat = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    jan 31 91 january 31 01 mar 31 2023 march 31 23 may 31 1756 july 31 2023 jul 31 2023 aug 31 2023 
    august 31 2023 oct 31 2023 october 31 2023 dec 31 2023 december 31 2023 jan 30 2023 january 30 23
    mar 30 2023 march 30 2023 apr 30 2023 april 30 2023 may 30 2023 jun 30 2023 jul 30 2023 july 30 22
    aug 30 2023 august 30 17 sep 30 25 september 30 44 oct 30 20 october 30 21 nov 30 10 november 30 90
    dec 30 23 december 30 23 jan 29 2023 january 29 23 mar 29 2023 march 29 2023 apr 29 2023 april 29 2023
    may 29 2023 jun 29 2023 jul 29 2023 july 29 22 aug 29 2023 august 29 17 sep 29 25 september 29 44 oct 29 20
    october 29 21 nov 29 10 november 29 90 dec 29 23 december 29 23 feb 29 1648 february 29 2012 jan 01 24
    sep 09 12 oct 1 12 dec 9 12 jan 10 11 sep 19 1992 nov 10 11 nov 22 34 dec 26 6790
    """
    
    let expectedResults_SpaceFormat = [
        ExtractedDateResult(originalString: "jan 31 91", range: NSMakeRange(57, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "91", formatType: .MDY)),
        ExtractedDateResult(originalString: "january 31 01", range: NSMakeRange(67, 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "01", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar 31 2023", range: NSMakeRange(81, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march 31 23", range: NSMakeRange(93, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "march", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "may 31 1756", range: NSMakeRange(105, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "1756", formatType: .MDY)),
        ExtractedDateResult(originalString: "july 31 2023", range: NSMakeRange(117, 12),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "july", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul 31 2023", range: NSMakeRange(130, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug 31 2023", range: NSMakeRange(142, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august 31 2023", range: NSMakeRange(155, 14),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "august", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 31 2023", range: NSMakeRange(170, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "oct", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "october 31 2023", range: NSMakeRange(182, 15),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "october", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 31 2023", range: NSMakeRange(198, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "december 31 2023", range: NSMakeRange(210, 16),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "december", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 30 2023", range: NSMakeRange(227, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january 30 23", range: NSMakeRange(239, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar 30 2023", range: NSMakeRange(253, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march 30 2023", range: NSMakeRange(265, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr 30 2023", range: NSMakeRange(279, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april 30 2023", range: NSMakeRange(291, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may 30 2023", range: NSMakeRange(305, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun 30 2023", range: NSMakeRange(317, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul 30 2023", range: NSMakeRange(329, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july 30 22", range: NSMakeRange(341, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug 30 2023", range: NSMakeRange(352, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august 30 17", range: NSMakeRange(364, 12),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 30 25", range: NSMakeRange(377, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september 30 44", range: NSMakeRange(387, 15),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 30 20", range: NSMakeRange(403, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october 30 21", range: NSMakeRange(413, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 30 10", range: NSMakeRange(427, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november 30 90", range: NSMakeRange(437, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 30 23", range: NSMakeRange(452, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december 30 23", range: NSMakeRange(462, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 29 2023", range: NSMakeRange(477, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jan", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "january 29 23", range: NSMakeRange(489, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "january", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "mar 29 2023", range: NSMakeRange(503, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "mar", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "march 29 2023", range: NSMakeRange(515, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "march", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "apr 29 2023", range: NSMakeRange(529, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "apr", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "april 29 2023", range: NSMakeRange(541, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "april", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "may 29 2023", range: NSMakeRange(555, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "may", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jun 29 2023", range: NSMakeRange(567, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jun", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "jul 29 2023", range: NSMakeRange(579, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jul", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "july 29 22", range: NSMakeRange(591, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "july", yearValue: "22", formatType: .MDY)),
        ExtractedDateResult(originalString: "aug 29 2023", range: NSMakeRange(602, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "aug", yearValue: "2023", formatType: .MDY)),
        ExtractedDateResult(originalString: "august 29 17", range: NSMakeRange(614, 12),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "august", yearValue: "17", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 29 25", range: NSMakeRange(627, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "sep", yearValue: "25", formatType: .MDY)),
        ExtractedDateResult(originalString: "september 29 44", range: NSMakeRange(637, 15),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "september", yearValue: "44", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 29 20", range: NSMakeRange(653, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "oct", yearValue: "20", formatType: .MDY)),
        ExtractedDateResult(originalString: "october 29 21", range: NSMakeRange(663, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "october", yearValue: "21", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 29 10", range: NSMakeRange(677, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "nov", yearValue: "10", formatType: .MDY)),
        ExtractedDateResult(originalString: "november 29 90", range: NSMakeRange(687, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "november", yearValue: "90", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 29 23", range: NSMakeRange(702, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "dec", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "december 29 23", range: NSMakeRange(712, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "december", yearValue: "23", formatType: .MDY)),
        ExtractedDateResult(originalString: "feb 29 1648", range: NSMakeRange(727, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "feb", yearValue: "1648", formatType: .MDY)),
        ExtractedDateResult(originalString: "february 29 2012", range: NSMakeRange(739, 16),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2012", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 01 24", range: NSMakeRange(756, 9),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "jan", yearValue: "24", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 09 12", range: NSMakeRange(766, 9),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "sep", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "oct 1 12", range: NSMakeRange(776, 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "oct", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 9 12", range: NSMakeRange(785, 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "dec", yearValue: "12", formatType: .MDY)),
        ExtractedDateResult(originalString: "jan 10 11", range: NSMakeRange(794, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "jan", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "sep 19 1992", range: NSMakeRange(804, 11),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "sep", yearValue: "1992", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 10 11", range: NSMakeRange(816, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "nov", yearValue: "11", formatType: .MDY)),
        ExtractedDateResult(originalString: "nov 22 34", range: NSMakeRange(826, 9),
                            formatComponents: DateFormatComponents(dayValue: "22", monthValue: "nov", yearValue: "34", formatType: .MDY)),
        ExtractedDateResult(originalString: "dec 26 6790", range: NSMakeRange(836, 11),
                            formatComponents: DateFormatComponents(dayValue: "26", monthValue: "dec", yearValue: "6790", formatType: .MDY))
    ]
}
