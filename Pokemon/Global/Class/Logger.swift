//
//  Logger.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

internal var pLoggerEnabled = true

public class Logger {

    private let moduleName: String

    public init(moduleName: String?) {
        self.moduleName = moduleName ?? "Message is Nil"
    }

    public func log(_ message: String) {
        if pLoggerEnabled {
            let dateString = Date().toString(input: .yyyyMMddHHmmss, output: .ddMMyyyyHHmmss) ?? ""
            print("[\(dateString)][\(moduleName)]: \(message)")
        }
    }
}
