//
//  AppResponse.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public enum ResponseStatus: String, Decodable {

    case success
    case error
}

extension ResponseStatus: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "ok", "OK": self = .success
        case "error", "ERROR": self = .error
        default: return nil
        }
    }
}

public struct AppResponse<T: Decodable> {

    public let hasNextPage: Bool

    public let nextPage: Int
    public let nextLimit: Int

    public let previousPage: Int
    public let previousLimit: Int

    public let totalData: Int
    public let data: T?

    private enum CodingKeys: String, CodingKey {
        case count

        case next
        case previous

        case id
        case name
        case height
        case weight

        case types
        case stats

        case sprites

        case moves

        case data = "results"
    }

    public init(hasNextPage: Bool, nextPage: Int, nextLimit: Int, previousPage: Int, previousLimit: Int, totalData: Int, data: T?) {
        self.hasNextPage = hasNextPage
        self.nextPage = nextPage
        self.nextLimit = nextLimit
        self.previousPage = previousPage
        self.previousLimit = previousLimit
        self.totalData = totalData
        self.data = data
    }
}

extension AppResponse: Decodable {

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
                if let dataa = try container.decodeIfPresent(T.self, forKey: .data) {
                    data = dataa
                    hasNextPage = nextPage > -1
                    return
                }

                if let baseStats = try container.decodeIfPresent([PokemonStat].self, forKey: .stats),
                   let types = try container.decodeIfPresent([PokemonTypes].self, forKey: .types),
                   let id = try container.decodeIfPresent(Int.self, forKey: .id),
                   let name = try container.decodeIfPresent(String.self, forKey: .name),
                   let height = try container.decodeIfPresent(Int.self, forKey: .height),
                   let weight = try container.decodeIfPresent(Int.self, forKey: .weight),
                   let sprites = try container.decodeIfPresent(PokemonSprites.self, forKey: .sprites),
                   let moves = try container.decodeIfPresent([PokemonMoves].self, forKey: .moves) {
                    data = (PokemonStatus(stat: baseStats, types: types, pokemonId: id, name: name,
                                          height: height, weight: weight, sprites: sprites,
                                          moves: moves) as! T)
                    hasNextPage = nextPage > -1
                    return
                }

                data = nil
                hasNextPage = nextPage > -1
            } catch {
                data = nil
                hasNextPage = false
                pLogger.log("[JSON] Error: 3 \(error) | Type: \(T.self)")
            }
        } else {
            hasNextPage = false
            data = nil
        }
    }
}

public struct AppOffsetLimitResponse<T: Decodable>: Decodable {

    public let total: Int
    public let offset: Int
    public let limit: Int
    public let results: [T]?
}
