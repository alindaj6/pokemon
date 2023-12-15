//
//  Date.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public enum CalendarComponent {
    case day
    case hour
    case minute
    case second
}

public enum TimeWaitingStatus {
    case upcoming(time: Int) // before than waiting time
    case inTime(time: Int)
    case passed(time: Int) // after than waiting time
}

public enum ClockFormat {
    case twentyFourHour
    case twelveHour
}

public extension Date {

    func getDates(daysBackward backward: Int, daysForward forward: Int) -> [String] {
        var result = [String]()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterPrefStyle.Output.yyyyMMdd.rawValue
        let daysBackward = backward > 0 ? backward * -1 : backward
        let daysForward = forward < 0 ? forward * -1 : forward
        for i in daysBackward...0 {
            var targetDay: Date
            targetDay = Calendar.current.date(byAdding: .day, value: i, to: self)!
            result += [formatter.string(from: targetDay)]
        }
        for i in 1...daysForward {
            var targetDay: Date
            targetDay = Calendar.current.date(byAdding: .day, value: i, to: self)!
            result += [formatter.string(from: targetDay)]
        }
        return result
    }

    func addDayToDate(count: Int) -> [String] {
        var result = [String]()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterPrefStyle.Output.yyyyMMdd.rawValue
        let counts = count
        for i in 0...counts {
            var targetDay: Date
            targetDay = Calendar.current.date(byAdding: .day, value: i, to: self)!
            result += [formatter.string(from: targetDay)]
        }
        return result
    }

    func isDateIn(days: Int, inputTypeDate: DateFormatterPrefStyle.Input) -> Bool {
        var result = false
        var endDate = [String.SubSequence]()

        let today = Date()
        let nextDays = today.addDayToDate(count: days)

        if let stringDate = self.toString(input: inputTypeDate, output: .yyyyMMddHHmmss) {
            endDate = stringDate.split(separator: " ")
            for date in nextDays where date.contains(endDate[0]) {
                result = true
            }
        }
        return result
    }

    func toString(input: DateFormatterPrefStyle.Input = .yyyyMMddHHmmss,
                  output: DateFormatterPrefStyle.Output = .ddMMyyyy) -> String? {

        let formatter = DateFormatter()

        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = input.rawValue

        // convert your string to date
        let yourDate = formatter.date(from: formatter.string(from: self))

        // then again set the date format whhich type of output you need
        formatter.dateFormat = output.rawValue

        guard let dateString = yourDate else { return nil }
        return formatter.string(from: dateString)
    }

    func toStringWithTimezone(offsetUTC: String = "UTC",
                              input: DateFormatterPrefStyle.Input = .yyyyMMddHHmmss,
                              output: DateFormatterPrefStyle.Output = .ddMMyyyy) -> String? {

        let formatter = DateFormatter()

        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = input.rawValue

        // convert your string to date
        let yourDate = formatter.date(from: formatter.string(from: self))

        // then again set the date format whhich type of output you need
        formatter.dateFormat = output.rawValue
        formatter.timeZone = TimeZone(abbreviation: offsetUTC)

        guard let dateString = yourDate else { return nil }
        return formatter.string(from: dateString)
    }

    fileprivate func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!
        return TimeInterval(dateSeconds)
    }

    var clockFormat: ClockFormat {
        let formatString = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        if formatString.contains("a") {
            return .twelveHour
        }
        return .twentyFourHour
    }

    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }

//    var timeAgoSinceNow: String {
//        let calendar = NSCalendar.current
//        let unitFlags = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfYear, .month, .year])
//        let components = calendar.dateComponents(unitFlags, from: self, to: Date())
//        let yesterday = self.addingTimeInterval(-3600 * 24)
//        let isYesterday = calendar.dateComponents([.day], from: yesterday).day!
//            == calendar.dateComponents([.day], from: self).day!
//
//        if components.year! >= 2 {
//            return String(format: "time.interval.years.ago".localized, components.year!)
//        }
//        if components.year! >= 1 {
//            return String(format: "time.interval.year.ago".localized)
//        }
//        if components.month! >= 2 {
//            return String(format: "time.interval.months.ago".localized, components.month!)
//        }
//        if components.month! >= 1 {
//            return String(format: "time.interval.month.ago".localized)
//        }
//        if components.weekOfYear! >= 2 {
//            return String(format: "time.interval.weeks.ago".localized, components.weekOfYear!)
//        }
//        if components.weekOfYear! >= 1 {
//            return String(format: "time.interval.week.ago".localized)
//        }
//        if components.day! >= 2 {
//            return String(format: "time.interval.days.ago".localized, components.day!)
//        }
//        if isYesterday {
//            return String(format: "time.interval.day.ago".localized)
//        }
//        if components.hour! >= 2 {
//            return String(format: "time.interval.hours.ago".localized, components.hour!)
//        }
//        if components.hour! >= 1 {
//            return String(format: "time.interval.hour.ago".localized)
//        }
//        if components.minute! >= 2 {
//            return String(format: "time.interval.minutes.ago".localized, components.minute!)
//        }
//        if components.minute! >= 1 {
//            return String(format: "time.interval.minute.ago".localized)
//        }
//        if components.second! >= 3 {
//            return String(format: "time.interval.seconds.ago".localized, components.second!)
//        }
//        return String(format: "time.interval.second.ago".localized)
//    }

    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }

    var toTimeInterval: TimeInterval {
        return self.timeIntervalSince1970
    }

    var toIntTimeInterval: Int? {
        // convert to Integer
        return Int(self.timeIntervalSince1970)
    }

    var toTimeIntervalMiliSeconds: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    /**
     *To Count day, minute, second or etc between 2 different date*

     ex: if you want count between date by day, you should use .day as calendarComponent
     ex: if you want count between date by second, you should use .second as calendarComponent

     - Parameters:
        - component: CalendarComponent
        - start: The Start Date to Compare
        - end: The End Date to Compare

     - Returns:
     Int?
     */
    func differentIn(_ component: CalendarComponent, with compareDate: Date) -> Int? {
        let calendar = Calendar.current
        let calendarComponent: Calendar.Component?
        let components: DateComponents?

        switch component {
        case .day:
            calendarComponent = .day
        case .hour:
            calendarComponent = .hour
        case .minute:
            calendarComponent = .minute
        case .second:
            calendarComponent = .second
        }

        switch component {
        case .day:
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: self)
            let date2 = calendar.startOfDay(for: compareDate)
            components = calendar.dateComponents([calendarComponent!], from: date1, to: date2)
        default:
            components = Calendar.current.dateComponents([calendarComponent!], from: self, to: compareDate)
        }

        switch component {
        case .day:
            return components?.day
        case .hour:
            return components?.hour
        case .minute:
            return components?.minute
        case .second:
            return components?.second
        }
    }
}

public extension Date {
//    var day: String {
//        // returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
//        if let value = Calendar.current.dateComponents([.weekday], from: self).weekday {
//            switch value {
//            case 1:
//                return "global_calendar_day_sunday".localized
//            case 2:
//                return "global_calendar_day_monday".localized
//            case 3:
//                return "global_calendar_day_tuesday".localized
//            case 4:
//                return "global_calendar_day_wednesday".localized
//            case 5:
//                return "global_calendar_day_thursday".localized
//            case 6:
//                return "global_calendar_day_friday".localized
//            case 7:
//                return "global_calendar_day_saturday".localized
//            default:
//                return ""
//            }
//        }
//        return ""
//    }

//    var getDay: String {
//        var dateString = ""
//
//        if self == Date() {
//            let time = self.toString(input: .yyyyMMddHHmmssZZZZ, output: .HHmm) ?? ""
//            dateString = "Hari Ini, \(time)"
//        } else {
//            let datee = self.toString(input: .yyyyMMddHHmmssZZZZ, output: .ddMMMyyyy) ?? ""
//            dateString = "\(self.day), \(datee)"
//        }
//
//        return dateString
//    }
}

public extension Date {
    func findDateDiff(date1: Date, date2: Date) -> String {
        let interval = date2.timeIntervalSince(date1)
        let hour = interval / 3600
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let intervalInt = Int(interval)
        return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
    }
}

public extension Date {
    func checkWaitingStatus(inSecond: Int) -> TimeWaitingStatus {
        let secondDiff = inSecond

        guard let timeInterval = self.toIntTimeInterval
            else { return .upcoming(time: 0) }

        guard let now = Date().toIntTimeInterval
            else { return .upcoming(time: 0) }

        let timeRemaining = (now - timeInterval) * (-1)
        if timeRemaining > secondDiff {
            return .upcoming(time: timeRemaining)
        }
        if timeRemaining <= 0 {
            return .passed(time: timeRemaining * -1)
        }
        return .inTime(time: timeRemaining)
    }
}

public extension Date {
    func addOrSubstract(component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }

    // Only Date means not include time
    func totalDistance(to date: Date, resultIn component: Calendar.Component, onlyDate: Bool = false) -> Int? {
        var fromDate = self
        var toDate = date
        if onlyDate {
            fromDate = fromDate.startOfDay
            toDate = toDate.startOfDay
        }
        return Calendar.current.dateComponents([component], from: fromDate, to: toDate).value(for: component)
    }

    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return self.compare(with: date, only: component) == 0
    }
}

public extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}

public extension Date {
    init(_ dateString: String, input: DateFormatterPrefStyle.Input) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = input.rawValue
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval: 0, since: date)
    }
}

public extension Date {
    func getMonthAndYearBetween(to end: Date, calendarComponent: Calendar.Component = .month) -> [Date] {
        var allDates: [Date] = []
        let start: Date = self
        guard start <= end else { return allDates }

        let calendar = Calendar.current
        let month = calendar.dateComponents([calendarComponent], from: start, to: end).month ?? 0

        for i in 0...month {
            if let date = calendar.date(byAdding: calendarComponent, value: i, to: start) {
                allDates.append(date)
            }
        }
        return allDates
    }

    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        if date <= toDate {
            while date <= toDate {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                date = newDate
            }
        } else {
            while toDate <= date {
                dates.append(date)
                guard let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date) else { break }
                date = newDate
            }
        }
        return dates
    }
}

public struct DateFormatterPrefStyle {

    public enum Input: String {

        case ddMMMyyyy = "dd MMM yyyy"

        case ddMMyyyy = "dd-MM-yyyy"
        case yyyyMMdd = "yyyy-MM-dd"
        case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case MMMddyyyy = "MMM dd, yyyy"
        case yyyyMMddHHmmssZ = "yyyy-MM-dd HH:mm:ss Z"
        case yyyyMMddHHmmssZZZZ = "yyyy-MM-dd HH:mm:ss ZZZZ"
        case yyyyMMddhhmmssaZZZZ = "yyyy-MM-dd hh:mm:ss a zzzz"
        case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"

        case HHmm = "HH:mm"

        case MMMMyyyy = "MMMM-yyyy"
        case yyyyMMMMdd = "yyyy-MMMM-dd"
    }

    public enum Output: String {

        case d = "d"
        case dd = "dd"
        case EEEE = "EEEE"
        case M = "M"
        case yyyy = "yyyy"
        case MMMdd = "MMM dd"
        case MMdd = "MM-dd"
        case ddMMM = "dd MMM"
        case MMMyyyy = "MMM yyyy"
        case MMyyyy = "MM-yyyy"
        case yyyyMMddSlash = "yyyy/MM/dd"
        case yyyyMMdd = "yyyy-MM-dd"
        case ddMMMyyyy = "dd MMM yyyy"
        case ddMMyyyy = "dd-MM-yyyy"
        case ddMMyyyyHHmmss = "dd-MM-yyyy HH:mm:ss"
        case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case HHmma = "HH:mm a"
        case MMMdyyyy = "MMM d, yyyy"
        case HHmm = "HH:mm"
        case HHmm_V2 = "HH.mm"
        case hhmma = "hh:mm a"
        case EEEEdMMMyyyyhhmma = "EEEE, d MMM yyyy | hh:mm a"
        case EEEEdMMMyyyy = "EEEE, d MMM yyyy"
        case EEEEdMMMMyyyy = "EEEE, d MMMM yyyy"
        case MMMddyyyyHHmm = "MMM dd, yyyy | HH.mm"
        case MMMddyyyyHHmma = "MMM dd, yyyy | HH.mm a"
        case HHmmss = "HH:mm:ss"
        case ddMMMMyyyy = "dd MMMM yyyy"
        case ddMMMMyyyyHHmmss = "dd MMMM yyyy HH:mm:ss"
        case MMMddyyyy = "MMM dd, yyyy"
        case mss = "m:ss"
        case ddMMyyyy_SLASH = "dd/MM/yyyy"
        case ddMMMMyyyyHHmma = "dd MMMM yyyy | HH.mm a"

        case MMMMddyyyy = "MMMM dd, yyyy 'at'"
        case MMMMddyyyyHHmm = "MMMM dd, yyyy 'at' HH:mm"
        case mmss = "mm:ss"
        case ddMyyyy = "dd/M/yyyy"

        case dMMMMyyyyhhmma = "d MMMM yyyy\nhh.mm a"
        case ddMMMyyyyhhmmm = "dd MMM yyyy | hh.mm"
        case ddMMMyyyyHHmmss = "dd MMM yyyy HH:mm:ss"

        case MMyyyy_SLASH = "MM/yyyy"
        case MMMMyyyy = "MMMM yyyy"
        case MMMM = "MMMM"

        case ddMMMyyyyHHmm = "dd MMM yyyy, HH:mm"
    }
}
