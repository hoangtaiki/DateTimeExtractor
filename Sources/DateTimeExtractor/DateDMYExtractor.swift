//
//  DateTimeExtractor.swift
//  
//
//  Created by Harry Tran on 19/12/2023.
//

import Foundation

struct DateDMYExtractor: DateExtractable {
        
    private let regexes: [DateRegex] = [
        // `dd-MM-yy`, `dd-MM-yyyy`
        // `dd-MMM-yy`, `dd-MMM-yyyy`
        // `dd-MMMM-yy`, `dd-MMMM-yyyy`
        // `dd/MM/yy`, `dd/MM/yyyy`
        // `dd/MMM/yy`, `dd/MMM/yyyy`
        // `dd/MMMM/yy`, `dd/MMMM/yyyy`
        // `dd.MM.yy`, `dd.MM.yyyy`
        // `dd.MMM.yy`, `dd.MMM.yyyy`
        // `dd.MMMM.yy`, `dd.MMMM.yyyy`
        DateRegex(formatType: .DMY, pattern: "\\b(?:(?:31(\\/|-|\\.)(?:0?[13578]|1[02]|(?:jan(?:uary)?|mar(?:ch)?|may|jul(?:y)?|aug(?:ust)?|oct(?:ober)?|dec(?:ember)?)))\\1|(?:(?:29|30)(\\/|-|\\.)(?:0?[1,3-9]|1[0-2]|(?:jan(?:uary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?))\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b|\\b(?:29(\\/|-|\\.)(?:0?2|(?:feb(?:ruary)?))\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))\\b|\\b(?:0?[1-9]|1\\d|2[0-8])(\\/|-|\\.)(?:(?:0?[1-9]|(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch?)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?))|(?:1[0-2]|(?:oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b"),
        
        // `dd MMM yy`, `dd MMM yyy`
        // `dd MMMM yy`, `dd MMMM yyy`
        DateRegex(formatType: .DMY, pattern: "\\b(?:(?:31( )(?:jan(?:uary)?|mar(?:ch)?|may|jul(?:y)?|aug(?:ust)?|oct(?:ober)?|dec(?:ember)?))\\1|(?:(?:29|30)( )(?:jan(?:uary)?|mar(?:ch)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)\\2))(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b|\\b(?:29( )(?:feb(?:ruary)?)\\3(?:(?:(?:1[6-9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))\\b|\\b(?:0?[1-9]|1\\d|2[0-8])( )(?:(?:jan(?:uary)?|feb(?:ruary)?|mar(?:ch?)?|apr(?:il)?|may|jun(?:e)?|jul(?:y)?|aug(?:ust)?|sep(?:tember)?)|(?:oct(?:ober)?|nov(?:ember)?|dec(?:ember)?))\\4(?:(?:1[6-9]|[2-9]\\d)?\\d{2})\\b")
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
                    let formatComponents = DateFormatComponents(dayValue: dateComponents[0],
                                                                monthValue: dateComponents[1],
                                                                yearValue: dateComponents[2])
                    let format = ExtractedDateResult(originalString: matchedResult.string,
                                                     formatedString: dateComponents.joined(separator: "/"),
                                                     format: formatComponents.getFormatWithType(.DMY),
                                                     range: matchedResult.range)
                    dateStringFormats.insert(format)
                }
            }
        }
        
        return Array(dateStringFormats)
    }
}
