//
//  DateYMDExtractor.swift
//
//
//  Created by Harry Tran on 27/12/2023.
//

import Foundation

public struct DateYMDExtractor: DateExtractable {
    // swiftlint:disable:next line_length - single regex literal, cannot be wrapped
    private let regex = "\\b(?:(?:1[6-9]|[2-9]\\d)\\d{2})(-)(?:(?:(?:0[13578]|1[02])\\1(?:31))|(?:(?:0[1,3-9]|1[0-2])\\1(?:(?:29|30))))\\b|\\b(?:(?:(?:1[6-9]|[2-9]\\d)(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00)))(-)(?:02)\\2?29\\b|\\b(?:(?:1[6-9]|[2-9]\\d)\\d{2})(-)(?:(?:0[1-9])|(?:1[0-2]))\\3(?:0[1-9]|1\\d|2[0-8])\\b"

    public func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        var results = [ExtractedDateResult]()

        let matchedResults = extractStringWithRegex(string: string, regexPattern: regex)

        if !matchedResults.isEmpty {
            for matchedResult in matchedResults {
                let extractedString = matchedResult.string.trimmingCharacters(in: .whitespaces)
                let separator = detectDateSeparator(string: matchedResult.string) ?? " "
                let dateComponents = extractedString.components(separatedBy: separator)
                let formatComponents = DateFormatComponents(dayValue: dateComponents[2],
                                                            monthValue: dateComponents[1],
                                                            yearValue: dateComponents[0],
                                                            formatType: .YMD)
                let format = ExtractedDateResult(originalString: matchedResult.string,
                                                 range: matchedResult.range,
                                                 formatComponents: formatComponents)
                results.append(format)
            }
        }

        return results
    }
}
