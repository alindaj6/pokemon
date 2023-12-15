//
//  MyPokemonController.swift
//  Pokemon
//
//  Created by Angga Setiawan on 15/12/23.
//

import UIKit

class MyPokemonController: UIViewController {

    internal lazy var pokemonsCollectionView: UICollectionView = {
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectView.alpha = 1.0
        return collectView
    }()

    internal lazy var viewModel = MyPokemonViewModel()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "My Pokemons"
        self.addView()
        self.bindData()
    }
}

extension MyPokemonController {
    fileprivate func bindData() {

        viewModel.isLoading.bind { isLoading in
            if isLoading {
                Notifier.show(view: LoadingView())
            } else {
                Notifier.dismiss()
            }
        }

        viewModel.myPokemons.bind { _ in
            self.pokemonsCollectionView.reloadData()
        }

        viewModel.releasedPokemon.bind { [weak self] name in
            guard let strongSelf = self else { return }
            if let name {
                let filteredOutMyPokemons = strongSelf.viewModel.myPokemons.value.filter { $0.nickname != name }
                PokemonSession.shared.myPokemons.value = filteredOutMyPokemons
                strongSelf.delay(interval: .microseconds(200)) {
                    strongSelf.viewModel.getMyPokemons()
                }
            }
        }

        viewModel.renamedPokemon.bind { [weak self] renamedMyPokemon in
            guard let strongSelf = self else { return }
            if let renamedMyPokemon {
                if let myPokemon = strongSelf.viewModel.myPokemons.value.filter({ $0.nickname == renamedMyPokemon.name }).first {
                    let newMyPokemon = MyPokemon(status: myPokemon.status, nickname: myPokemon.nickname,
                                                 index: renamedMyPokemon.index, nextIndex: renamedMyPokemon.nextIndex,
                                                 fibNumber: renamedMyPokemon.fibNumber)
                    if let row = PokemonSession.shared.myPokemons.value.firstIndex(where: { $0.nickname == renamedMyPokemon.name }) {
                        PokemonSession.shared.myPokemons.value[row] = newMyPokemon
                        strongSelf.delay(interval: .microseconds(200)) {
                            strongSelf.viewModel.getMyPokemons()
                        }
                    }
                }
            }
        }

        self.delay(interval: .microseconds(500)) {
            self.initCollectionView()
            self.viewModel.getMyPokemons()
        }
    }
}

extension MyPokemonController {
    fileprivate func addView() {
        self.view.addSubview(pokemonsCollectionView)

        pokemonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}
