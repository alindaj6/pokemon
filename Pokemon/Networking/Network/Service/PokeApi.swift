//
//  PokeApi.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
import Moya

public enum PokeApi {
    case pokemons(offset: Int, limit: Int)
    case pokemonStat(name: String)

    case `catch`
    case release
    case rename(index: Int)
}

extension PokeApi: PokemonApi {
    public var baseURL: URL {
        switch self {
        case .pokemons:
            return self.getBaseURL()
        case .pokemonStat:
            return self.getBaseURL()
        case .catch, .release, .rename:
            return URL(string: "https://poketestapi-6yubapy6na-uc.a.run.app")!
        }
    }

    public var path: String {
        switch self {
        case .pokemons:
            return "pokemon"
        case .pokemonStat(let name):
            return "pokemon/\(name)"
        case .catch:
            return "catch"
        case .release:
            return "release"
        case .rename(let index):
            return "rename/\(index)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .pokemons(let offset, let limit):
            var params = [String: Any]()
            params["offset"] = offset
            params["limit"] = limit
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .pokemonStat, .catch, .release, .rename:
            return .requestPlain
        }
    }


}
