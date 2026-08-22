//
//  DateExtractable.swift
//
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

public protocol DateExtractable {
    func extractDateStringAndFormat(string: String) -> [ExtractedDateResult]
    func extractStringWithRegex(string: String, regexPattern: String) -> [MatchedResult]
    func detectDateSeparator(string: String) -> String?
}

public extension DateExtractable {
    func extractStringWithRegex(string: String, regexPattern: String) -> [MatchedResult] {
        let options: NSRegularExpression.Options = [.caseInsensitive]
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: options) else {
            return []
        }

        return extractStringWithRegex(string: string, regex: regex)
    }

    func extractStringWithRegex(string: String, regex: NSRegularExpression) -> [MatchedResult] {
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.matches(in: string, range: range)
        var matchedResults = [MatchedResult]()
        for match in matches {
            let matchedString = (string as NSString).substring(with: match.range)
            matchedResults.append(MatchedResult(string: matchedString, range: match.range))
        }

        return matchedResults
    }

    func detectDateSeparator(string: String) -> String? {
        let separators: [String] = ["/", "-", "."]
        for separator in separators where string.contains(separator) {
            return separator
        }

        return nil
    }
}
