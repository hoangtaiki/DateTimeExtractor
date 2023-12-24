//
//  TimeFormatComponentsTests.swift
//  
//
//  Created by Harry Tran on 24/12/2023.
//

import XCTest
@testable import DateTimeExtractor

final class TimeFormatComponentsTests: XCTestCase {
    
    func testInitialization() {
        let timeComponents = TimeFormatComponents(hourValue: "10", minuteValue: "30", secondValue: "45", ampm: "PM")
        XCTAssertEqual(timeComponents.hourValue, "10")
        XCTAssertEqual(timeComponents.minuteValue, "30")
        XCTAssertEqual(timeComponents.secondValue, "45")
        XCTAssertEqual(timeComponents.ampm, "p")
        XCTAssertEqual(timeComponents.hourFormat, "hh")
        XCTAssertEqual(timeComponents.minuteFormat, "mm")
        XCTAssertEqual(timeComponents.secondFormat, "ss")
    }
    
    func testSetHourValue() {
        var timeComponents = TimeFormatComponents()
        timeComponents.setHourValue("1")
        XCTAssertEqual(timeComponents.hourFormat, "H")
        
        timeComponents.setHourValue("12")
        XCTAssertEqual(timeComponents.hourFormat, "HH")
        
        timeComponents.setHourValue("123")
        XCTAssertEqual(timeComponents.hourFormat, "")
    }
    
    func testSetMinuteValue() {
        var timeComponents = TimeFormatComponents()
        timeComponents.setMinuteValue("5")
        XCTAssertEqual(timeComponents.minuteFormat, "m")
        
        timeComponents.setMinuteValue("15")
        XCTAssertEqual(timeComponents.minuteFormat, "mm")
        
        timeComponents.setMinuteValue("150")
        XCTAssertEqual(timeComponents.minuteFormat, "")
    }
    
    func testSetSecondValue() {
        var timeComponents = TimeFormatComponents()
        timeComponents.setSecondValue("7")
        XCTAssertEqual(timeComponents.secondFormat, "s")
        
        timeComponents.setSecondValue("25")
        XCTAssertEqual(timeComponents.secondFormat, "ss")
        
        timeComponents.setSecondValue("250")
        XCTAssertEqual(timeComponents.secondFormat, "")
    }
    
    func testSetAMPM() {
        var timeComponents = TimeFormatComponents()
        timeComponents.setHourValue("1")
        timeComponents.setAMPM("am")
        XCTAssertEqual(timeComponents.ampm, "a")
        XCTAssertEqual(timeComponents.hourFormat, "h")
        
        timeComponents.setHourValue("11")
        timeComponents.setAMPM("PM")
        XCTAssertEqual(timeComponents.ampm, "p")
        XCTAssertEqual(timeComponents.hourFormat, "hh")
    }
    
    func testGetFormat12Hour() {
        let timeComponents = TimeFormatComponents(hourValue: "10", minuteValue: "30", secondValue: "45", ampm: "PM")
        XCTAssertEqual(timeComponents.getFormat(), "hh:mm:ss a")
    }
    
    func testGetFormat24Hour() {
        let timeComponents = TimeFormatComponents(hourValue: "10", minuteValue: "30", secondValue: "45", ampm: "")
        XCTAssertEqual(timeComponents.getFormat(), "HH:mm:ss")
    }
    
    func testGetFormattedString() {
        let timeComponents = TimeFormatComponents(hourValue: "10", minuteValue: "30", secondValue: "45", ampm: "PM")
        XCTAssertEqual(timeComponents.getFormattedString(), "10:30:45 PM")
    }
    
    func testGetFormattedStringWithoutSeconds() {
        let timeComponents = TimeFormatComponents(hourValue: "10", minuteValue: "30", secondValue: "", ampm: "")
        XCTAssertEqual(timeComponents.getFormattedString(), "10:30")
    }
    
    func testGetAMAndPMSign() {
        var timeComponents = TimeFormatComponents()
        timeComponents.setAMPM("am")
        XCTAssertEqual(timeComponents.getAMAndPMSign(), "AM")
        
        timeComponents.setAMPM("PM")
        XCTAssertEqual(timeComponents.getAMAndPMSign(), "PM")
    }
    

}
