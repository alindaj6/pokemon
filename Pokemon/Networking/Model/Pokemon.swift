//
//  Pokemon.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

public struct Pokemon {
    public let name: String
    public let url: URL?

    private enum CodingKeys: String, CodingKey {
        case name, url
    }
}

extension Pokemon: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let urlString = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        url = URL(string: urlString)
    }
}
