//
//  KoreanDotDateExtractor.swift
//  DateTimeExtractor
//
//  Generic dotted `YYYY.MM.DD` date extractor - the dot-separator sibling of `DateYMDExtractor`
//  (whose regex hardcodes `-`). Common in Korean receipts, but not Korea-specific. Opt-in:
//  it is NOT part of `registerDefaultExtractors()`; a consumer registers it explicitly.
//

import Foundation

public struct KoreanDotDateExtractor: DateExtractable {
    /// YYYY.MM.DD - four-digit year, zero-padded month/day, dot separators.
    private let regex = #"\b(?:1[6-9]|[2-9]\d)\d{2}\.(?:0[1-9]|1[0-2])\.(?:0[1-9]|[12]\d|3[01])\b"#

    public init() {}

    public func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        var results = [ExtractedDateResult]()
        let matchedResults = extractStringWithRegex(string: string, regexPattern: regex)

        for matchedResult in matchedResults {
            let extractedString = matchedResult.string.trimmingCharacters(in: .whitespaces)
            let dateComponents = extractedString.components(separatedBy: ".")
            guard dateComponents.count == 3 else { continue }
            let formatComponents = DateFormatComponents(dayValue: dateComponents[2],
                                                        monthValue: dateComponents[1],
                                                        yearValue: dateComponents[0],
                                                        formatType: .YMD)
            results.append(ExtractedDateResult(originalString: matchedResult.string,
                                               range: matchedResult.range,
                                               formatComponents: formatComponents))
        }

        return results
    }
}
