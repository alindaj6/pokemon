//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

class PokemonViewModel {

    var isLoading: Observable<Bool> = Observable(false)

    var offset: Observable<Int> = Observable(0)
    var limit: Observable<Int> = Observable(10)
    var hasNextPage: Observable<Bool> = Observable(true)

    var pokemons: Observable<[Pokemon]> = Observable([])
    var pokemonStats: Observable<PokemonStatus?> = Observable(nil)

    internal let pokemonViewModelService: PokemonViewModelServiceProtocol

    init(pokemonViewModelService: PokemonViewModelServiceProtocol = PokemonViewModelService()) {
        self.pokemonViewModelService = pokemonViewModelService
    }

    func getPokemons(offset: Int) {
        if !self.hasNextPage.value {
            return
        }

        if self.pokemons.value.isEmpty {
            self.isLoading.value = true
        }

        pokemonViewModelService.getPokemons(offset: offset, limit: self.limit.value) { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.isLoading.value = false
                self?.hasNextPage.value = pokemons.hasNextPage
                self?.offset.value = pokemons.nextPage
                self?.limit.value = pokemons.nextLimit
                if let pokemonsList = pokemons.data {
                    self?.pokemons.value.append(contentsOf: pokemonsList)
                }
            case .failure(let error):
                self?.isLoading.value = false
                self?.hasNextPage.value = false
                Notifier.alert(type: .error(message: error.localizedDescription))
            }
        }
    }

    func getPokemonStat(name: String, isFromCacheFirst: Bool = true) {
        self.isLoading.value = true

        pokemonViewModelService.getPokemonStat(name: name) { [weak self] result in
            switch result {
            case .success(let pokemonStatus):
                self?.isLoading.value = false
                self?.pokemonStats.value = pokemonStatus
            case .failure(let error):
                self?.isLoading.value = false
                Notifier.alert(type: .error(message: error.localizedDescription))
            }
        }
    }
}
