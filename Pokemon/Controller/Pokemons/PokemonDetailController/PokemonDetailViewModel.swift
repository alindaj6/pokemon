//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

class PokemonDetailViewModel {

    var isLoading: Observable<Bool> = Observable(false)
    var pokemonStats: Observable<PokemonStatus?> = Observable(nil)
    var catchPokemonSuccess: Observable<PokemonStatus?> = Observable(nil)

    func catchPokemon(pokemonStatus: PokemonStatus) {
        self.isLoading.value = true
        let pokeApiProvider = ServiceHelper.provider(for: PokeApi.self)
        pokeApiProvider.request(.catch(chance: PokemonSession.shared.catchChance.value)) { result in
            switch result {
            case .success(let response):
                self.isLoading.value = false
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let catchPoke = try! filteredResponse.map(CatchReleasePoke.self)
                    PokemonSession.shared.catchChance.value += 1
                    if catchPoke.isSuccess {
                        self.catchPokemonSuccess.value = pokemonStatus
                    } else {
                        Notifier.alert(type: .error(message: "Catch Failed"))
                    }
                }
                catch let error {
                    Notifier.alert(type: .error(message: error.localizedDescription))
                }
            case .failure(let error):
                self.isLoading.value = false
                Notifier.alert(type: .error(message: error.localizedDescription))
            }
        }
    }
}
