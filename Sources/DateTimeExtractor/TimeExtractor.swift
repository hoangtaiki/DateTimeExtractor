//
//  TimeExtractor.swift
//
//
//  Created by Harry Tran on 20/12/2023.
//

import Foundation

public struct TimeExtractor {
    // swiftlint:disable:next line_length - single regex literal, cannot be wrapped
    private let regexPattern: String = "(?:^|\\s|-)\\b((?:1[012]|0?[1-9]):([0-5][0-9])(?::[0-5][0-9])?((\\s?(am|pm))|(a|p))?|((1[3-9]|2[0-3]):[0-5][0-9](?::[0-5][0-9])?))\\b(?:(?!:))"

    public init() {}

    public func extractDateStringAndFormat(string: String) -> [ExtractedTimeResult] {
        var timeStringFormats = [ExtractedTimeResult]()

        let matchedResults = extractStringWithRegex(string: string, regexPattern: regexPattern)
        if !matchedResults.isEmpty {
            for matchedResult in matchedResults {
                let extractedString = matchedResult.string
                let dateComponents = extractedString.components(separatedBy: ":")
                var formatComponents = TimeFormatComponents()

                if dateComponents.count == 2 {
                    formatComponents.setHourValue(dateComponents[0])

                    let lastComponent = dateComponents[1]
                    if lastComponent.contains(" ") {
                        let components = lastComponent.components(separatedBy: " ")
                        formatComponents.setMinuteValue(components[0])
                        formatComponents.setAMPM(components[1])
                    } else {
                        let pattern = "([0-5]?\\d)"
                        if let dateString = extractStringWithRegex(string: lastComponent, regexPattern: pattern).first?.string {
                            formatComponents.setMinuteValue(dateString)

                            let suffix = lastComponent.replacingOccurrences(of: dateString, with: "")
                            formatComponents.setAMPM(suffix)
                        }
                    }
                } else if dateComponents.count == 3 {
                    formatComponents.setHourValue(dateComponents[0])
                    formatComponents.setMinuteValue(dateComponents[1])

                    let lastComponent = dateComponents[2]
                    if lastComponent.contains(" ") {
                        let components = lastComponent.components(separatedBy: " ")
                        formatComponents.setSecondValue(components[0])
                        formatComponents.setAMPM(components[1])
                    } else {
                        let pattern = "([0-5]?\\d)"
                        if let dateString = extractStringWithRegex(string: lastComponent, regexPattern: pattern).first?.string {
                            formatComponents.setSecondValue(dateString)

                            let suffix = lastComponent.replacingOccurrences(of: dateString, with: "")
                            formatComponents.setAMPM(suffix)
                        }
                    }
                }

                let format = ExtractedTimeResult(originalString: matchedResult.string,
                                                 range: matchedResult.range,
                                                 formatComponents: formatComponents)
                timeStringFormats.append(format)
            }
        }

        return timeStringFormats
    }

    func extractStringWithRegex(string: String, regexPattern: String) -> [MatchedResult] {
        let options: NSRegularExpression.Options = [.caseInsensitive]
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: options) else {
            return []
        }

        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.matches(in: string, range: range)
        var matchedResults = [MatchedResult]()
        for match in matches {
            let matchedString = (string as NSString).substring(with: match.range(at: 1))
            matchedResults.append(MatchedResult(string: matchedString, range: match.range(at: 1)))
        }

        return matchedResults
    }
}
