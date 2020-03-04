//
//  Formatter+Extension.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Int {
    var formattedWithSeperator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Localify.shared.languageIdentifier)
        formatter.dateFormat = format
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let stringDate = formatter.string(from: self)
        
        return stringDate
    }
    
    func toStringUTC(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Localify.shared.languageIdentifier)
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let stringDate = formatter.string(from: self)
        
        return stringDate
    }
    
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            
            return self.addingTimeInterval(localOffeset - targetOffset)
        }
        return nil
    }
    
    func getCurrentDayTime() -> (String, Int, Int) {
        let weekdays = [
            "sunday",
            "monday",
            "tuesday",
            "wednesday",
            "thursday",
            "friday",
            "saturday",
        ]
        let calendar = Calendar.current
        
        // 1 being Sunday and 7 being Saturday
        let day = calendar.component(.weekday, from: self)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        
        return (weekdays[day - 1], hour, minute)
    }
    
    func toTimeDeviceString() -> String {
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale: Locale.current)!
        if formatter.contains("a") {
            return self.toString(format: "hh:mm a")
        } else {
            return self.toString(format: "HH:mm")
        }
    }
    
    func calculateTimeFromToday() -> String {
        func isDateInYear() -> Bool {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let year = formatter.string(from: self)
            
            let yearToday = Calendar.current.component(.year, from: Date())
            
            return Int(year) == yearToday
        }
        
        let calendar = Calendar.current
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale: Locale.current)!
        if calendar.isDateInToday(self) {
            return formatter.contains("a") ? self.toString(format: "hh:mm a") : self.toString(format: "HH:mm")
        } else if calendar.isDateInYesterday(self) {
            return Localify.get("home.label.yesterday")
        } else if !calendar.isDateInTomorrow(self) {
            return formatter.contains("a") ? self.toString(format: "dd/MM") : self.toString(format: "dd/MM")
        } else if isDateInYear() {
            return formatter.contains("a") ? self.toString(format: "dd/MM") : self.toString(format: "dd/MM")
        } else {
            return formatter.contains("a") ? self.toString(format: "dd/MM/yyyy") : self.toString(format: "dd/MM/yyyy")
        }
    }
    
    func calculateFromCurrentTime() -> String {
        let datetime = Date()
        let formatter = DateFormatter()
        var stringHour = ""
        
        formatter.dateFormat = "yyyy-MM-dd"
        if formatter.string(from: datetime) == formatter.string(from: self) {
            formatter.dateFormat = "HH"
            if formatter.string(from: datetime) == formatter.string(from: self) {
                formatter.dateFormat = "mm"
                let currentMinute = formatter.string(from: datetime)
                let stringMinute = formatter.string(from: self)
                let interval = abs(Int(currentMinute)! * 60 - Int(stringMinute)! * 60) / 60
                if interval <= 30 {
                    stringHour = "\(interval)m ago"
                }
            } else {
                formatter.dateFormat = "HH:mm"
                stringHour = formatter.string(from: self)
            }
        } else {
            formatter.dateFormat = "HH:mm"
            stringHour = formatter.string(from: self)
        }
        
        return stringHour
    }
    
    func isDateInSameDay(asDate: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: asDate)
    }
}
