//
//  Dummy.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

/// A dummy struct to present value of data which we actually do not care
public struct Dummy: Decodable {
}

public struct Meta {
    public let code: Int
    public let message: String
    let debugInfo: String

    private enum CodingKeys: String, CodingKey {
        case code
        case message
        case debugInfo
    }

    public var `default`: Meta {
        return Meta(code: 0, message: "", debugInfo: "")
    }
}

extension Meta: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(Int.self, forKey: .code) ?? 0
        let m = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        debugInfo = try container.decodeIfPresent(String.self, forKey: .debugInfo) ?? ""
        message = m != "" ? m : debugInfo
    }
}

extension Meta {
    public var error: NSError {
        let error = NSError(
            domain: .errorServiceDomain,
            code: self.code,
            userInfo: [NSLocalizedDescriptionKey: self.message]
        )
        return error
    }
}
