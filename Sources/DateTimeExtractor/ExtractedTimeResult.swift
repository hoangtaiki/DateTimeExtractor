//
//  File.swift
//  
//
//  Created by Harry Tran on 21/12/2023.
//

import Foundation

public struct ExtractedTimeResult: Equatable {
    public let originalString: String
    public let range: NSRange
    public let formatComponents: TimeFormatComponents
    
    public static func == (lhs: ExtractedTimeResult, rhs: ExtractedTimeResult) -> Bool {
        return lhs.originalString == rhs.originalString
        && lhs.range == rhs.range
        && lhs.formatComponents.getFormat() == rhs.formatComponents.getFormat()
        && lhs.formatComponents.getFormattedString() == rhs.formatComponents.getFormattedString()
    }
}
