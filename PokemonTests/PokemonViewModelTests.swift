//
//  PokemonViewModelTests.swift
//  PokemonTests
//
//  Created by Angga Setiawan on 16/12/23.
//

import XCTest
import Nimble

@testable import Pokemon

class PokemonViewModelTests: XCTestCase {

    var viewModel: PokemonViewModel!
    var mockPokemonViewModelService: MockPokemonViewModelService!

    override func setUp() {
        super.setUp()
        mockPokemonViewModelService = MockPokemonViewModelService()
        viewModel = PokemonViewModel(pokemonViewModelService: mockPokemonViewModelService)
    }

    func testGetPokemonsFromApiSuccess() {
        let pokemons: [Pokemon] = [Pokemon(name: "abcd", url: nil),
                                   Pokemon(name: "efgh", url: nil),
                                   Pokemon(name: "ijkl", url: nil),
                                   Pokemon(name: "mnop", url: nil),
                                   Pokemon(name: "qrst", url: nil)]

        let appResponsePokemons: AppResponse<[Pokemon]> = AppResponse(hasNextPage: true, nextPage: 10, nextLimit: 10, previousPage: 0, previousLimit: 10, totalData: 10, data: pokemons)

        mockPokemonViewModelService.resultPokemons = .success(appResponsePokemons)

        viewModel.getPokemons(offset: 0)

        expect(self.viewModel.pokemons.value.count).to(equal(5))
        expect(self.viewModel.pokemons.value[0].name).to(equal("abcd"))
        expect(self.viewModel.pokemons.value[1].name).to(equal("efgh"))
        expect(self.viewModel.pokemons.value[2].name).to(equal("ijkl"))
        expect(self.viewModel.pokemons.value[3].name).to(equal("mnop"))
        expect(self.viewModel.pokemons.value[4].name).to(equal("qrst"))
    }

    func testGetPokemonsFromApiFailed() {
        let error = NSError(domain: "", code: 400)
        mockPokemonViewModelService.resultPokemons = .failure(error)

        viewModel.getPokemons(offset: 0)

        expect(self.viewModel.pokemons.value).to(beEmpty())
    }

    func testGetPokemonStatsFromApiSuccess() {
        let pokemonStat: [PokemonStat] = [PokemonStat(baseStat: 20, stat: Pokemon(name: "hp", url: nil)),
                                          PokemonStat(baseStat: 30, stat: Pokemon(name: "attack", url: nil)),
                                          PokemonStat(baseStat: 40, stat: Pokemon(name: "defense", url: nil)),
                                          PokemonStat(baseStat: 50, stat: Pokemon(name: "speed", url: nil))]
        let pokemonTypes: [PokemonTypes] = [PokemonTypes(slot: 1, type: Pokemon(name: "grass", url: nil)),
                                            PokemonTypes(slot: 1, type: Pokemon(name: "poison", url: nil))]

        let pokemonSprites = PokemonSprites(img: nil)

        let pokemonStatus = PokemonStatus(stat: pokemonStat, types: pokemonTypes,
                                          pokemonId: 1, name: "bulbasaur",
                                          height: 100, weight: 200,
                                          sprites: pokemonSprites, moves: [])

        mockPokemonViewModelService.resultPokemonStat = .success(pokemonStatus)

        viewModel.getPokemonStat(name: "bulbasaur", isFromCacheFirst: false)

        expect(self.viewModel.pokemonStats.value).toNot(beNil())
        expect(self.viewModel.pokemonStats.value!.pokemonId).to(equal(1))
        expect(self.viewModel.pokemonStats.value!.name).to(equal("bulbasaur"))
        expect(self.viewModel.pokemonStats.value!.height).to(equal(100))
        expect(self.viewModel.pokemonStats.value!.weight).to(equal(200))

        expect(self.viewModel.pokemonStats.value!.types[0].type!.name).to(equal("grass"))
        expect(self.viewModel.pokemonStats.value!.types[1].type!.name).to(equal("poison"))

        expect(self.viewModel.pokemonStats.value!.stat[0].stat!.name).to(equal("hp"))
        expect(self.viewModel.pokemonStats.value!.stat[0].baseStat).to(equal(20))

        expect(self.viewModel.pokemonStats.value!.stat[1].stat!.name).to(equal("attack"))
        expect(self.viewModel.pokemonStats.value!.stat[1].baseStat).to(equal(30))

        expect(self.viewModel.pokemonStats.value!.stat[2].stat!.name).to(equal("defense"))
        expect(self.viewModel.pokemonStats.value!.stat[2].baseStat).to(equal(40))

        expect(self.viewModel.pokemonStats.value!.stat[3].stat!.name).to(equal("speed"))
        expect(self.viewModel.pokemonStats.value!.stat[3].baseStat).to(equal(50))
    }

    func testGetPokemonStatsFromApiFailed() {
        let error = NSError(domain: "", code: 400)
        mockPokemonViewModelService.resultPokemonStat = .failure(error)

        viewModel.getPokemonStat(name: "bulbasaur", isFromCacheFirst: false)

        expect(self.viewModel.pokemonStats.value).to(beNil())
    }
}
