//
//  CustomDateExtractor.swift
//  DateTimeExtractorDemo
//
//  Created by Harry Tran on 25/12/2023.
//

import DateTimeExtractor
import Foundation

struct CustomDateExtractor: DateExtractable {
    // `MMMdd yy`, `MMMdd yyy`, `MMMdd' yy`, `MMMdd' yyy`
    // `MMMMdd yy`, `MMMMdd yyy`, `MMMMdd' yy`, `MMMMdd' yyy`
    // swiftlint:disable:next line_length - single regex literal, cannot be wrapped
    private let regex: String = "\\b(?:(?:(?:jan(?:uary)?|mar(?:ch)?|may|jul(?:y)?|aug(?:ust)?|oct(?:ober)?|dec(?:ember)?)31[']?)( )|(?:(?:jan(?:uary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)(?:29|30)[']?( )))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b|\\b(?:(?:feb(?:ruary)?)29[']?( )(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))\\b|\\b(?:(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch?)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?)|(?:oct(?:ober)?|nov(?:ember)?|dec(?:ember)?))(?:0?[1-9]|1\\d|2[0-8])[']?( )(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b"

    func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        var results = [ExtractedDateResult]()
        let matchedResults = extractStringWithRegex(string: string, regexPattern: regex)
        for matchedResult in matchedResults {
            let separator = detectDateSeparator(string: matchedResult.string) ?? " "
            let dateComponents = matchedResult.string.components(separatedBy: separator)
            let yearValue = dateComponents[1]

            // Extract month and date
            let pattern = "([0-5]?\\d)"
            let monthDayComponent = dateComponents[0]
            if let dateString = extractStringWithRegex(string: monthDayComponent, regexPattern: pattern).first?.string {
                let dayValue = dateString
                if let monthValue = monthDayComponent.components(separatedBy: dateString).first {
                    let formatComponents = DateFormatComponents(dayValue: dayValue,
                                                                monthValue: monthValue,
                                                                yearValue: yearValue,
                                                                formatType: .DMY)
                    let format = ExtractedDateResult(originalString: matchedResult.string,
                                                     range: matchedResult.range,
                                                     formatComponents: formatComponents)
                    results.append(format)
                }
            }
        }

        return results
    }
}
