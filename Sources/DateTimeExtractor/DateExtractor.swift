//
//  DateExtractor.swift
//
//
//  Created by Harry Tran on 21/12/2023.
//

import Foundation

public struct DateExtractor: DateExtractable {

    public private(set) var prioritizedFormatType: DateFormatType = .MDY
    public private(set) var extractors: [DateExtractable] = []

    public init(prioritizedFormatType: DateFormatType = .MDY) {
        self.prioritizedFormatType = prioritizedFormatType
    }
    
    public mutating func setPrioritizedFormatType(_ prioritizedFormatType: DateFormatType) {
        self.prioritizedFormatType = prioritizedFormatType
    }
    
    public mutating func registerDefaultExtractors() {
        let dmyExtractor = DateDMYExtractor()
        extractors.append(dmyExtractor)
        let mdyExtractor = DateMDYExtractor()
        extractors.append(mdyExtractor)
        let ymdExtractor = DateYMDExtractor()
        extractors.append(ymdExtractor)
    }

    public mutating func registerExtractor(_ extractor: DateExtractable) {
        extractors.append(extractor)
    }

    public func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        var results = [ExtractedDateResult]()
        for extractor in extractors {
            let formats = extractor.extractDateStringAndFormat(string: string)
            results.append(contentsOf: formats)
        }

        let groups = results.groupResultsBySameRange()
        var uniqueRangeItems = groups.filter { $0.count == 1 }.flatMap { $0 }
        let sameRangeItems = groups.filter { $0.count > 1 }
            .map { $0.first(where: { $0.formatComponents.formatType == self.prioritizedFormatType }) }
            .compactMap { $0 }
        uniqueRangeItems.append(contentsOf: sameRangeItems)
        
        return uniqueRangeItems
    }
}
