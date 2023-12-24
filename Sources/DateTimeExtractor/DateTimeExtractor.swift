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
        var dates = groupingResult.adjacentResults.map { $0.getDate(timezone: timezone) }.compactMap { $0 }
        
        if supportedDateTimeTypes.contains(.onlyDate) {
            let onlyDates = groupingResult.remainingDates.map { $0.getDate(timezone: timezone) }.compactMap { $0 }
            dates.append(contentsOf: onlyDates)
        }
        
        return dates
    }
}

private extension DateTimeExtractor {
    
    struct ParsedDateTime {
        let dateResult: ExtractedDateResult
        let timeResult: ExtractedTimeResult
        
        func getDate(timezone: TimeZone) -> Date? {
            let dateTimeString = "\(dateResult.formatComponents.getFormattedString()) \(timeResult.formatComponents.getFormattedString())"
            let dateTimeFormat = "\(dateResult.formatComponents.getFormat()) \(timeResult.formatComponents.getFormat())"
            let dateFormater = DateFormatter()
            dateFormater.timeZone = timezone
            dateFormater.dateFormat = dateTimeFormat
            let date = dateFormater.date(from: dateTimeString)
            return date
        }
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
        var remainingDates: [ExtractedDateResult] = dateResults
        var remainingTimes: [ExtractedTimeResult] = timeResults
        
        var leftIndex = 0
        var rightIndex = 1
        while leftIndex < itemRanges.count && rightIndex < itemRanges.count {
            let leftItemRange = itemRanges[leftIndex]
            let rightItemRange = itemRanges[rightIndex]
            if shouldCombine(leftItemRange, rightItemRange) {
                let (dateIndex, timeIndex) = determineDateAndTimeIndices(leftItemRange, rightItemRange)
                let dateItem = dateResults[dateIndex]
                let timeItem = timeResults[timeIndex]
                
                if areRangesAdjacent(dateItem.range, timeItem.range) {
                    let combinedResult = ParsedDateTime(dateResult: dateItem, timeResult: timeItem)
                    adjacentResults.append(combinedResult)
                    
                    remainingDates.removeAll(where: { $0.range == dateItem.range })
                    remainingTimes.removeAll(where: { $0.range == timeItem.range })
                    
                    leftIndex += 2
                    rightIndex += 2
                } else {
                    leftIndex += 1
                    rightIndex += 1
                }
            } else {
                leftIndex += 1
                rightIndex += 1
            }
        }
        
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
                leftItemRange.itemType == .time ? rightItemRange.index : rightItemRange.index)
    }
    
    func areRangesAdjacent(_ range1: NSRange, _ range2: NSRange) -> Bool {
        let case1 = range2.location == range1.location + range1.length + 1
        let case2 = range1.location == range2.location + range2.length + 1
        return case1 || case2
    }
}

extension ExtractedDateResult {
    
    func getDate(timezone: TimeZone) -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.timeZone = timezone
        dateFormater.dateFormat = formatComponents.getFormat()
        let date = dateFormater.date(from: formatComponents.getFormattedString())
        return date
    }
}
