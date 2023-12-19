//
//  File.swift
//  
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

struct DateRegex {
    enum PatternType {
        case DMY
        case MDY
        case YMD
    }
    
    let type: PatternType
    let pattern: String
}

