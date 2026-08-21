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
    public private(set) var ampm: String = ""
    public private(set) var hourFormat: String = ""
    public private(set) var minuteFormat: String = ""
    public private(set) var secondFormat: String = ""

    init(hourValue: String = "", minuteValue: String = "", secondValue: String = "", ampm: String = "") {
        setHourValue(hourValue)
        setMinuteValue(minuteValue)
        setSecondValue(secondValue)
        setAMPM(ampm)
    }

    mutating func setHourValue(_ hourValue: String) {
        self.hourValue = hourValue
        switch hourValue.count {
        case 1:
            hourFormat = "H"
        case 2:
            hourFormat = "HH"
        default:
            hourFormat = ""
        }
    }

    mutating func setMinuteValue(_ minuteValue: String) {
        self.minuteValue = minuteValue

        switch minuteValue.count {
        case 1:
            minuteFormat = "m"
        case 2:
            minuteFormat = "mm"
        default:
            minuteFormat = ""
        }
    }

    mutating func setSecondValue(_ secondValue: String) {
        self.secondValue = secondValue
        switch secondValue.count {
        case 1:
            secondFormat = "s"
        case 2:
            secondFormat = "ss"
        default:
            secondFormat = ""
        }
    }

    mutating func setAMPM(_ ampm: String) {
        if let value = ampm.containsOneInArray(values: ["a", "p", "A", "P"]) {
            self.ampm = value.lowercased()
            hourFormat = hourFormat.lowercased()
        }
    }

    public func getFormat() -> String {
        var format = "\(hourFormat):\(minuteFormat)"
        if !secondFormat.isEmpty {
            format = "\(format):\(secondFormat)"
        }

        if !ampm.isEmpty {
            format = "\(format) a"
        }

        return format
    }

    public func getFormattedString() -> String {
        var formattedString = "\(hourValue):\(minuteValue)"
        if !secondValue.isEmpty {
            formattedString = "\(formattedString):\(secondValue)"
        }

        if !ampm.isEmpty {
            formattedString = "\(formattedString) \(getAMAndPMSign())"
        }

        return formattedString
    }

    public func getAMAndPMSign() -> String {
        if ampm == "a" {
            return "AM"
        } else {
            return "PM"
        }
    }
}

private extension String {
    func containsOneInArray(values: [String]) -> String? {
        for value in values where contains(value) {
            return value
        }
        return nil
    }
}
