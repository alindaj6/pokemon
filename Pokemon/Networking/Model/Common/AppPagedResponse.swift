//
//  AppPagedResponse.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public struct AppPagedResponse<T: Decodable> {

    public let hasNextPage: Bool

    public let nextPage: Int
    public let nextLimit: Int

    public let previousPage: Int
    public let previousLimit: Int

    public let totalData: Int
    public let data: [T]?

    private enum CodingKeys: String, CodingKey {
        case count

        case next
        case previous

        case stats
        case results
    }
}

extension AppPagedResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        totalData = (try? container.decodeIfPresent(Int.self, forKey: .count)) ?? 0

        let nextURL = try container.decodeIfPresent(String.self, forKey: .next) ?? ""
        if let next = URL(string: nextURL) {
            let resultParsing = next.parsing()
            nextPage = resultParsing.offset
            nextLimit = resultParsing.limit
        } else {
            nextPage = -1
            nextLimit = -1
        }

        let previousURL = try container.decodeIfPresent(String.self, forKey: .previous) ?? ""
        if let previous = URL(string: previousURL) {
            let resultParsing = previous.parsing()
            previousPage = resultParsing.offset
            previousLimit = resultParsing.limit
        } else {
            previousPage = -1
            previousLimit = -1
        }

        if T.self != Dummy.self {
            do {
                if let dataa = try container.decodeIfPresent([T].self, forKey: .results) {
                    data = dataa
                } else if let baseStats = try container.decodeIfPresent([T].self, forKey: .stats) {
                    data = baseStats
                } else {
                    data = nil
                }
                hasNextPage = nextPage > -1
            } catch {
                data = nil
                hasNextPage = false
                pLogger.log("[JSON] Error: 2 \(error) | Type: \(T.self)")
            }
        } else {
            data = nil
            hasNextPage = false
        }
    }
}

extension URL {
    func parsing() -> (offset: Int, limit: Int) {
        var offset = -1
        var limit = -1

        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                if item.name == "offset" {
                    offset = item.value?.toInt ?? -1
                } else if item.name == "limit" {
                    limit = item.value?.toInt ?? -1
                }
            }
        }

        return (offset, limit)
    }
}
