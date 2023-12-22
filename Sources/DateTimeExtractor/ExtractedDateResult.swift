//
//  File.swift
//  
//
//  Created by Harry Tran on 21/12/2023.
//

import Foundation

public struct ExtractedDateResult: Equatable {
    public let originalString: String
    public let range: NSRange
    public let formatComponents: DateFormatComponents
    
    public init(originalString: String, range: NSRange, formatComponents: DateFormatComponents) {
        self.originalString = originalString
        self.range = range
        self.formatComponents = formatComponents
    }
    
    public static func == (lhs: ExtractedDateResult, rhs: ExtractedDateResult) -> Bool {
        return lhs.originalString == rhs.originalString
        && lhs.range == rhs.range
        && lhs.formatComponents.getFormat() == rhs.formatComponents.getFormat()
        && lhs.formatComponents.getFormattedString() == rhs.formatComponents.getFormattedString()
    }
    
    init(original: String, range: NSRange, day: String, month: String, year: String, formatType: DateFormatType) {
        self.originalString = original
        self.range = range
        self.formatComponents = DateFormatComponents(dayValue: day, monthValue: month, yearValue: year, formatType: formatType)
    }
}

public extension Array where Iterator.Element == ExtractedDateResult {
    
    func groupResultsBySameRange() -> [[ExtractedDateResult]] {
        let sortedElements = sorted(by: { $0.range.location < $1.range.location } )
        
        if sortedElements.isEmpty {
            return []
        }
        
        if sortedElements.count == 1 {
            return [self]
        }
        
        var sameRangeElements: [[ExtractedDateResult]] = [[sortedElements[0]]]
        for index in 1..<sortedElements.count {
            let currentElement = sortedElements[index]
            let previousElement = sortedElements[index - 1]
            
            if currentElement.range == previousElement.range {
                sameRangeElements[sameRangeElements.count - 1].append(currentElement)
            } else {
                sameRangeElements.append([currentElement])
            }
        }
        
        return sameRangeElements
    }
}

