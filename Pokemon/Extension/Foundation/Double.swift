//
//  Double.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public extension Double {
    var ratingScore: Int {
        return Int(ceil(self))
    }
}

public extension Double {
    var toDecimalFormat: String {
        return Int(self).toDecimalFormat
    }
}

public extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

public extension Double {
    var toInt: Int {
        return Int(self)
    }

    var toString: String {
        return "\(self)"
    }

    var toCurrency: String {
        let stringValues = NSNumber(value: self).stringValue.split(separator: ".")
        if stringValues.isEmpty { return "" }
        if stringValues.count == 1 { return String(stringValues[0]).currency }
        if stringValues.count > 1 && String(stringValues[1]) == "0" {
            return "\(String(stringValues[0]).currency)"
        }
        return "\(String(stringValues[0]).currency),\(String(stringValues[1]))"
    }
}
