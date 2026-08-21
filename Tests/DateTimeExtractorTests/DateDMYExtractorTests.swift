//
//  DateDMYExtractorTests.swift
//
//
//  Created by Harry Tran on 19/12/2023.
//

@testable import DateTimeExtractor
import XCTest

// swiftlint:disable line_length

final class DateDMYExtractorTests: XCTestCase {
    private let extractor = DateDMYExtractor()
    private let data = TestsData()

    func testInvalidDateShouldNotRecognize() {
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
            "02-may/13", "30-september.1990", "10-02 23", "01 01 23", "31 12 2023"
        ]
        for (index, dateString) in dateStrings.enumerated() {
            let results = extractor.extractDateStringAndFormat(string: dateString)
            let message = "Fail with \(dateString). Index \(index)"
            XCTAssertTrue(results.isEmpty, message)
        }
    }

    func testInvalidDateDayMonthYearShouldNotRecognize() {
        let dateStrings = [
            // Slash
            "31/02/2023", "31/feb/2023", "31/february/2023", "31/02/23", "31/feb/23", "31/february/23",
            "31/06/2023", "31/jun/2023", "31/06/23", "31/jun/23",
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
            "31.06.2023", "31.jun.2023", "31.06.23", "31.jun.23",
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

    func testValidDateSlashFormat() {
        let paragraph = data.paragraphSlashFormat
        let expectedResults = data.expectedResultsSlashFormat

        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            XCTAssertEqual(result, expectedResults[index], message)
        }
    }

    func testValidDateDotFormat() {
        let paragraph = data.paragraphSlashFormat.replacingOccurrences(of: "/", with: ".")
        let expectedResults = data.expectedResultsSlashFormat

        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result.range, expectedResult.range, message)
            XCTAssertEqual(result.formatComponents.getFormat(), expectedResult.formatComponents.getFormat(), message)
            XCTAssertEqual(result.formatComponents.getFormattedString(), expectedResult.formatComponents.getFormattedString(), message)
        }
    }

    func testValidDateHyphenFormat() {
        let paragraph = data.paragraphSlashFormat.replacingOccurrences(of: "/", with: "-")
        let expectedResults = data.expectedResultsSlashFormat

        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

        XCTAssertEqual(results.count, expectedResults.count)
        for (index, result) in results.enumerated() {
            let message = "Fail with index \(index)"
            let expectedResult = expectedResults[index]
            XCTAssertEqual(result.range, expectedResult.range, message)
            XCTAssertEqual(result.formatComponents.getFormat(), expectedResult.formatComponents.getFormat(), message)
            XCTAssertEqual(result.formatComponents.getFormattedString(), expectedResult.formatComponents.getFormattedString(), message)
        }
    }

    func testValidDateSpaceFormat() {
        let paragraph = data.paragraphSpaceFormat
        let expectedResults = data.expectedResultsSpaceFormat

        let results = extractor.extractDateStringAndFormat(string: paragraph)
            .sorted(by: { $0.range.location < $1.range.location })

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
    20/JUNE/2023 23/June/23 24/January/2022
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

    let expectedResultsSlashFormat = [
        ExtractedDateResult(original: "31/01/1600", range: NSRange(location: 113, length: 10), day: "31", month: "01", year: "1600", formatType: .DMY),
        ExtractedDateResult(original: "31/03/1999", range: NSRange(location: 124, length: 10), day: "31", month: "03", year: "1999", formatType: .DMY),
        ExtractedDateResult(original: "31/05/2000", range: NSRange(location: 135, length: 10), day: "31", month: "05", year: "2000", formatType: .DMY),
        ExtractedDateResult(original: "31/07/56", range: NSRange(location: 146, length: 8), day: "31", month: "07", year: "56", formatType: .DMY),
        ExtractedDateResult(original: "31/08/78", range: NSRange(location: 155, length: 8), day: "31", month: "08", year: "78", formatType: .DMY),
        ExtractedDateResult(original: "31/10/1999", range: NSRange(location: 164, length: 10), day: "31", month: "10", year: "1999", formatType: .DMY),
        ExtractedDateResult(original: "31/12/9999", range: NSRange(location: 175, length: 10), day: "31", month: "12", year: "9999", formatType: .DMY),
        ExtractedDateResult(original: "31/jan/91", range: NSRange(location: 186, length: 9), day: "31", month: "jan", year: "91", formatType: .DMY),
        ExtractedDateResult(original: "31/january/01", range: NSRange(location: 196, length: 13), day: "31", month: "january", year: "01", formatType: .DMY),
        ExtractedDateResult(original: "31/mar/2023", range: NSRange(location: 210, length: 11), day: "31", month: "mar", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/march/23", range: NSRange(location: 222, length: 11), day: "31", month: "march", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "31/may/1756", range: NSRange(location: 234, length: 11), day: "31", month: "may", year: "1756", formatType: .DMY),
        ExtractedDateResult(original: "31/july/2023", range: NSRange(location: 246, length: 12), day: "31", month: "july", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/jul/2023", range: NSRange(location: 259, length: 11), day: "31", month: "jul", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/aug/2023", range: NSRange(location: 271, length: 11), day: "31", month: "aug", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/august/2023", range: NSRange(location: 283, length: 14), day: "31", month: "august", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/oct/2023", range: NSRange(location: 298, length: 11), day: "31", month: "oct", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/october/2023", range: NSRange(location: 310, length: 15), day: "31", month: "october", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/dec/2023", range: NSRange(location: 326, length: 11), day: "31", month: "dec", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/december/2023", range: NSRange(location: 338, length: 16), day: "31", month: "december", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/1/90", range: NSRange(location: 355, length: 7), day: "31", month: "1", year: "90", formatType: .DMY),
        ExtractedDateResult(original: "31/3/2993", range: NSRange(location: 363, length: 9), day: "31", month: "3", year: "2993", formatType: .DMY),
        ExtractedDateResult(original: "31/5/1982", range: NSRange(location: 373, length: 9), day: "31", month: "5", year: "1982", formatType: .DMY),
        ExtractedDateResult(original: "31/7/1856", range: NSRange(location: 383, length: 9), day: "31", month: "7", year: "1856", formatType: .DMY),
        ExtractedDateResult(original: "31/8/2378", range: NSRange(location: 393, length: 9), day: "31", month: "8", year: "2378", formatType: .DMY),
        ExtractedDateResult(original: "30/01/2023", range: NSRange(location: 403, length: 10), day: "30", month: "01", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/03/23", range: NSRange(location: 414, length: 8), day: "30", month: "03", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "30/09/1920", range: NSRange(location: 423, length: 10), day: "30", month: "09", year: "1920", formatType: .DMY),
        ExtractedDateResult(original: "30/05/1920", range: NSRange(location: 434, length: 10), day: "30", month: "05", year: "1920", formatType: .DMY),
        ExtractedDateResult(original: "30/1/22", range: NSRange(location: 445, length: 7), day: "30", month: "1", year: "22", formatType: .DMY),
        ExtractedDateResult(original: "30/3/53", range: NSRange(location: 453, length: 7), day: "30", month: "3", year: "53", formatType: .DMY),
        ExtractedDateResult(original: "30/9/19", range: NSRange(location: 461, length: 7), day: "30", month: "9", year: "19", formatType: .DMY),
        ExtractedDateResult(original: "30/10/19", range: NSRange(location: 469, length: 8), day: "30", month: "10", year: "19", formatType: .DMY),
        ExtractedDateResult(original: "30/11/1909", range: NSRange(location: 478, length: 10), day: "30", month: "11", year: "1909", formatType: .DMY),
        ExtractedDateResult(original: "30/12/1919", range: NSRange(location: 489, length: 10), day: "30", month: "12", year: "1919", formatType: .DMY),
        ExtractedDateResult(original: "30/12/1919", range: NSRange(location: 500, length: 10), day: "30", month: "12", year: "1919", formatType: .DMY),
        ExtractedDateResult(original: "30/jan/2023", range: NSRange(location: 511, length: 11), day: "30", month: "jan", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/january/23", range: NSRange(location: 523, length: 13), day: "30", month: "january", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "30/mar/2023", range: NSRange(location: 537, length: 11), day: "30", month: "mar", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/march/2023", range: NSRange(location: 549, length: 13), day: "30", month: "march", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/apr/2023", range: NSRange(location: 563, length: 11), day: "30", month: "apr", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/april/2023", range: NSRange(location: 575, length: 13), day: "30", month: "april", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/may/2023", range: NSRange(location: 589, length: 11), day: "30", month: "may", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/jun/2023", range: NSRange(location: 601, length: 11), day: "30", month: "jun", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/jul/2023", range: NSRange(location: 613, length: 11), day: "30", month: "jul", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/july/22", range: NSRange(location: 625, length: 10), day: "30", month: "july", year: "22", formatType: .DMY),
        ExtractedDateResult(original: "30/aug/2023", range: NSRange(location: 636, length: 11), day: "30", month: "aug", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30/august/17", range: NSRange(location: 648, length: 12), day: "30", month: "august", year: "17", formatType: .DMY),
        ExtractedDateResult(original: "30/sep/25", range: NSRange(location: 661, length: 9), day: "30", month: "sep", year: "25", formatType: .DMY),
        ExtractedDateResult(original: "30/september/44", range: NSRange(location: 671, length: 15), day: "30", month: "september", year: "44", formatType: .DMY),
        ExtractedDateResult(original: "30/oct/20", range: NSRange(location: 687, length: 9), day: "30", month: "oct", year: "20", formatType: .DMY),
        ExtractedDateResult(original: "30/october/21", range: NSRange(location: 697, length: 13), day: "30", month: "october", year: "21", formatType: .DMY),
        ExtractedDateResult(original: "30/nov/10", range: NSRange(location: 711, length: 9), day: "30", month: "nov", year: "10", formatType: .DMY),
        ExtractedDateResult(original: "30/november/90", range: NSRange(location: 721, length: 14), day: "30", month: "november", year: "90", formatType: .DMY),
        ExtractedDateResult(original: "30/dec/23", range: NSRange(location: 736, length: 9), day: "30", month: "dec", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "30/december/23", range: NSRange(location: 746, length: 14), day: "30", month: "december", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29/01/2023", range: NSRange(location: 761, length: 10), day: "29", month: "01", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/03/23", range: NSRange(location: 772, length: 8), day: "29", month: "03", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29/09/1920", range: NSRange(location: 781, length: 10), day: "29", month: "09", year: "1920", formatType: .DMY),
        ExtractedDateResult(original: "29/05/1920", range: NSRange(location: 792, length: 10), day: "29", month: "05", year: "1920", formatType: .DMY),
        ExtractedDateResult(original: "29/1/22", range: NSRange(location: 803, length: 7), day: "29", month: "1", year: "22", formatType: .DMY),
        ExtractedDateResult(original: "29/3/53", range: NSRange(location: 811, length: 7), day: "29", month: "3", year: "53", formatType: .DMY),
        ExtractedDateResult(original: "29/9/19", range: NSRange(location: 819, length: 7), day: "29", month: "9", year: "19", formatType: .DMY),
        ExtractedDateResult(original: "29/10/19", range: NSRange(location: 827, length: 8), day: "29", month: "10", year: "19", formatType: .DMY),
        ExtractedDateResult(original: "29/11/1909", range: NSRange(location: 836, length: 10), day: "29", month: "11", year: "1909", formatType: .DMY),
        ExtractedDateResult(original: "29/12/1919", range: NSRange(location: 847, length: 10), day: "29", month: "12", year: "1919", formatType: .DMY),
        ExtractedDateResult(original: "29/12/1919", range: NSRange(location: 858, length: 10), day: "29", month: "12", year: "1919", formatType: .DMY),
        ExtractedDateResult(original: "29/jan/2023", range: NSRange(location: 869, length: 11), day: "29", month: "jan", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/january/23", range: NSRange(location: 881, length: 13), day: "29", month: "january", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29/mar/2023", range: NSRange(location: 895, length: 11), day: "29", month: "mar", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/march/2023", range: NSRange(location: 907, length: 13), day: "29", month: "march", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/apr/2023", range: NSRange(location: 921, length: 11), day: "29", month: "apr", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/april/2023", range: NSRange(location: 933, length: 13), day: "29", month: "april", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/may/2023", range: NSRange(location: 947, length: 11), day: "29", month: "may", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/jun/2023", range: NSRange(location: 959, length: 11), day: "29", month: "jun", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/jul/2023", range: NSRange(location: 971, length: 11), day: "29", month: "jul", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/july/22", range: NSRange(location: 983, length: 10), day: "29", month: "july", year: "22", formatType: .DMY),
        ExtractedDateResult(original: "29/aug/2023", range: NSRange(location: 994, length: 11), day: "29", month: "aug", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29/august/17", range: NSRange(location: 1006, length: 12), day: "29", month: "august", year: "17", formatType: .DMY),
        ExtractedDateResult(original: "29/sep/25", range: NSRange(location: 1019, length: 9), day: "29", month: "sep", year: "25", formatType: .DMY),
        ExtractedDateResult(original: "29/september/44", range: NSRange(location: 1029, length: 15), day: "29", month: "september", year: "44", formatType: .DMY),
        ExtractedDateResult(original: "29/oct/20", range: NSRange(location: 1045, length: 9), day: "29", month: "oct", year: "20", formatType: .DMY),
        ExtractedDateResult(original: "29/october/21", range: NSRange(location: 1055, length: 13), day: "29", month: "october", year: "21", formatType: .DMY),
        ExtractedDateResult(original: "29/nov/10", range: NSRange(location: 1069, length: 9), day: "29", month: "nov", year: "10", formatType: .DMY),
        ExtractedDateResult(original: "29/november/90", range: NSRange(location: 1079, length: 14), day: "29", month: "november", year: "90", formatType: .DMY),
        ExtractedDateResult(original: "29/dec/23", range: NSRange(location: 1094, length: 9), day: "29", month: "dec", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29/december/23", range: NSRange(location: 1104, length: 14), day: "29", month: "december", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29/02/24", range: NSRange(location: 1119, length: 8), day: "29", month: "02", year: "24", formatType: .DMY),
        ExtractedDateResult(original: "29/2/1600", range: NSRange(location: 1128, length: 9), day: "29", month: "2", year: "1600", formatType: .DMY),
        ExtractedDateResult(original: "29/feb/1648", range: NSRange(location: 1138, length: 11), day: "29", month: "feb", year: "1648", formatType: .DMY),
        ExtractedDateResult(original: "29/february/2012", range: NSRange(location: 1150, length: 16), day: "29", month: "february", year: "2012", formatType: .DMY),
        ExtractedDateResult(original: "01/09/1600", range: NSRange(location: 1167, length: 10), day: "01", month: "09", year: "1600", formatType: .DMY),
        ExtractedDateResult(original: "09/01/1999", range: NSRange(location: 1178, length: 10), day: "09", month: "01", year: "1999", formatType: .DMY),
        ExtractedDateResult(original: "1/9/2000", range: NSRange(location: 1189, length: 8), day: "1", month: "9", year: "2000", formatType: .DMY),
        ExtractedDateResult(original: "9/1/9999", range: NSRange(location: 1198, length: 8), day: "9", month: "1", year: "9999", formatType: .DMY),
        ExtractedDateResult(original: "01/jan/24", range: NSRange(location: 1207, length: 9), day: "01", month: "jan", year: "24", formatType: .DMY),
        ExtractedDateResult(original: "09/sep/12", range: NSRange(location: 1217, length: 9), day: "09", month: "sep", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "1/oct/12", range: NSRange(location: 1227, length: 8), day: "1", month: "oct", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "9/dec/12", range: NSRange(location: 1236, length: 8), day: "9", month: "dec", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "1/10/09", range: NSRange(location: 1245, length: 7), day: "1", month: "10", year: "09", formatType: .DMY),
        ExtractedDateResult(original: "1/12/92", range: NSRange(location: 1253, length: 7), day: "1", month: "12", year: "92", formatType: .DMY),
        ExtractedDateResult(original: "01/11/12", range: NSRange(location: 1261, length: 8), day: "01", month: "11", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "10/01/1699", range: NSRange(location: 1270, length: 10), day: "10", month: "01", year: "1699", formatType: .DMY),
        ExtractedDateResult(original: "19/09/2999", range: NSRange(location: 1281, length: 10), day: "19", month: "09", year: "2999", formatType: .DMY),
        ExtractedDateResult(original: "10/1/9000", range: NSRange(location: 1292, length: 9), day: "10", month: "1", year: "9000", formatType: .DMY),
        ExtractedDateResult(original: "19/9/1800", range: NSRange(location: 1302, length: 9), day: "19", month: "9", year: "1800", formatType: .DMY),
        ExtractedDateResult(original: "10/jan/11", range: NSRange(location: 1312, length: 9), day: "10", month: "jan", year: "11", formatType: .DMY),
        ExtractedDateResult(original: "19/sep/1992", range: NSRange(location: 1322, length: 11), day: "19", month: "sep", year: "1992", formatType: .DMY),
        ExtractedDateResult(original: "10/nov/11", range: NSRange(location: 1334, length: 9), day: "10", month: "nov", year: "11", formatType: .DMY),
        ExtractedDateResult(original: "19/12/1992", range: NSRange(location: 1344, length: 10), day: "19", month: "12", year: "1992", formatType: .DMY),
        ExtractedDateResult(original: "20/01/12", range: NSRange(location: 1355, length: 8), day: "20", month: "01", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "28/09/08", range: NSRange(location: 1364, length: 8), day: "28", month: "09", year: "08", formatType: .DMY),
        ExtractedDateResult(original: "21/1/1902", range: NSRange(location: 1373, length: 9), day: "21", month: "1", year: "1902", formatType: .DMY),
        ExtractedDateResult(original: "27/9/9212", range: NSRange(location: 1383, length: 9), day: "27", month: "9", year: "9212", formatType: .DMY),
        ExtractedDateResult(original: "22/nov/34", range: NSRange(location: 1393, length: 9), day: "22", month: "nov", year: "34", formatType: .DMY),
        ExtractedDateResult(original: "26/dec/6790", range: NSRange(location: 1403, length: 11), day: "26", month: "dec", year: "6790", formatType: .DMY),
        ExtractedDateResult(original: "23/1/23", range: NSRange(location: 1415, length: 7), day: "23", month: "1", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "24/10/1945", range: NSRange(location: 1423, length: 10), day: "24", month: "10", year: "1945", formatType: .DMY),
        ExtractedDateResult(original: "25/11/9009", range: NSRange(location: 1434, length: 10), day: "25", month: "11", year: "9009", formatType: .DMY),
        ExtractedDateResult(original: "20/JUNE/2023", range: NSRange(location: 1445, length: 12), day: "20", month: "JUNE", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "23/June/23", range: NSRange(location: 1458, length: 10), day: "23", month: "June", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "24/January/2022", range: NSRange(location: 1469, length: 15), day: "24", month: "January", year: "2022", formatType: .DMY),
        ExtractedDateResult(original: "31/12/2023", range: NSRange(location: 1552, length: 10), day: "31", month: "12", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/01/23", range: NSRange(location: 1563, length: 8), day: "31", month: "01", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "28/dec/2023", range: NSRange(location: 1572, length: 11), day: "28", month: "dec", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/05/2023", range: NSRange(location: 1584, length: 10), day: "31", month: "05", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/03/2023", range: NSRange(location: 1595, length: 10), day: "31", month: "03", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/05/2023", range: NSRange(location: 1606, length: 10), day: "31", month: "05", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/03/2023", range: NSRange(location: 1617, length: 10), day: "31", month: "03", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/05/2023", range: NSRange(location: 1628, length: 10), day: "31", month: "05", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/1/31", range: NSRange(location: 1639, length: 7), day: "31", month: "1", year: "31", formatType: .DMY),
        ExtractedDateResult(original: "31/01/31", range: NSRange(location: 1655, length: 8), day: "31", month: "01", year: "31", formatType: .DMY),
        ExtractedDateResult(original: "31/1/23", range: NSRange(location: 1666, length: 7), day: "31", month: "1", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "31/05/2023", range: NSRange(location: 1674, length: 10), day: "31", month: "05", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31/12/23", range: NSRange(location: 1685, length: 8), day: "31", month: "12", year: "23", formatType: .DMY)
    ]

    let paragraphSpaceFormat = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    31 Jan 91 31 January 01 31 Mar 2023 31 March 23 31 May 1756 31 July 2023 31 Jul 2023 31 Aug 2023 31 August 2023 
    31 Oct 2023 31 October 2023 31 DEC 2023 31 December 2023 30 Jan 2023 30 January 23 30 Mar 2023 30 March 2023
    30 Apr 2023 30 April 2023 30 May 2023 30 Jun 2023 30 Jul 2023 30 July 22 30 Aug 2023 30 August 17 30 Sep 25
    30 September 44 30 Oct 20 30 October 21 30 Nov 10 30 November 90 30 Dec 23 30 December 23 29 Jan 2023
    29 JANUARY 23 29 Mar 2023 29 March 2023 29 Apr 2023 29 April 2023 29 May 2023 29 Jun 2023 29 Jul 2023
    29 July 22 29 Aug 2023 29 August 17 29 Sep 25 29 September 44 29 Oct 20 29 October 21 29 Nov 10
    29 November 90 29 Dec 23 29 December 23 29 Feb 1648 29 February 2012 01 Jan 24 09 Sep 12
    1 Oct 12 9 Dec 12 10 Jan 11 19 Sep 1992 10 Nov 11 22 Nov 34 26 Dec 6790 24 jan 2022
    """

    let expectedResultsSpaceFormat = [
        ExtractedDateResult(original: "31 Jan 91", range: NSRange(location: 57, length: 9), day: "31", month: "Jan", year: "91", formatType: .DMY),
        ExtractedDateResult(original: "31 January 01", range: NSRange(location: 67, length: 13), day: "31", month: "January", year: "01", formatType: .DMY),
        ExtractedDateResult(original: "31 Mar 2023", range: NSRange(location: 81, length: 11), day: "31", month: "Mar", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 March 23", range: NSRange(location: 93, length: 11), day: "31", month: "March", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "31 May 1756", range: NSRange(location: 105, length: 11), day: "31", month: "May", year: "1756", formatType: .DMY),
        ExtractedDateResult(original: "31 July 2023", range: NSRange(location: 117, length: 12), day: "31", month: "July", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 Jul 2023", range: NSRange(location: 130, length: 11), day: "31", month: "Jul", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 Aug 2023", range: NSRange(location: 142, length: 11), day: "31", month: "Aug", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 August 2023", range: NSRange(location: 154, length: 14), day: "31", month: "August", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 Oct 2023", range: NSRange(location: 170, length: 11), day: "31", month: "Oct", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 October 2023", range: NSRange(location: 182, length: 15), day: "31", month: "October", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 DEC 2023", range: NSRange(location: 198, length: 11), day: "31", month: "DEC", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "31 December 2023", range: NSRange(location: 210, length: 16), day: "31", month: "December", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 Jan 2023", range: NSRange(location: 227, length: 11), day: "30", month: "Jan", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 January 23", range: NSRange(location: 239, length: 13), day: "30", month: "January", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "30 Mar 2023", range: NSRange(location: 253, length: 11), day: "30", month: "Mar", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 March 2023", range: NSRange(location: 265, length: 13), day: "30", month: "March", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 Apr 2023", range: NSRange(location: 279, length: 11), day: "30", month: "Apr", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 April 2023", range: NSRange(location: 291, length: 13), day: "30", month: "April", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 May 2023", range: NSRange(location: 305, length: 11), day: "30", month: "May", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 Jun 2023", range: NSRange(location: 317, length: 11), day: "30", month: "Jun", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 Jul 2023", range: NSRange(location: 329, length: 11), day: "30", month: "Jul", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 July 22", range: NSRange(location: 341, length: 10), day: "30", month: "July", year: "22", formatType: .DMY),
        ExtractedDateResult(original: "30 Aug 2023", range: NSRange(location: 352, length: 11), day: "30", month: "Aug", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "30 August 17", range: NSRange(location: 364, length: 12), day: "30", month: "August", year: "17", formatType: .DMY),
        ExtractedDateResult(original: "30 Sep 25", range: NSRange(location: 377, length: 9), day: "30", month: "Sep", year: "25", formatType: .DMY),
        ExtractedDateResult(original: "30 September 44", range: NSRange(location: 387, length: 15), day: "30", month: "September", year: "44", formatType: .DMY),
        ExtractedDateResult(original: "30 Oct 20", range: NSRange(location: 403, length: 9), day: "30", month: "Oct", year: "20", formatType: .DMY),
        ExtractedDateResult(original: "30 October 21", range: NSRange(location: 413, length: 13), day: "30", month: "October", year: "21", formatType: .DMY),
        ExtractedDateResult(original: "30 Nov 10", range: NSRange(location: 427, length: 9), day: "30", month: "Nov", year: "10", formatType: .DMY),
        ExtractedDateResult(original: "30 November 90", range: NSRange(location: 437, length: 14), day: "30", month: "November", year: "90", formatType: .DMY),
        ExtractedDateResult(original: "30 Dec 23", range: NSRange(location: 452, length: 9), day: "30", month: "Dec", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "30 December 23", range: NSRange(location: 462, length: 14), day: "30", month: "December", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29 Jan 2023", range: NSRange(location: 477, length: 11), day: "29", month: "Jan", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 JANUARY 23", range: NSRange(location: 489, length: 13), day: "29", month: "JANUARY", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29 Mar 2023", range: NSRange(location: 503, length: 11), day: "29", month: "Mar", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 March 2023", range: NSRange(location: 515, length: 13), day: "29", month: "March", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 Apr 2023", range: NSRange(location: 529, length: 11), day: "29", month: "Apr", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 April 2023", range: NSRange(location: 541, length: 13), day: "29", month: "April", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 May 2023", range: NSRange(location: 555, length: 11), day: "29", month: "May", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 Jun 2023", range: NSRange(location: 567, length: 11), day: "29", month: "Jun", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 Jul 2023", range: NSRange(location: 579, length: 11), day: "29", month: "Jul", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 July 22", range: NSRange(location: 591, length: 10), day: "29", month: "July", year: "22", formatType: .DMY),
        ExtractedDateResult(original: "29 Aug 2023", range: NSRange(location: 602, length: 11), day: "29", month: "Aug", year: "2023", formatType: .DMY),
        ExtractedDateResult(original: "29 August 17", range: NSRange(location: 614, length: 12), day: "29", month: "August", year: "17", formatType: .DMY),
        ExtractedDateResult(original: "29 Sep 25", range: NSRange(location: 627, length: 9), day: "29", month: "Sep", year: "25", formatType: .DMY),
        ExtractedDateResult(original: "29 September 44", range: NSRange(location: 637, length: 15), day: "29", month: "September", year: "44", formatType: .DMY),
        ExtractedDateResult(original: "29 Oct 20", range: NSRange(location: 653, length: 9), day: "29", month: "Oct", year: "20", formatType: .DMY),
        ExtractedDateResult(original: "29 October 21", range: NSRange(location: 663, length: 13), day: "29", month: "October", year: "21", formatType: .DMY),
        ExtractedDateResult(original: "29 Nov 10", range: NSRange(location: 677, length: 9), day: "29", month: "Nov", year: "10", formatType: .DMY),
        ExtractedDateResult(original: "29 November 90", range: NSRange(location: 687, length: 14), day: "29", month: "November", year: "90", formatType: .DMY),
        ExtractedDateResult(original: "29 Dec 23", range: NSRange(location: 702, length: 9), day: "29", month: "Dec", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29 December 23", range: NSRange(location: 712, length: 14), day: "29", month: "December", year: "23", formatType: .DMY),
        ExtractedDateResult(original: "29 Feb 1648", range: NSRange(location: 727, length: 11), day: "29", month: "Feb", year: "1648", formatType: .DMY),
        ExtractedDateResult(original: "29 February 2012", range: NSRange(location: 739, length: 16), day: "29", month: "February", year: "2012", formatType: .DMY),
        ExtractedDateResult(original: "01 Jan 24", range: NSRange(location: 756, length: 9), day: "01", month: "Jan", year: "24", formatType: .DMY),
        ExtractedDateResult(original: "09 Sep 12", range: NSRange(location: 766, length: 9), day: "09", month: "Sep", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "1 Oct 12", range: NSRange(location: 776, length: 8), day: "1", month: "Oct", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "9 Dec 12", range: NSRange(location: 785, length: 8), day: "9", month: "Dec", year: "12", formatType: .DMY),
        ExtractedDateResult(original: "10 Jan 11", range: NSRange(location: 794, length: 9), day: "10", month: "Jan", year: "11", formatType: .DMY),
        ExtractedDateResult(original: "19 Sep 1992", range: NSRange(location: 804, length: 11), day: "19", month: "Sep", year: "1992", formatType: .DMY),
        ExtractedDateResult(original: "10 Nov 11", range: NSRange(location: 816, length: 9), day: "10", month: "Nov", year: "11", formatType: .DMY),
        ExtractedDateResult(original: "22 Nov 34", range: NSRange(location: 826, length: 9), day: "22", month: "Nov", year: "34", formatType: .DMY),
        ExtractedDateResult(original: "26 Dec 6790", range: NSRange(location: 836, length: 11), day: "26", month: "Dec", year: "6790", formatType: .DMY),
        ExtractedDateResult(original: "24 jan 2022", range: NSRange(location: 848, length: 11), day: "24", month: "jan", year: "2022", formatType: .DMY)
    ]
}
