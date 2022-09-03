//
//  Date+Extension.swift
//  ProjectMemo
//
//  Created by Junhee Yoon on 2022/09/01.
//

import Foundation

extension Date {
    
    func toString(withFormat format: String = "a hh:mm") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    func setDateFormat() -> String {
        let timeInterval = Date().timeIntervalSince(self)
        
        switch timeInterval {
        case let x where x >= 0 && x < 86400: return toString()
        case let x where x >= 86400 && x < 86400 * 7: return toString(withFormat: "eeee")
        case let x where x >= 86400 * 7: return toString(withFormat: "yyyy. MM. dd a hh:mm")
        default: return "Wrong Format"
        }

    }
    
}
