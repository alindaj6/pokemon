//
//  PokemonCollectionCell.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

class PokemonCollectionCell: UICollectionViewCell {

    func setupUi(image: URL?, name: String, fibIndex: Int, 
                 fibNumber: Int, delegate: PokemonListDelegate?) {
        self.pokemonListView.setupUi(image: image, name: name, fibIndex: fibIndex, 
                                     fibNumber: fibNumber, delegate: delegate)
    }

    func setupUi(image: URL?, myPokemon: MyPokemon, delegate: PokemonListDelegate?) {
        self.pokemonListView.setupUi(image: image, myPokemon: myPokemon, delegate: delegate)
    }

    fileprivate lazy var pokemonListView: PokemonListView = {
        let view = PokemonListView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokemonCollectionCell {
    fileprivate func setupLayout() {
        self.addSubview(pokemonListView)
        pokemonListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
