//
//  PokemonApi.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
import Moya

public protocol VersionedApi {

    var version: String { get }
}

public protocol TimeoutApi {

    var timeout: DispatchTimeInterval { get }
}

public protocol PokemonApi: TargetType, TimeoutApi, VersionedApi {}

public extension PokemonApi {
    var timeout: DispatchTimeInterval { return .seconds(30) }

    var version: String { return "" }

    var headers: [String: String]? {
        return self.getHeaders()
    }
}


internal extension PokemonApi {

    func getBaseURL(base: String = "") -> URL {
        let base = base.isEmpty ? "" : "/\(base)"
        return URL(string: "https://pokeapi.co/api/v2\(base)")!
    }

    func getHeaders(headers: [String: String]? = nil) -> [String: String]? {
        var params = [String: String]()
        var defaultHeaders = [String: String]()

        if let headers {
            defaultHeaders = defaultHeaders.merges(dictionaries: [headers])
        }

        params["Content-Type"] = "application/json"
        params["X-Device-Type"] = "ios"
        defaultHeaders = defaultHeaders.merges(dictionaries: [params])

        return defaultHeaders
    }

    func getDefaultEncoding() -> ParameterEncoding {
        switch self.method {
        case .post, .put: return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
}
