//
//  DateRegex.swift
//
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

public enum DateFormatType {
    case DMY
    case MDY
    case YMD
}

public struct DateRegex {
    public let formatType: DateFormatType
    public let pattern: String
    let compiledRegex: NSRegularExpression?

    public init(formatType: DateFormatType, pattern: String) {
        self.formatType = formatType
        self.pattern = pattern
        compiledRegex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
    }
}
