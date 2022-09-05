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
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
    func setDateFormat() -> String {
        guard let timeInterval = (self - Date()).day else { return "Wrong Format" }
        
        switch timeInterval {
        case let x where x >= 0 && x < 1: return toString()
        case let x where x >= 1 && x < 7: return toString(withFormat: "eeee")
        case let x where x >= 7: return toString(withFormat: "yyyy. MM. dd a hh:mm")
        default: return "Wrong Format"
        }

    }
    
}
