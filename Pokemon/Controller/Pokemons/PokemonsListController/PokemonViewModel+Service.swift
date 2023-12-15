//
//  PokemonViewModel+Service.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

protocol PokemonViewModelServiceProtocol: AnyObject {
    func getPokemons(offset: Int, limit: Int, completion: @escaping ((Result<AppResponse<[Pokemon]>, Error>) -> Void))
    func getPokemonStat(name: String, completion: @escaping ((Result<PokemonStatus, Error>) -> Void))
}

final class PokemonViewModelService: PokemonViewModelServiceProtocol {
    let providerPoke = ServiceHelper.provider(for: PokeApi.self)

    func getPokemons(offset: Int, limit: Int, completion: @escaping ((Result<AppResponse<[Pokemon]>, Error>) -> Void)) {
        providerPoke.request(.pokemons(offset: offset, limit: limit)) { result in
            switch result.map(to: [Pokemon].self) {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPokemonStat(name: String, completion: @escaping ((Result<PokemonStatus, Error>) -> Void)) {
        providerPoke.request(.pokemonStat(name: name)) { result in
            switch result.map(to: PokemonStatus.self) {
            case .success(let response):
                guard let pokemonStatus = response.data else {
                    return
                }
                completion(.success(pokemonStatus))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
