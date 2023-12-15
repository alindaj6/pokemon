//
//  MyPokemonController+CollectionView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 15/12/23.
//

import Foundation
import UIKit

extension MyPokemonController: UICollectionViewDelegate, UICollectionViewDataSource,
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
        return self.viewModel.myPokemons.value.count
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

        let pokemon = self.viewModel.myPokemons.value[row]
        cell.setupUi(image: nil, myPokemon: pokemon, delegate: self)

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

extension MyPokemonController: PokemonListDelegate {
    func didPokemonListTapped(_ name: String, nextIndex: Int) {
        let alertController = UIAlertController(
            title: "Choose",
            message: "",
            preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Release", style: .default, handler: { (_) in
            self.viewModel.getReleaseMyPokemon(name: name)
        }))
        
        alertController.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (_) in
            self.viewModel.getRenameMyPokemon(index: nextIndex, name: name)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
