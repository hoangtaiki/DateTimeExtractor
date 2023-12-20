//
//  TimeFormatComponents.swift
//
//
//  Created by Harry Tran on 20/12/2023.
//

import Foundation

public struct TimeFormatComponents {
    public private(set) var hourValue: String = ""
    public private(set) var minuteValue: String = ""
    public private(set) var secondValue: String = ""
    public private(set) var hourFormat: String = ""
    public private(set) var minuteFormat: String = ""
    public private(set) var secondFormat: String = ""
    public private(set) var ampm: String = ""
    
    mutating func setHourValue(_ hourValue: String) {
        self.hourValue = hourValue
        if hourValue.count == 1 {
            hourFormat = "h"
        } else {
            hourFormat = "hh"
        }
    }
    
    mutating func setMinuteValue(_ minuteValue: String) {
        self.minuteValue = minuteValue
        if minuteValue.count == 1 {
            minuteFormat = "m"
        } else {
            minuteFormat = "mm"
        }
    }
    
    mutating func setSecondValue(_ secondValue: String) {
        self.secondValue = secondValue
        if secondValue.count == 1 {
            secondFormat = "s"
        } else {
            secondFormat = "ss"
        }
    }
    
    mutating func setAMPM(_ ampm: String) {
        self.ampm = ampm
    }
    
    func getFormat() -> String {
        var format = "\(hourFormat):\(minuteFormat)"
        if !secondFormat.isEmpty {
            format = "\(format):\(secondFormat)"
        }
        
        if !ampm.isEmpty {
            format = "\(format) a"
        }
        
        return format
    }
    
    func getFormattedString() -> String {
        var formattedString = "\(hourValue):\(minuteValue)"
        if !secondValue.isEmpty {
            formattedString = "\(formattedString):\(secondValue)"
        }
        
        if !ampm.isEmpty {
            formattedString = "\(formattedString) \(getAMAndPMSign())"
        }
        
        return formattedString
    }
    
    private func getAMAndPMSign() -> String {
        if ampm == "a" {
            return "AM"
        } else {
            return "PM"
        }
    }
}
