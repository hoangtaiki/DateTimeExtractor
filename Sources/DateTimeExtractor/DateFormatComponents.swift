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

    init(dayValue: String, monthValue: String, yearValue: String, formatType: DateFormatType) {
        self.dayValue = dayValue
        self.monthValue = monthValue
        self.yearValue = yearValue
        self.day = dayValue.count == 2 ? "dd" : "d"
        self.month = switch monthValue.count {
            case 1: "M"
            case 2: "MM"
            case 3: "MMM"
            default: "MMMM"
        }
        self.year = yearValue.count == 2 ? "yy" : "yyyy"
        self.formatType = formatType
    }

    func getFormat() -> String {
        switch formatType {
        case .DMY:
            return "\(day)/\(month)/\(year)"
        case .MDY:
            return "\(month)/\(day)/\(year)"
        case .YMD:
            return "\(year)/\(month)/\(day)"
        }
    }
    
    func getFormattedString() -> String {
        switch formatType {
            case .DMY:
                return "\(dayValue)/\(monthValue)/\(yearValue)"
            case .MDY:
                return "\(monthValue)/\(dayValue)/\(yearValue)"
            case .YMD:
                return "\(yearValue)/\(monthValue)/\(dayValue)"
        }
    }
}
