//
//  DateTimeExtractable.swift
//  
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

public struct MatchedResult {
    let string: String
    let range: NSRange
}

public struct ExtractedDateResult: Hashable {
    let originalString: String
    let formatedString: String
    let dateFormat: String
    let range: NSRange
    
    public static func == (lhs: ExtractedDateResult, rhs: ExtractedDateResult) -> Bool {
        return lhs.originalString == rhs.originalString 
        && lhs.formatedString == rhs.formatedString
        && lhs.dateFormat == rhs.dateFormat
        && rhs.range == lhs.range
    }
}

public protocol DateTimeExtractable {
    func extractDateStringAndFormat(string: String) -> [ExtractedDateResult]
    func extractStringWithRegex(string: String, regexPattern: String) -> [MatchedResult]
    func detectDateSeparator(string: String) -> String?
}

public extension DateTimeExtractable {
    
    func extractStringWithRegex(string: String, regexPattern: String) -> [MatchedResult] {
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: []) else {
            return []
        }
        
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
        for separator in separators {
            if string.contains(separator) {
                return separator
            }
        }
        
        return nil
    }
}
