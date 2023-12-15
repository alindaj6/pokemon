//
//  MyPokemonViewModel.swift
//  Pokemon
//
//  Created by Angga Setiawan on 15/12/23.
//

import Foundation

public struct RenamedMyPokemon {
    public let name: String
    public let index: Int
    public let nextIndex: Int
    public let fibNumber: Int
}

public class MyPokemonViewModel {

    var isLoading: Observable<Bool> = Observable(false)
    var myPokemons: Observable<[MyPokemon]> = Observable([])
    var releasedPokemon: Observable<String?> = Observable(nil)
    
    var renamedPokemon: Observable<RenamedMyPokemon?> = Observable(nil)

    let pokeApiProvider = ServiceHelper.provider(for: PokeApi.self)

    func getMyPokemons() {
        self.myPokemons.value = PokemonSession.shared.myPokemons.value
    }

    func getReleaseMyPokemon(name: String) {
        self.isLoading.value = true
        pokeApiProvider.request(.release) { result in
            switch result {
            case .success(let response):
                self.isLoading.value = false
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let releasePoke = try! filteredResponse.map(CatchReleasePoke.self)
                    if releasePoke.isSuccess {
                        self.releasedPokemon.value = name
                    } else {
                        Notifier.alert(type: .error(message: "Release Failed"))
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

    func getRenameMyPokemon(index: Int, name: String) {
        if index == -1 {
            let renamedPokemon = RenamedMyPokemon(
                name: name, index: -1, nextIndex: 0, fibNumber: 0)
            self.renamedPokemon.value = renamedPokemon
            return
        }
        
        self.isLoading.value = true
        pokeApiProvider.request(.rename(index: index)) { result in
            switch result {
            case .success(let response):
                self.isLoading.value = false
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let renamePoke = try! filteredResponse.map(RenamePoke.self)
                    let renamedPokemon = RenamedMyPokemon(name: name, index: renamePoke.index,
                                                          nextIndex: renamePoke.nextIndex, fibNumber: renamePoke.fibNumber)
                    self.renamedPokemon.value = renamedPokemon
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
