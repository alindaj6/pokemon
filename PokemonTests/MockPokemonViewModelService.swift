//
//  MockPokemonViewModelService.swift
//  PokemonTests
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
@testable import Pokemon

final class MockPokemonViewModelService: PokemonViewModelServiceProtocol {

    var resultPokemons: Result<AppResponse<[Pokemon]>, Error>!
    var resultPokemonStat: Result<PokemonStatus, Error>!

    func getPokemons(offset: Int, limit: Int, completion: @escaping ((Result<AppResponse<[Pokemon]>, Error>) -> Void)) {
        completion(resultPokemons)
    }

    func getPokemonStat(name: String, completion: @escaping ((Result<PokemonStatus, Error>) -> Void)) {
        completion(resultPokemonStat)
    }
}
