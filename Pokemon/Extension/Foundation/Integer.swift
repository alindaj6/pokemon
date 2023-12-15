//
//  Integer.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public enum ConvertToTimeType {
    case hourMinuteSecond
    case minuteSecond
}

public enum MultiplyType {
    case hundred
    case thousand
    case million
}

public extension Int {

    var toString: String {
        return String(self)
    }

    var toCurrency: String {
        return self.toString.currency
    }

    var toPositive: Int {
        if self < 0 {
            return self * -1
        }
        return self
    }

    // NOTE: just for time of day
    func convertToTime(type: ConvertToTimeType = .hourMinuteSecond, withSpace: Bool = false) -> String {
        let remainderDay = self%86400

        let hour = remainderDay/3600
        let remainderHour = remainderDay%3600

        let minute = remainderHour/60
        let second = remainderHour%60

        var timeConverted = ""
        if hour > 0 {
            let strHour = hour > 9 ? "\(hour)" : "0\(hour)"
            timeConverted = "\(timeConverted)\(strHour):"
        }
        let strMinute = minute > 9 ? "\(minute)" : "0\(minute)"
        timeConverted = "\(timeConverted)\(strMinute):"
        let strSecond = second > 9 ? "\(second)" : "0\(second)"
        timeConverted = "\(timeConverted)\(strSecond)"

        if hour == 0 {
            switch type {
            case .hourMinuteSecond:
                timeConverted = "00:\(timeConverted)"
            case .minuteSecond: break
            }
        }

        if withSpace {
            timeConverted = timeConverted.replacingOccurrences(of: ":", with: " : ")
        }

        return timeConverted
    }

    func convertToTimeWithFormat(_ format: String, andTimeZone timezone: TimeZone = TimeZone.current) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timezone
        let strTime = formatter.string(from: date)
        return strTime
    }

    func getDayOrdinal() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let anchorComponents = Calendar.current.dateComponents([.day], from: date)
        var day = anchorComponents.day == nil ? "" : "\(anchorComponents.day!)"
        switch day {
        case "1", "21", "31":
            day.append("st")
        case "2", "22":
            day.append("nd")
        case "3", "23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day
    }

    var epochToDatetime: String {
        if self == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }

    var toDate: Date? {
        return Date(timeIntervalSince1970: Double(self) / 1000)
    }

    func convertToStandardTime() -> TimeStandard {
        let day = self/86400
        let remainderDay = self%86400

        let hour = remainderDay/3600
        let remainderHour = remainderDay%3600

        let minute = remainderHour/60
        let second = remainderHour%60
        return TimeStandard(day: day, hour: hour, minute: minute, second: second)
    }

    var seconds: Int {
        return self
    }
    var minutes: Int {
        return self.seconds * 60
    }
    var hours: Int {
        return self.minutes * 60
    }
    var days: Int {
        return self.hours * 24
    }
    var weeks: Int {
        return self.days * 7
    }
    var months: Int {
        return self.weeks * 4
    }
    var years: Int {
        return self.months * 12
    }

    func isMultiplyOf(_ multiplyType: MultiplyType) -> Bool {
        switch multiplyType {
        case .hundred:
            return self % 100 == 0
        case .thousand:
            return self % 1000 == 0
        case .million:
            return self % 1000000 == 0
        }
    }
}

public struct TimeStandard {
    public let day: Int
    public let hour: Int
    public let minute: Int
    public let second: Int

    public var strDayPlusHour: String {
        let dayInHour = day * 24
        let value = dayInHour + hour
        return value > 9 ? "\(value)" : "0\(value)"
    }
    public var strDay: String {
        return day > 9 ? "\(day)" : "0\(day)"
    }
    public var strHour: String {
        return hour > 9 ? "\(hour)" : "0\(hour)"
    }
    public var strMinute: String {
        return minute > 9 ? "\(minute)" : "0\(minute)"
    }
    public var strSecond: String {
        return second > 9 ? "\(second)" : "0\(second)"
    }
}

// for package invoice
public extension Int {
    var toDecimalFormat: String {
        var stringtoConvert = String(self)
        if stringtoConvert.count <= 3 { return stringtoConvert }
        for i in stride(from: stringtoConvert.count, to: 0, by: -3) where i != stringtoConvert.count {
            stringtoConvert.insert(".",
                                   at: stringtoConvert.index(stringtoConvert.startIndex, offsetBy: i))
        }
        return stringtoConvert
    }
}

public extension Int {
    var kB: Double {
        return Double(self) / 1000.0
    }

    var KB: Double {
        return Double(self) / 1024.0
    }

    var mB: Double {
        return kB / 1000.0
    }

    var MB: Double {
        return KB / 1024.0
    }
}

public extension Int64 {
    var kB: Double {
        return (Double(self) / 1000.0).roundTo(places: 2)
    }

    var KB: Double {
        return (Double(self) / 1024.0).roundTo(places: 2)
    }

    var mB: Double {
        return (kB / 1000.0).roundTo(places: 2)
    }

    var MB: Double {
        return (KB / 1024.0).roundTo(places: 2)
    }
}

public extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

public extension Int {
    var digitCount: Int {
        return self.digits.count
    }
}

public extension Int {
    var usefulDigits: Int {
        var count = 0
        for _ in self.digits {
            count += 1
        }
        return count
    }
}
