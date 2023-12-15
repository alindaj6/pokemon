//
//  Dictionary.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public extension Dictionary {
    var prettyPrint: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch let error {
            return ""
        }
    }

    fileprivate func merge(dict: [Key: Value]) -> [Key: Value] {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }

    func merges(dictionaries: [Dictionary<Key, Value>]) -> [Key: Value] {
        if dictionaries.isEmpty {
            return [Key: Value]()
        }

        var firstDict = self
        for dict in dictionaries {
            firstDict = firstDict.merge(dict: dict)
        }

        return firstDict
    }
}
