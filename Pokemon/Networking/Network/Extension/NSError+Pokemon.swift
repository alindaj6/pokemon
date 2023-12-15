//
//  NSError+Pokemon.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public extension String {

    static let errorMaintenanceDomain = "com.app.pokemon.maintenance.system"
    static let errorSystemDomain = "com.app.pokemon.error.system"
    static let errorAuthDomain = "com.app.pokemon.error.auth"
    static let errorServiceDomain = "com.app.pokemon.error.service"
    static let errorLogicDomain = "com.app.pokemon.error.logic"
}

public extension NSError {

    var isMaintenance: Bool {
        return self.domain == .errorMaintenanceDomain
    }

    var isUnauthenticated: Bool {
        return self.code == 401
    }
}
