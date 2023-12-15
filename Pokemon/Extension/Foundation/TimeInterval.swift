//
//  TimeInterval.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public extension TimeInterval {
    var millisecond: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    var second: Int {
        return Int(self) % 60
    }
    var minute: Int {
        return (Int(self) / 60 ) % 60
    }
    var hour: Int {
        return Int(self) / 3600
    }
    var stringTime: String {
        if hour != 0 {
            return "\(hour)h \(minute)m \(second)s"
        } else if minute != 0 {
            return "\(minute)m \(second)s"
        } else if millisecond != 0 {
            return "\(second)s \(millisecond)ms"
        } else {
            return "\(second)s"
        }
    }
}

public extension DispatchTimeInterval {
    func toDouble() -> Double {
        var result: Double = 0

        switch self {
        case .seconds(let value):
            result = Double(value)
        case .milliseconds(let value):
            result = Double(value)*0.001
        case .microseconds(let value):
            result = Double(value)*0.000001
        case .nanoseconds(let value):
            result = Double(value)*0.000000001
        default:
            result = 0
        }

        return result
    }
}
