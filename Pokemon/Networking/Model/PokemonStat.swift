//
//  PokemonEvolution.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public struct MyPokemon {
    public let status: PokemonStatus?
    public let nickname: String
    public var index: Int
    public var nextIndex: Int
    public var fibNumber: Int

    public init(status: PokemonStatus?, nickname: String, index: Int, nextIndex: Int, fibNumber: Int) {
        self.status = status
        self.nickname = nickname
        self.index = index
        self.nextIndex = nextIndex
        self.fibNumber = fibNumber
    }
}

public enum StatName: String, CaseIterable {
    case hp
    case attack
    case defense
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed
}

public struct PokemonStatus: Decodable {
    public var stat: [PokemonStat]
    public var types: [PokemonTypes]
    public var pokemonId: Int
    public var name: String
    public var height: Int
    public var weight: Int
    public let sprites: PokemonSprites
    public let moves: [PokemonMoves]

    public init(stat: [PokemonStat], types: [PokemonTypes], pokemonId: Int, 
                name: String, height: Int, weight: Int, sprites: PokemonSprites,
                moves: [PokemonMoves]) {
        self.stat = stat
        self.types = types
        self.pokemonId = pokemonId
        self.name = name
        self.height = height
        self.weight = weight
        self.sprites = sprites
        self.moves = moves
    }
}

public struct PokemonStat {
    let baseStat: Int
    let stat: Pokemon?

    private enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }

    public init(baseStat: Int, stat: Pokemon?) {
        self.baseStat = baseStat
        self.stat = stat
    }
}

extension PokemonStat: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseStat = try container.decodeIfPresent(Int.self, forKey: .baseStat) ?? 0
        stat = try container.decodeIfPresent(Pokemon.self, forKey: .stat)
    }
}

public struct PokemonHeight {
    public let height: Int

    private enum CodingKeys: String, CodingKey {
        case height
    }
}

extension PokemonHeight: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
    }
}

public struct PokemonWeight {
    public let weight: Int

    private enum CodingKeys: String, CodingKey {
        case weight
    }
}

extension PokemonWeight: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weight = try container.decodeIfPresent(Int.self, forKey: .weight) ?? 0
    }
}

public struct PokemonTypes {
    public let slot: Int
    public let type: Pokemon?

    private enum CodingKeys: String, CodingKey {
        case slot, type
    }
}

extension PokemonTypes: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        slot = try container.decodeIfPresent(Int.self, forKey: .slot) ?? 0
        type = try container.decodeIfPresent(Pokemon.self, forKey: .type)
    }
}

public struct PokemonSprites {
    public let img: URL?

    private enum CodingKeys: String, CodingKey {
        case img = "front_shiny"
    }
}

extension PokemonSprites: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        img = URL(string: try container.decodeIfPresent(String.self, forKey: .img) ?? "")
    }
}

public struct PokemonMoves {
    public let move: PokemonMovesDetail?

    private enum CodingKeys: String, CodingKey {
        case move
    }
}

extension PokemonMoves: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        move = try container.decodeIfPresent(PokemonMovesDetail.self, forKey: .move)
    }
}

public struct PokemonMovesDetail {
    public let name: String

    private enum CodingKeys: String, CodingKey {
        case name
    }
}

extension PokemonMovesDetail: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
