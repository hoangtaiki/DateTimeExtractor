//
//  DateTimeExtractor.swift
//
//
//  Created by Harry Tran on 20/12/2023.
//

import Foundation

public enum SupportedDateTimeType {
    case bothDateAndTime
    case onlyDate
    case onlyTime
}

public struct DateTimeExtractor {
    
    private var dateExtractor: DateExtractable
    private var timezone: TimeZone
    private var supportedDateTimeTypes: [SupportedDateTimeType]
    private let timeExtractor = TimeExtractor()
    
    public init(dateExtractor: DateExtractable,
                supportedDateTimeTypes: [SupportedDateTimeType] = [.bothDateAndTime, .onlyDate],
                timezone: TimeZone = TimeZone.current) {
        self.dateExtractor = dateExtractor
        self.supportedDateTimeTypes = supportedDateTimeTypes
        self.timezone = timezone
    }
    
    public func extractDate(string: String) -> [Date] {
        let dateResults = dateExtractor.extractDateStringAndFormat(string: string)
            .sorted(by: { $0.range.location < $1.range.location } )
        let timeResults = timeExtractor.extractDateStringAndFormat(string: string)
            .sorted(by: { $0.range.location < $1.range.location } )
        
        if dateResults.isEmpty && timeResults.isEmpty {
            return []
        }
        
        let groupingResult = groupDateAndTimeResults(dateResults: dateResults, timeResults: timeResults)
        var dates = groupingResult.adjacentResults
            .map { $0.dateResult.getDate(withTimeResult: $0.timeResult, timezone: timezone) }
            .compactMap { $0 }
        
        if supportedDateTimeTypes.contains(.onlyDate) {
            let onlyDates = groupingResult.remainingDates.map { $0.getDate(timezone: timezone) }.compactMap { $0 }
            dates.append(contentsOf: onlyDates)
        }

        // Times with no adjacent date are anchored to the current day, so these
        // results are inherently non-deterministic (they depend on "now").
        if supportedDateTimeTypes.contains(.onlyTime) {
            let onlyTimes = groupingResult.remainingTimes.compactMap { $0.setTimeForDate(timezone: timezone) }
            dates.append(contentsOf: onlyTimes)
        }

        return dates
    }
}

private extension DateTimeExtractor {
    
    struct ParsedDateTime {
        let dateResult: ExtractedDateResult
        let timeResult: ExtractedTimeResult
    }
    
    struct DateAndTimeGroupingResult {
        var adjacentResults: [ParsedDateTime]
        var remainingDates: [ExtractedDateResult]
        var remainingTimes: [ExtractedTimeResult]
    }
    
    struct ExtractedItemRange {
        enum ItemType {
            case date
            case time
        }
        
        var index: Int
        var itemType: ItemType
        var range: NSRange
    }
    
    func groupDateAndTimeResults(dateResults: [ExtractedDateResult], 
                                 timeResults: [ExtractedTimeResult]) -> DateAndTimeGroupingResult {
        let dateItemRanges = dateResults.enumerated().map { (index, element) in
            ExtractedItemRange(index: index, itemType: .date, range: element.range)
        }
        let timeItemRanges = timeResults.enumerated().map { (index, element) in
            ExtractedItemRange(index: index, itemType: .time, range: element.range)
        }
        var itemRanges = dateItemRanges + timeItemRanges
        itemRanges = itemRanges.sorted(by: { $0.range.location < $1.range.location } )

        var adjacentResults: [ParsedDateTime] = []
        // Track which source-array elements got paired so the remainders can be
        // rebuilt from the originals. Removing from live copies mid-loop would
        // shift these indices and corrupt the result.
        var consumedDateIndices: Set<Int> = []
        var consumedTimeIndices: Set<Int> = []

        var leftIndex = 0
        while leftIndex + 1 < itemRanges.count {
            let leftItemRange = itemRanges[leftIndex]
            let rightItemRange = itemRanges[leftIndex + 1]
            if shouldCombine(leftItemRange, rightItemRange) {
                let (dateIndex, timeIndex) = determineDateAndTimeIndices(leftItemRange, rightItemRange)
                let dateItem = dateResults[dateIndex]
                let timeItem = timeResults[timeIndex]

                if areRangesAdjacent(dateItem.range, timeItem.range) {
                    let combinedResult = ParsedDateTime(dateResult: dateItem, timeResult: timeItem)
                    adjacentResults.append(combinedResult)

                    consumedDateIndices.insert(dateIndex)
                    consumedTimeIndices.insert(timeIndex)

                    leftIndex += 2
                } else {
                    leftIndex += 1
                }
            } else {
                leftIndex += 1
            }
        }

        let remainingDates = dateResults.enumerated()
            .filter { !consumedDateIndices.contains($0.offset) }.map { $0.element }
        let remainingTimes = timeResults.enumerated()
            .filter { !consumedTimeIndices.contains($0.offset) }.map { $0.element }

        let result = DateAndTimeGroupingResult(adjacentResults: adjacentResults,
                                               remainingDates: remainingDates,
                                               remainingTimes: remainingTimes)
        return result
    }
    
    func shouldCombine(_ leftItemRange: ExtractedItemRange, _ rightItemRange: ExtractedItemRange) -> Bool {
        return (leftItemRange.itemType == .date && rightItemRange.itemType == .time) ||
        (leftItemRange.itemType == .time && rightItemRange.itemType == .date)
    }
    
    func determineDateAndTimeIndices(_ leftItemRange: ExtractedItemRange, _ rightItemRange: ExtractedItemRange) -> (dateIndex: Int, timeIndex: Int) {
        return (leftItemRange.itemType == .date ? leftItemRange.index : rightItemRange.index,
                leftItemRange.itemType == .time ? leftItemRange.index : rightItemRange.index)
    }
    
    /// Max number of separator characters tolerated between a date and a time
    /// for them to still be treated as adjacent (e.g. ", " or a double space).
    /// Kept tight so unrelated nearby values are not merged.
    static let maxAdjacencyGap = 3

    func areRangesAdjacent(_ range1: NSRange, _ range2: NSRange) -> Bool {
        // Gap = characters strictly between the two ranges (0 = touching).
        let case1 = range2.location - (range1.location + range1.length)
        let case2 = range1.location - (range2.location + range2.length)
        let gap = max(case1, case2)
        return gap >= 0 && gap <= Self.maxAdjacencyGap
    }
}
