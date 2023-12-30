//
//  File.swift
//  
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

public struct DateFormatComponents: Hashable {
    public let dayValue: String
    public let monthValue: String
    public let yearValue: String
    public let formatType: DateFormatType
    public private(set) var day: String = ""
    public private(set) var month: String = ""
    public private(set) var year: String = ""

    public init(dayValue: String, monthValue: String, yearValue: String, formatType: DateFormatType) {
        self.dayValue = dayValue
        self.monthValue = monthValue
        self.yearValue = yearValue
        self.day = dayValue.count == 2 ? "dd" : "d"
        switch monthValue.count {
            case 1:
                self.month = "M"
                break
            case 2:
                self.month = "MM"
                break
            case 3:
                self.month = "MMM"
                break
            default:
                self.month = "MMMM"
                break
        }
        self.year = yearValue.count == 2 ? "yy" : "yyyy"
        self.formatType = formatType
    }

    public func getFormat(withSeparator separator: String = "/") -> String {
        switch formatType {
        case .DMY:
            return "\(day)\(separator)\(month)\(separator)\(year)"
        case .MDY:
            return "\(month)\(separator)\(day)\(separator)\(year)"
        case .YMD:
            return "\(year)\(separator)\(month)\(separator)\(day)"
        }
    }
    
    public func getFormattedString(withSeparator separator: String = "/") -> String {
        switch formatType {
            case .DMY:
                return "\(dayValue)\(separator)\(monthValue)\(separator)\(yearValue)"
            case .MDY:
                return "\(monthValue)\(separator)\(dayValue)\(separator)\(yearValue)"
            case .YMD:
                return "\(yearValue)\(separator)\(monthValue)\(separator)\(dayValue)"
        }
    }
}
