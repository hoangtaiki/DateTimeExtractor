//
//  DateMDYExtractor.swift
//  
//
//  Created by Harry Tran on 20/12/2023.
//

import Foundation

struct DateMDYExtractor: DateExtractable {
    
    private let regexes: [DateRegex] = [
        // mm-dd-yy, mm-dd-yyyy
        // mmm-dd-yy, mmm-dd-yyyy
        // mmmm-dd-yy, mmmm-dd-yyyy
        // mm/dd/yy, mm/dd/yyyy
        // mmm/dd/yy, mmm/dd/yyyy
        // mmmm/dd/yy, mmmm/dd/yyyy
        // mm.dd.yy, mm.dd.yyyy
        // mmm.dd.yy, mmm.dd.yyyy
        // mmmm.dd.yy and mmmm.dd.yyyy
        DateRegex(formatType: .MDY, pattern: "\\b(?:(?:(?:0?[13578]|1[02]|(?:jan(?:uary)?|mar(?:ch)?|may|jul(?:y)?|aug(?:ust)?|oct(?:ober)?|dec(?:ember)?)))(\\/|-|\\.)31\\1|(?:(?:0?[1,3-9]|1[0-2]|(?:jan(?:uary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)))(\\/|-|\\.)(?:29|30)\\2)(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b|\\b(?:(?:0?2|(?:feb(?:ruary)?))(\\/|-|\\.)29\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))\\b|\\b(?:(?:0?[1-9]|(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch?)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?))|(?:1[0-2]|(?:oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)))(\\/|-|\\.)(?:0?[1-9]|1\\d|2[0-8])\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b"),
        
        // `MMM dd yy`, `MMM dd yyy`
        // `MMMM dd yy`, `MMMM dd yyy`
        DateRegex(formatType: .MDY, pattern: "\\b(?:(?:(?:jan(?:uary)?|mar(?:ch)?|may|jul(?:y)?|aug(?:ust)?|oct(?:ober)?|dec(?:ember)?)( )31)\\1|(?:(?:jan(?:uary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)( )(?:29|30)\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b|\\b(?:(?:feb(?:ruary)?)( )29\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))\\b|\\b(?:(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch?)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?)|(?:oct(?:ober)?|nov(?:ember)?|dec(?:ember)?))( )(?:0?[1-9]|1\\d|2[0-8])\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b")
    ]
    
    func extractDateStringAndFormat(string: String) -> [ExtractedDateResult] {
        var dateStringFormats = Set<ExtractedDateResult>()
        
        for regex in regexes {
            let matchedResults = extractStringWithRegex(string: string, regexPattern: regex.pattern)
            
            if !matchedResults.isEmpty {
                for matchedResult in matchedResults {
                    let extractedString = matchedResult.string.trimmingCharacters(in: .whitespaces)
                    let separator = detectDateSeparator(string: matchedResult.string) ?? " "
                    let dateComponents = extractedString.components(separatedBy: separator)
                    let formatComponents = DateFormatComponents(dayValue: dateComponents[1],
                                                                monthValue: dateComponents[0],
                                                                yearValue: dateComponents[2],
                                                                formatType: .MDY)
                    let format = ExtractedDateResult(originalString: matchedResult.string,
                                                     range: matchedResult.range,
                                                     formatComponents: formatComponents)
                    dateStringFormats.insert(format)
                }
            }
        }
        
        return Array(dateStringFormats)
    }
}
