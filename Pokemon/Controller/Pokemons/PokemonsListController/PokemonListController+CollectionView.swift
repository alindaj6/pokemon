//
//  PokemonListController+CollectionView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

extension PokemonListViewController: UICollectionViewDelegate, UICollectionViewDataSource,
            UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    internal func initCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.pokemonsCollectionView.setCollectionViewLayout(layout, animated: true)
        self.pokemonsCollectionView.register(PokemonCollectionCell.self,
                                         forCellWithReuseIdentifier: PokemonCollectionCell.identifier())
        self.pokemonsCollectionView.backgroundColor = .clear
        self.pokemonsCollectionView.delegate = self
        self.pokemonsCollectionView.dataSource = self
    }

    // Check how much data
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.pokemons.value.count
    }

    // Choose what cell will use
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = pokemonsCollectionView.dequeueReusableCell(
            withReuseIdentifier: PokemonCollectionCell.identifier(), for: indexPath)
            as? PokemonCollectionCell else {
                return UICollectionViewCell(frame: .zero)
        }

        let row = indexPath.row

        let pokemon = self.viewModel.pokemons.value[row]
        let id = pokemon.url?.absoluteString.split(separator: "/").last?.toString ?? ""
        let imgURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(id).png")
        cell.setupUi(image: imgURL, name: pokemon.name, fibIndex: -1,
                     fibNumber: 0, delegate: self)

        if row == self.viewModel.pokemons.value.count - 1 {
            self.viewModel.getPokemons(offset: self.viewModel.offset.value)
        }
        return cell
    }

    // styling each boxes for UX
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.frame.width / 2 - 16
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }

    // margin cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension PokemonListViewController: PokemonListDelegate {
    func didPokemonListTapped(_ name: String, nextIndex: Int) {
        self.viewModel.getPokemonStat(name: name)
    }
}
