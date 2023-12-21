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

    func test_InvalidDate_ShouldNot_Recognize() {
        let dateStrings = [
            // Slash
            "32/12/23", "32/12/2023", "00/12/23", "0/12/2023", "01/01/1599", "28/2/10001",
            "32/jan/23", "0/november/2023", "00/dec/23", "01/december/20234", "301/1/1923",
            "d31/12/2023", "31/12/2023d", "31/12/23d", "invalidecember/31/2023", "01/1/223",
            // Dot
            "32.12.23", "32.12.2023", "00.12.23", "0.12.2023", "01.01.1599", "28.2.10001",
            "32.jan.23", "0.november.2023", "00.dec.23", "01.december.20234", "301.1.1923",
            "d31.12.2023", "31.12.2023d", "31.12.23d", "invalidecember.31.2023", "01.1.223",
            // Hyphen
            "32-12-23", "32-12-2023", "00-12-23", "0-12-2023", "01-01-1599", "28-2-10001",
            "32-jan-23", "0-november-2023", "00-dec-23", "01-december-20234", "301-1-1923",
            "d31-12-2023", "31-12-2023d", "31-12-23d", "invalidecember-31-2023", "01-1-223",
            // Space
            "32 12 23", "32 12 2023", "00 12 23", "0 12 2023", "01 01 1599", "28 2 10001",
            "32 jan 23", "0 november 2023", "00 dec 23", "01 december 20234", "301 1 1923",
            "d31 12 2023", "31 12 2023d", "31 12 23d", "invalidecember 31 2023", "01 1 223",
            // Mixing
            "31/12.23", "01/02 1992", "28/2-1898", "1.5/12", "30.oct 1782", "28.feb-2024",
            "02-may/13", "30-september.1990", "10-02 23", "01 01 23", "31 12 2023",
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }
    
    func test_InvalidDate_DayMonthYear_ShouldNot_Recognize() {
        let dateStrings = [
            // Slash
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
    31/01/1600 31/03/1999 31/05/2000 31/07/56 31/08/78
    31/10/1999 31/12/9999 31/jan/91 31/january/01 31/mar/2023
    31/march/23 31/may/1756 31/july/2023 31/jul/2023 31/aug/2023
    31/august/2023 31/oct/2023 31/october/2023 31/dec/2023 31/december/2023
    31/1/90 31/3/2993 31/5/1982 31/7/1856 31/8/2378
    30/01/2023 30/03/23 30/09/1920 30/05/1920 30/1/22
    30/3/53 30/9/19 30/10/19 30/11/1909 30/12/1919
    30/12/1919 30/jan/2023 30/january/23 30/mar/2023 30/march/2023
    30/apr/2023 30/april/2023 30/may/2023 30/jun/2023 30/jul/2023
    30/july/22 30/aug/2023 30/august/17 30/sep/25 30/september/44
    30/oct/20 30/october/21 30/nov/10 30/november/90 30/dec/23 30/december/23
    29/01/2023 29/03/23 29/09/1920 29/05/1920 29/1/22
    29/3/53 29/9/19 29/10/19 29/11/1909 29/12/1919
    29/12/1919 29/jan/2023 29/january/23 29/mar/2023 29/march/2023
    29/apr/2023 29/april/2023 29/may/2023 29/jun/2023 29/jul/2023
    29/july/22 29/aug/2023 29/august/17 29/sep/25 29/september/44
    29/oct/20 29/october/21 29/nov/10 29/november/90 29/dec/23 29/december/23
    29/02/24 29/2/1600 29/feb/1648 29/february/2012
    01/09/1600 09/01/1999 1/9/2000 9/1/9999 01/jan/24 09/sep/12
    1/oct/12 9/dec/12 1/10/09 1/12/92 01/11/12
    10/01/1699 19/09/2999 10/1/9000 19/9/1800 10/jan/11 19/sep/1992
    10/nov/11 19/12/1992 20/01/12 28/09/08 21/1/1902 27/9/9212
    22/nov/34 26/dec/6790 23/1/23 24/10/1945 25/11/9009
    2. But some dates with sepecial characters still can be recognized
    31/12/2023 31/01/23
    28/dec/2023/31/05/2023
    31/03/2023/31/05/2023
    31/03/2023+31/05/2023
    31/1/31/05/2023
    31/01/31/0
    31/1/23/31/05/2023
    31/12/23/
    """
    
    let expectedResults_SlashFormat = [
        ExtractedDateResult(originalString: "31/01/1600", range: NSMakeRange(113, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "01", yearValue: "1600", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/03/1999", range: NSMakeRange(124, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "03", yearValue: "1999", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/05/2000", range: NSMakeRange(135, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2000", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/07/56", range: NSMakeRange(146, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "07", yearValue: "56", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/08/78", range: NSMakeRange(155, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "08", yearValue: "78", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/10/1999", range: NSMakeRange(164, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "10", yearValue: "1999", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/12/9999", range: NSMakeRange(175, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "12", yearValue: "9999", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/jan/91", range: NSMakeRange(186, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "91", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/january/01", range: NSMakeRange(196, 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "01", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/mar/2023", range: NSMakeRange(210, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/march/23", range: NSMakeRange(222, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "march", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/may/1756", range: NSMakeRange(234, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "1756", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/july/2023", range: NSMakeRange(246, 12),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "july", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/jul/2023", range: NSMakeRange(259, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jul", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/aug/2023", range: NSMakeRange(271, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "aug", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/august/2023", range: NSMakeRange(283, 14),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "august", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/oct/2023", range: NSMakeRange(298, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "oct", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/october/2023", range: NSMakeRange(310, 15),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "october", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/dec/2023", range: NSMakeRange(326, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/december/2023", range: NSMakeRange(338, 16),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "december", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/1/90", range: NSMakeRange(355, 7),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "1", yearValue: "90", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/3/2993", range: NSMakeRange(363, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "3", yearValue: "2993", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/5/1982", range: NSMakeRange(373, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "5", yearValue: "1982", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/7/1856", range: NSMakeRange(383, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "7", yearValue: "1856", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/8/2378", range: NSMakeRange(393, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "8", yearValue: "2378", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/01/2023", range: NSMakeRange(403, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "01", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/03/23", range: NSMakeRange(414, 8),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "03", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/09/1920", range: NSMakeRange(423, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "09", yearValue: "1920", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/05/1920", range: NSMakeRange(434, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "05", yearValue: "1920", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/1/22", range: NSMakeRange(445, 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "1", yearValue: "22", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/3/53", range: NSMakeRange(453, 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "3", yearValue: "53", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/9/19", range: NSMakeRange(461, 7),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "9", yearValue: "19", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/10/19", range: NSMakeRange(469, 8),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "10", yearValue: "19", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/11/1909", range: NSMakeRange(478, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "11", yearValue: "1909", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/12/1919", range: NSMakeRange(489, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "12", yearValue: "1919", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/12/1919", range: NSMakeRange(500, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "12", yearValue: "1919", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/jan/2023", range: NSMakeRange(511, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jan", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/january/23", range: NSMakeRange(523, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "january", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/mar/2023", range: NSMakeRange(537, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "mar", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/march/2023", range: NSMakeRange(549, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "march", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/apr/2023", range: NSMakeRange(563, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "apr", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/april/2023", range: NSMakeRange(575, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "april", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/may/2023", range: NSMakeRange(589, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "may", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/jun/2023", range: NSMakeRange(601, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jun", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/jul/2023", range: NSMakeRange(613, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jul", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/july/22", range: NSMakeRange(625, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "july", yearValue: "22", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/aug/2023", range: NSMakeRange(636, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "aug", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/august/17", range: NSMakeRange(648, 12),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "august", yearValue: "17", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/sep/25", range: NSMakeRange(661, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "sep", yearValue: "25", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/september/44", range: NSMakeRange(671, 15),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "september", yearValue: "44", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/oct/20", range: NSMakeRange(687, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "oct", yearValue: "20", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/october/21", range: NSMakeRange(697, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "october", yearValue: "21", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/nov/10", range: NSMakeRange(711, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "nov", yearValue: "10", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/november/90", range: NSMakeRange(721, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "november", yearValue: "90", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/dec/23", range: NSMakeRange(736, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "dec", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "30/december/23", range: NSMakeRange(746, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "december", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/01/2023", range: NSMakeRange(761, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "01", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/03/23", range: NSMakeRange(772, 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "03", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/09/1920", range: NSMakeRange(781, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "09", yearValue: "1920", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/05/1920", range: NSMakeRange(792, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "05", yearValue: "1920", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/1/22", range: NSMakeRange(803, 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "1", yearValue: "22", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/3/53", range: NSMakeRange(811, 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "3", yearValue: "53", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/9/19", range: NSMakeRange(819, 7),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "9", yearValue: "19", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/10/19", range: NSMakeRange(827, 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "10", yearValue: "19", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/11/1909", range: NSMakeRange(836, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "11", yearValue: "1909", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/12/1919", range: NSMakeRange(847, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "12", yearValue: "1919", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/12/1919", range: NSMakeRange(858, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "12", yearValue: "1919", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/jan/2023", range: NSMakeRange(869, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jan", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/january/23", range: NSMakeRange(881, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "january", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/mar/2023", range: NSMakeRange(895, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "mar", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/march/2023", range: NSMakeRange(907, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "march", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/apr/2023", range: NSMakeRange(921, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "apr", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/april/2023", range: NSMakeRange(933, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "april", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/may/2023", range: NSMakeRange(947, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "may", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/jun/2023", range: NSMakeRange(959, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jun", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/jul/2023", range: NSMakeRange(971, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jul", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/july/22", range: NSMakeRange(983, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "july", yearValue: "22", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/aug/2023", range: NSMakeRange(994, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "aug", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/august/17", range: NSMakeRange(1006, 12),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "august", yearValue: "17", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/sep/25", range: NSMakeRange(1019, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "sep", yearValue: "25", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/september/44", range: NSMakeRange(1029, 15),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "september", yearValue: "44", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/oct/20", range: NSMakeRange(1045, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "oct", yearValue: "20", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/october/21", range: NSMakeRange(1055, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "october", yearValue: "21", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/nov/10", range: NSMakeRange(1069, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "nov", yearValue: "10", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/november/90", range: NSMakeRange(1079, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "november", yearValue: "90", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/dec/23", range: NSMakeRange(1094, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "dec", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/december/23", range: NSMakeRange(1104, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "december", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/02/24", range: NSMakeRange(1119, 8),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "02", yearValue: "24", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/2/1600", range: NSMakeRange(1128, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "2", yearValue: "1600", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/feb/1648", range: NSMakeRange(1138, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "feb", yearValue: "1648", formatType: .DMY)),
        ExtractedDateResult(originalString: "29/february/2012", range: NSMakeRange(1150, 16),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2012", formatType: .DMY)),
        ExtractedDateResult(originalString: "01/09/1600", range: NSMakeRange(1167, 10),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "09", yearValue: "1600", formatType: .DMY)),
        ExtractedDateResult(originalString: "09/01/1999", range: NSMakeRange(1178, 10),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "01", yearValue: "1999", formatType: .DMY)),
        ExtractedDateResult(originalString: "1/9/2000", range: NSMakeRange(1189, 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "9", yearValue: "2000", formatType: .DMY)),
        ExtractedDateResult(originalString: "9/1/9999", range: NSMakeRange(1198, 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "1", yearValue: "9999", formatType: .DMY)),
        ExtractedDateResult(originalString: "01/jan/24", range: NSMakeRange(1207, 9),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "jan", yearValue: "24", formatType: .DMY)),
        ExtractedDateResult(originalString: "09/sep/12", range: NSMakeRange(1217, 9),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "sep", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "1/oct/12", range: NSMakeRange(1227, 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "oct", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "9/dec/12", range: NSMakeRange(1236, 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "dec", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "1/10/09", range: NSMakeRange(1245, 7),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "10", yearValue: "09", formatType: .DMY)),
        ExtractedDateResult(originalString: "1/12/92", range: NSMakeRange(1253, 7),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "12", yearValue: "92", formatType: .DMY)),
        ExtractedDateResult(originalString: "01/11/12", range: NSMakeRange(1261, 8),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "11", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "10/01/1699", range: NSMakeRange(1270, 10),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "01", yearValue: "1699", formatType: .DMY)),
        ExtractedDateResult(originalString: "19/09/2999", range: NSMakeRange(1281, 10),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "09", yearValue: "2999", formatType: .DMY)),
        ExtractedDateResult(originalString: "10/1/9000", range: NSMakeRange(1292, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "1", yearValue: "9000", formatType: .DMY)),
        ExtractedDateResult(originalString: "19/9/1800", range: NSMakeRange(1302, 9),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "9", yearValue: "1800", formatType: .DMY)),
        ExtractedDateResult(originalString: "10/jan/11", range: NSMakeRange(1312, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "jan", yearValue: "11", formatType: .DMY)),
        ExtractedDateResult(originalString: "19/sep/1992", range: NSMakeRange(1322, 11),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "sep", yearValue: "1992", formatType: .DMY)),
        ExtractedDateResult(originalString: "10/nov/11", range: NSMakeRange(1334, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "nov", yearValue: "11", formatType: .DMY)),
        ExtractedDateResult(originalString: "19/12/1992", range: NSMakeRange(1344, 10),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "12", yearValue: "1992", formatType: .DMY)),
        ExtractedDateResult(originalString: "20/01/12", range: NSMakeRange(1355, 8),
                            formatComponents: DateFormatComponents(dayValue: "20", monthValue: "01", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "28/09/08", range: NSMakeRange(1364, 8),
                            formatComponents: DateFormatComponents(dayValue: "28", monthValue: "09", yearValue: "08", formatType: .DMY)),
        ExtractedDateResult(originalString: "21/1/1902", range: NSMakeRange(1373, 9),
                            formatComponents: DateFormatComponents(dayValue: "21", monthValue: "1", yearValue: "1902", formatType: .DMY)),
        ExtractedDateResult(originalString: "27/9/9212", range: NSMakeRange(1383, 9),
                            formatComponents: DateFormatComponents(dayValue: "27", monthValue: "9", yearValue: "9212", formatType: .DMY)),
        ExtractedDateResult(originalString: "22/nov/34", range: NSMakeRange(1393, 9),
                            formatComponents: DateFormatComponents(dayValue: "22", monthValue: "nov", yearValue: "34", formatType: .DMY)),
        ExtractedDateResult(originalString: "26/dec/6790", range: NSMakeRange(1403, 11),
                            formatComponents: DateFormatComponents(dayValue: "26", monthValue: "dec", yearValue: "6790", formatType: .DMY)),
        ExtractedDateResult(originalString: "23/1/23", range: NSMakeRange(1415, 7),
                            formatComponents: DateFormatComponents(dayValue: "23", monthValue: "1", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "24/10/1945", range: NSMakeRange(1423, 10),
                            formatComponents: DateFormatComponents(dayValue: "24", monthValue: "10", yearValue: "1945", formatType: .DMY)),
        ExtractedDateResult(originalString: "25/11/9009", range: NSMakeRange(1434, 10),
                            formatComponents: DateFormatComponents(dayValue: "25", monthValue: "11", yearValue: "9009", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/12/2023", range: NSMakeRange(1512, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "12", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/01/23", range: NSMakeRange(1523, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "01", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "28/dec/2023", range: NSMakeRange(1532, 11),
                            formatComponents: DateFormatComponents(dayValue: "28", monthValue: "dec", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/05/2023", range: NSMakeRange(1544, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/03/2023", range: NSMakeRange(1555, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "03", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/05/2023", range: NSMakeRange(1566, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/03/2023", range: NSMakeRange(1577, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "03", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/05/2023", range: NSMakeRange(1588, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/1/31", range: NSMakeRange(1599, 7),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "1", yearValue: "31", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/01/31", range: NSMakeRange(1615, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "01", yearValue: "31", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/1/23", range: NSMakeRange(1626, 7),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "1", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/05/2023", range: NSMakeRange(1634, 10),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "05", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31/12/23", range: NSMakeRange(1645, 8),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "12", yearValue: "23", formatType: .DMY))
    ]
    
    let paragraphSpaceFormat = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    31 Jan 91 31 January 01 31 Mar 2023 31 March 23 31 May 1756 31 July 2023 31 Jul 2023 31 Aug 2023 31 August 2023 
    31 Oct 2023 31 October 2023 31 Dec 2023 31 December 2023 30 Jan 2023 30 January 23 30 Mar 2023 30 March 2023 
    30 Apr 2023 30 April 2023 30 May 2023 30 Jun 2023 30 Jul 2023 30 July 22 30 Aug 2023 30 August 17 30 Sep 25
    30 September 44 30 Oct 20 30 October 21 30 Nov 10 30 November 90 30 Dec 23 30 December 23 29 Jan 2023
    29 January 23 29 Mar 2023 29 March 2023 29 Apr 2023 29 April 2023 29 May 2023 29 Jun 2023 29 Jul 2023
    29 July 22 29 Aug 2023 29 August 17 29 Sep 25 29 September 44 29 Oct 20 29 October 21 29 Nov 10
    29 November 90 29 Dec 23 29 December 23 29 Feb 1648 29 February 2012 01 Jan 24 09 Sep 12
    1 Oct 12 9 Dec 12 10 Jan 11 19 Sep 1992 10 Nov 11 22 Nov 34 26 Dec 6790
    """
    
    let expectedResults_SpaceFormat = [
        ExtractedDateResult(originalString: "31 jan 91", range: NSMakeRange(57, 9),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jan", yearValue: "91", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 january 01", range: NSMakeRange(67, 13),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "january", yearValue: "01", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 mar 2023", range: NSMakeRange(81, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "mar", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 march 23", range: NSMakeRange(93, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "march", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 may 1756", range: NSMakeRange(105, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "may", yearValue: "1756", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 july 2023", range: NSMakeRange(117, 12),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "july", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 jul 2023", range: NSMakeRange(130, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "jul", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 aug 2023", range: NSMakeRange(142, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "aug", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 august 2023", range: NSMakeRange(154, 14),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "august", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 oct 2023", range: NSMakeRange(170, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "oct", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 october 2023", range: NSMakeRange(182, 15),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "october", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 dec 2023", range: NSMakeRange(198, 11),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "dec", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "31 december 2023", range: NSMakeRange(210, 16),
                            formatComponents: DateFormatComponents(dayValue: "31", monthValue: "december", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 jan 2023", range: NSMakeRange(227, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jan", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 january 23", range: NSMakeRange(239, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "january", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 mar 2023", range: NSMakeRange(253, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "mar", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 march 2023", range: NSMakeRange(265, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "march", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 apr 2023", range: NSMakeRange(280, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "apr", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 april 2023", range: NSMakeRange(292, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "april", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 may 2023", range: NSMakeRange(306, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "may", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 jun 2023", range: NSMakeRange(318, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jun", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 jul 2023", range: NSMakeRange(330, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "jul", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 july 22", range: NSMakeRange(342, 10),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "july", yearValue: "22", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 aug 2023", range: NSMakeRange(353, 11),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "aug", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 august 17", range: NSMakeRange(365, 12),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "august", yearValue: "17", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 sep 25", range: NSMakeRange(378, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "sep", yearValue: "25", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 september 44", range: NSMakeRange(388, 15),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "september", yearValue: "44", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 oct 20", range: NSMakeRange(404, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "oct", yearValue: "20", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 october 21", range: NSMakeRange(414, 13),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "october", yearValue: "21", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 nov 10", range: NSMakeRange(428, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "nov", yearValue: "10", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 november 90", range: NSMakeRange(438, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "november", yearValue: "90", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 dec 23", range: NSMakeRange(453, 9),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "dec", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "30 december 23", range: NSMakeRange(463, 14),
                            formatComponents: DateFormatComponents(dayValue: "30", monthValue: "december", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 jan 2023", range: NSMakeRange(478, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jan", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 january 23", range: NSMakeRange(490, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "january", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 mar 2023", range: NSMakeRange(504, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "mar", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 march 2023", range: NSMakeRange(516, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "march", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 apr 2023", range: NSMakeRange(530, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "apr", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 april 2023", range: NSMakeRange(542, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "april", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 may 2023", range: NSMakeRange(556, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "may", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 jun 2023", range: NSMakeRange(568, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jun", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 jul 2023", range: NSMakeRange(580, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "jul", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 july 22", range: NSMakeRange(592, 10),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "july", yearValue: "22", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 aug 2023", range: NSMakeRange(603, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "aug", yearValue: "2023", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 august 17", range: NSMakeRange(615, 12),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "august", yearValue: "17", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 sep 25", range: NSMakeRange(628, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "sep", yearValue: "25", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 september 44", range: NSMakeRange(638, 15),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "september", yearValue: "44", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 oct 20", range: NSMakeRange(654, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "oct", yearValue: "20", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 october 21", range: NSMakeRange(664, 13),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "october", yearValue: "21", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 nov 10", range: NSMakeRange(678, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "nov", yearValue: "10", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 november 90", range: NSMakeRange(688, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "november", yearValue: "90", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 dec 23", range: NSMakeRange(703, 9),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "dec", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 december 23", range: NSMakeRange(713, 14),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "december", yearValue: "23", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 feb 1648", range: NSMakeRange(728, 11),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "feb", yearValue: "1648", formatType: .DMY)),
        ExtractedDateResult(originalString: "29 february 2012", range: NSMakeRange(740, 16),
                            formatComponents: DateFormatComponents(dayValue: "29", monthValue: "february", yearValue: "2012", formatType: .DMY)),
        ExtractedDateResult(originalString: "01 jan 24", range: NSMakeRange(757, 9),
                            formatComponents: DateFormatComponents(dayValue: "01", monthValue: "jan", yearValue: "24", formatType: .DMY)),
        ExtractedDateResult(originalString: "09 sep 12", range: NSMakeRange(767, 9),
                            formatComponents: DateFormatComponents(dayValue: "09", monthValue: "sep", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "1 oct 12", range: NSMakeRange(777, 8),
                            formatComponents: DateFormatComponents(dayValue: "1", monthValue: "oct", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "9 dec 12", range: NSMakeRange(786, 8),
                            formatComponents: DateFormatComponents(dayValue: "9", monthValue: "dec", yearValue: "12", formatType: .DMY)),
        ExtractedDateResult(originalString: "10 jan 11", range: NSMakeRange(795, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "jan", yearValue: "11", formatType: .DMY)),
        ExtractedDateResult(originalString: "19 sep 1992", range: NSMakeRange(805, 11),
                            formatComponents: DateFormatComponents(dayValue: "19", monthValue: "sep", yearValue: "1992", formatType: .DMY)),
        ExtractedDateResult(originalString: "10 nov 11", range: NSMakeRange(817, 9),
                            formatComponents: DateFormatComponents(dayValue: "10", monthValue: "nov", yearValue: "11", formatType: .DMY)),
        ExtractedDateResult(originalString: "22 nov 34", range: NSMakeRange(827, 9),
                            formatComponents: DateFormatComponents(dayValue: "22", monthValue: "nov", yearValue: "34", formatType: .DMY)),
        ExtractedDateResult(originalString: "26 dec 6790", range: NSMakeRange(837, 11),
                            formatComponents: DateFormatComponents(dayValue: "26", monthValue: "dec", yearValue: "6790", formatType: .DMY))
    ]
}
