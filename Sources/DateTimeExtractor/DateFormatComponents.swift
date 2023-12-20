//
//  File.swift
//  
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

public struct DateFormatComponents {
    public private(set) var day: String = ""
    public private(set) var month: String = ""
    public private(set) var year: String = ""
    
    init(dayValue: String, monthValue: String, yearValue: String) {
        self.day = dayValue.count == 2 ? "dd" : "d"
        self.month = switch monthValue.count {
            case 1: "M"
            case 2: "MM"
            case 3: "MMM"
            default: "MMMM"
        }
        self.year = yearValue.count == 2 ? "yy" : "yyyy"
    }

    func getFormatWithPatternType(_ patternType: DateRegex.PatternType) -> String {
        switch patternType {
        case .DMY:
            return "\(day)/\(month)/\(year)"
        case .MDY:
            return "\(month)/\(day)/\(year)"
        case .YMD:
            return "\(year)/\(month)/\(day)"
        }
    }
}
