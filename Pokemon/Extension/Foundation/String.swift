//
//  String.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
import UIKit

// swiftlint:disable file_length
public extension String {

    func isValidEmail(strictFilter strict: Bool = true) -> Bool {
        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,64}"
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = strict ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }

    var isValidDigit: Bool {
        let digitRegex = "^[0-9]+$"
        let digitTest = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        return digitTest.evaluate(with: self)
    }

    var hasSpecialCharacter: Bool {
        let normalCharacterRegex = "^[a-zA-Z0-9]+$"
        let normalCharacterText = NSPredicate(format: "SELF MATCHES %@", normalCharacterRegex)
        return !normalCharacterText.evaluate(with: self)
    }

    var isValidPassword: Bool {
        let normalCharacterRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}$"
        let normalCharacterText = NSPredicate(format: "SELF MATCHES %@", normalCharacterRegex)
        return normalCharacterText.evaluate(with: self)
    }

    var isAlphaNumeric: Bool {
        let alphaNumericRegEx = "^[a-zA-Z0-9 ]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphaNumericRegEx)
        return predicate.evaluate(with: self)
    }

    var isAlphabet: Bool {
        let alphaRegEx = "^[a-zA-Z ]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphaRegEx)
        return predicate.evaluate(with: self)
    }

    var isAlphaLowercased: Bool {
        let alphaLowercasedRegEx = "^[a-z ]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphaLowercasedRegEx)
        return predicate.evaluate(with: self)
    }

    var isAlphaUppercased: Bool {
        let alphaUppercasedRegEx = "^[A-Z ]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", alphaUppercasedRegEx)
        return predicate.evaluate(with: self)
    }

    var isNumeric: Bool {
        let numericRegEx = "^[0-9 ]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numericRegEx)
        return predicate.evaluate(with: self)
    }

    var currency: String {
        let text = self.replacingOccurrences(of: ".", with: "")
        return "\("global_currency".localized) \(text.add(".", forEvery: 3))"
    }
}

public extension String {
    func standarizePhoneNumber() -> String {
        let phoneNumber = self

        let start = String.Index.init(utf16Offset: 1, in: phoneNumber)
        let end = String.Index.init(utf16Offset: phoneNumber.count, in: phoneNumber)

        let phoneStandard = String(phoneNumber[start..<end])
        return phoneStandard
    }

    var verifyURL: Bool {
        // create URL instance
        if let url = self.url {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    var phoneNumberMasking: String {
        if self.isEmpty {
            return ""
        }

        let phoneNumberDropLast = self.dropLast(3)
        let phoneNumberAddXXX = phoneNumberDropLast.toString
            .appending("XXX").separate(with: "-", every: 4)

        return phoneNumberAddXXX
    }
}

public extension String {

    /// Inner comparison utility to handle same versions with different length. (Ex: "1.0.0" & "1.0")
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionComponents.count - targetComponents.count

        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: versionDelimiter)
                .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
        }
        return result
    }

    func isVersion(equalTo targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedSame
    }

    func isVersion(greaterThan targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedDescending
    }

    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) != .orderedAscending
    }

    func isVersion(lessThan targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedAscending
    }

    func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) != .orderedDescending
    }

    var toBase64: String {
        return Data(self.utf8).base64EncodedString()
    }

    func getDateWithDay(input: DateFormatterPrefStyle.Input = .yyyyMMdd,
                        output: DateFormatterPrefStyle.Output = .yyyyMMdd,
                        isThreeLetterDay: Bool) -> String {
        var result = ""
        var weekdays = [Int: String]()
        if isThreeLetterDay {
            weekdays = [1: "global_calendar_day_sun".localized,
                        2: "global_calendar_day_mon".localized,
                        3: "global_calendar_day_tue".localized,
                        4: "global_calendar_day_wed".localized,
                        5: "global_calendar_day_thu".localized,
                        6: "global_calendar_day_fri".localized,
                        7: "global_calendar_day_sat".localized]
        } else {
            weekdays = [1: "global_calendar_day_sunday".localized,
                        2: "global_calendar_day_monday".localized,
                        3: "global_calendar_day_tuesday".localized,
                        4: "global_calendar_day_wednesday".localized,
                        5: "global_calendar_day_thursday".localized,
                        6: "global_calendar_day_friday".localized,
                        7: "global_calendar_day_saturday".localized]
        }

        // Original Format Of Date
        let originFormatter = DateFormatter()
        originFormatter.dateFormat = input.rawValue

        // Result Date After Change To Custom Format
        let date = originFormatter.date(from: self)
        let toFormatter = DateFormatter()
        toFormatter.dateFormat = output.rawValue

        guard let datee = date,
              let todayDate = toFormatter.date(from: toFormatter.string(from: datee)) else {
            return result
        }

        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        let day = weekdays[weekDay]
        result = "\(day!), \(toFormatter.string(from: date!))"
        return result
    }

    func toDate(input: DateFormatterPrefStyle.Input) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = input.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        return date
    }

    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter
    }

    var trailingSpacesTrimmed: String {
        var newString = self
        while newString.last?.isWhitespace == true {
            newString = String(newString.dropLast())
        }
        return newString
    }

    var getStrikeThroughStyle: NSAttributedString {
        let strokeEffect: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        let strokeString = NSAttributedString(string: self, attributes: strokeEffect)
        return strokeString
    }

    var url: URL? {
        return URL(string: self)
    }
}

public extension String {
    var checkURLSchemeSupported: (Bool, urlString: String) {
        if self.checkURLhasHTTPS { return (true, self.replacingOccurrences(of: " ", with: "%20")) }
        if self.checkURLhasHTTP { return (true, self.replacingOccurrences(of: " ", with: "%20")) }
        var urlString = self
        if !self.lowercased().hasPrefix("http://") {
            urlString = "http://\(urlString)"
        }
        return (false, "\(urlString.replacingOccurrences(of: " ", with: "%20"))")
    }
    var checkURLhasHTTPS: Bool {
        return self.lowercased().contains("https")
    }
    var checkURLhasHTTP: Bool {
        return self.lowercased().contains("http")
    }
}

public extension String {
    func localized(values: [String] = [""]) -> String {
        return String(format: NSLocalizedString(self, comment: ""),
                      arguments: values)
    }

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    var imageFromBase64: UIImage? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: data)
    }

    var removedSpecialCharacter: String {
        let text = self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
        return text
    }
}

public extension String {
    var htmlToAttributedString: NSAttributedString? {
        let aux = "<span style=\"font-family: GothamRounded-Book; font-size: 12\">\(self)</span>"

        guard let data = aux.data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "font-size: \(font.pointSize)pt !important;" +
            "color: #\(color.hexString!) !important;" +
            "font-family: \(font.familyName) !important;" +
            "margin-bottom: 0px;" +
            "}</style> \(self)"

            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            pLogger.log("error: \(error)")
            return nil
        }
    }

    func removeCharacterOfString(of tag: String) -> String {
        let text = self.replacingOccurrences(of: tag, with: "")
        return text
    }

    func htmlToMutableAttributedString(focusedFont: UIFont? = nil) -> NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            let nsMutableAttributedString = try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)

            if let focusedFontt = focusedFont {
                //                guard let rangeIndex = self.range(of: self) else {
                //                    return nil
                //                }
                let nsRange = self.nsRange(from: self.startIndex..<self.endIndex)
                let fontAttribute = [NSAttributedString.Key.font: focusedFontt]
                nsMutableAttributedString.addAttributes(fontAttribute, range: nsRange)
            }
            return nsMutableAttributedString
        } catch {
            return NSMutableAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

public extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
}

public extension String {
    var minPhonenumberQualify: Bool {
        return self.count > 4
    }

    var maxPhonenumberQualify: Bool {
        return self.count < 16
    }

    func standardize(phoneNumber phone: String?) -> String {
        guard let phoneNumber = phone else {
            return ""
        }
        var phoneNumberr = phoneNumber
        if phoneNumberr.contains("+") {
            phoneNumberr = phoneNumberr.replacingOccurrences(of: "+", with: "")
        }
        if phoneNumberr.contains("62") {
            phoneNumberr = phoneNumberr.replacingOccurrences(of: "62", with: "")
        }
        return phoneNumberr
    }
}

public extension String {
    // swiftlint:disable unused_enumerated
    fileprivate func replacing(text: String, replaceWith: Character) -> String {
        var newText = text
        for (index, _) in newText.enumerated() where index > 0 {
            var chars = Array(newText)     // gets an array of characters
            chars[index] = replaceWith
            newText = String(chars)
        }
        return newText
    }
}

public extension String {
    var toDictionary: [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(
                    with: data, options: .mutableContainers) as? [String: Any]
            } catch {
                pLogger.log("Something went wrong")
            }
        }
        return nil
    }
}

public extension String {
    func focusAttributeOfString(focusedStr: String,
                                colorFocused: UIColor,
                                focusedFont: UIFont? = nil,
                                underlineStyle: Bool = false) -> NSAttributedString? {
        guard let rangeIndex = self.range(of: focusedStr) else {
            return nil
        }
        let nsRange = self.nsRange(from: rangeIndex)
        let attributeStr = NSMutableAttributedString(string: self)
        attributeStr.addAttributes([.foregroundColor: colorFocused], range: nsRange)

        if let focusedFontt = focusedFont {
            let fontAttribute = [NSAttributedString.Key.font: focusedFontt]
            attributeStr.addAttributes(fontAttribute, range: nsRange)
        }

        if underlineStyle {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            attributeStr.addAttributes(underlineAttribute, range: nsRange)
        }

        return attributeStr
    }
}

public extension String {
    func add(_ limiter: Character, forEvery at: Int) -> String {
        var stringtoConvert = self
        if stringtoConvert.count <= at { return stringtoConvert }
        for i in stride(from: stringtoConvert.count, to: 0, by: (at * -1)) where i != stringtoConvert.count {
            stringtoConvert.insert(limiter,
                                   at: stringtoConvert.index(stringtoConvert.startIndex, offsetBy: i))
        }
        return stringtoConvert
    }

    func separate(with separator: String, every: Int) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
        }.joined(separator: separator))
    }
}

public extension String {
    var getFirstLastName: (firstname: String, lastName: String) {
        let names = self.split(separator: " ")
        if names.isEmpty { return ("", "") }
        if names.count == 1 { return (String(names.first ?? ""), "") }
        let firstName = String(names.first ?? "")
        var lastName = ""
        for (index, namess) in names.enumerated() where index != 0 {
            lastName += "\(String(namess)) "
        }
        return (firstName, lastName)
    }
}

public extension String.SubSequence {
    var toString: String {
        return String(self)
    }
}

public extension String {
    var toInt: Int? {
        return Int(self)
    }
}

public enum AppUpdateType {
    case mandatory
    case optional

    case unknown
}

public enum AppUpdateStatus {
    case needUpdate(type: AppUpdateType)
    case noNeedUpdate

    case unknown
}

public enum AppVersionStatus {
    case notLatest
    case latest

    case unknown
}

public extension String {
  /*
   Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
   - Parameter length: Desired maximum lengths of a string
   - Parameter trailing: A 'String' that will be appended after the truncation.

   - Returns: 'String' object.
  */
  func trunc(length: Int = 200, trailing: String = "…") -> String {
    return (self.count > length) ? self.prefix(length) + trailing : self
  }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = range(of: substring, options: options,
                                range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex,
                                locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
}

public extension String {
    func isCharAllowed(characterSet allowedCharacters: Foundation.CharacterSet) -> Bool {
        let unwantedStr = self.trimmingCharacters(in: allowedCharacters)
        return unwantedStr.count == 0
    }
}

public extension String {
    func shorted(to symbols: Int) -> String {
        guard self.count > symbols else {
            return self
        }
        return self.prefix(symbols) + "..."
    }
}
