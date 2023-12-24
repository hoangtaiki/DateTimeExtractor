//
//  DateFormatComponentsTests.swift
//  
//
//  Created by Harry Tran on 24/12/2023.
//

import XCTest
@testable import DateTimeExtractor

final class DateFormatComponentsTests: XCTestCase {
    
    func testInitialization() {
        let components = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .DMY)
        
        XCTAssertEqual(components.dayValue, "01")
        XCTAssertEqual(components.monthValue, "12")
        XCTAssertEqual(components.yearValue, "2023")
        XCTAssertEqual(components.formatType, .DMY)
        XCTAssertEqual(components.day, "dd")
        XCTAssertEqual(components.month, "MM")
        XCTAssertEqual(components.year, "yyyy")
    }
    
    func testInitializationWithSingleDigitDayAndMonth() {
        let components = DateFormatComponents(dayValue: "1", monthValue: "2", yearValue: "2023", formatType: .MDY)
        
        XCTAssertEqual(components.day, "d")
        XCTAssertEqual(components.month, "M")
        XCTAssertEqual(components.year, "yyyy")
        XCTAssertEqual(components.formatType, .MDY)
    }
    
    func testInitializationWithDayAndShortMonthName() {
        let components = DateFormatComponents(dayValue: "1", monthValue: "Jan", yearValue: "23", formatType: .YMD)
        
        XCTAssertEqual(components.day, "d")
        XCTAssertEqual(components.month, "MMM")
        XCTAssertEqual(components.year, "yy")
        XCTAssertEqual(components.formatType, .YMD)
    }
    
    func testInitializationWithDayAndShortLongName() {
        let components = DateFormatComponents(dayValue: "1", monthValue: "January", yearValue: "2023", formatType: .DMY)
        
        XCTAssertEqual(components.day, "d")
        XCTAssertEqual(components.month, "MMMM")
        XCTAssertEqual(components.year, "yyyy")
    }
    
    func testGetFormat() {
        let componentsDMY = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .DMY)
        XCTAssertEqual(componentsDMY.getFormat(), "dd/MM/yyyy")
        
        let componentsMDY = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .MDY)
        XCTAssertEqual(componentsMDY.getFormat(), "MM/dd/yyyy")
        
        let componentsYMD = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .YMD)
        XCTAssertEqual(componentsYMD.getFormat(), "yyyy/MM/dd")
    }
    
    func testGetFormattedString() {
        let componentsDMY = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .DMY)
        XCTAssertEqual(componentsDMY.getFormattedString(), "01/12/2023")
        
        let componentsMDY = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .MDY)
        XCTAssertEqual(componentsMDY.getFormattedString(), "12/01/2023")
        
        let componentsYMD = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .YMD)
        XCTAssertEqual(componentsYMD.getFormattedString(), "2023/12/01")
    }
    
    func testGetFormatWithCustomSeparator() {
        let componentsDMY = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .DMY)
        XCTAssertEqual(componentsDMY.getFormat(withSeparator: "-"), "dd-MM-yyyy")
        
        let componentsMDY = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .MDY)
        XCTAssertEqual(componentsMDY.getFormat(withSeparator: "."), "MM.dd.yyyy")
        
        let componentsYMD = DateFormatComponents(dayValue: "01", monthValue: "12", yearValue: "2023", formatType: .YMD)
        XCTAssertEqual(componentsYMD.getFormat(withSeparator: "_"), "yyyy_MM_dd")
    }
}

