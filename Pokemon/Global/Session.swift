//
//  Session.swift
//  Pokemon
//
//  Created by Angga Setiawan on 15/12/23.
//

import Foundation

class PokemonSession: NSObject {

    static let shared = PokemonSession()

    var catchChance: Observable<Int> = Observable(1)
    var myPokemons: Observable<[MyPokemon]> = Observable([])
}
