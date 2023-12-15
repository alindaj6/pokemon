//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

class PokemonListViewController: UIViewController {

    internal lazy var pokemonsCollectionView: UICollectionView = {
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectView.alpha = 1.0
        return collectView
    }()

    fileprivate lazy var myPokemonButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("My Pokemon", for: .normal)
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(myPokemonBtnTapped), for: .touchUpInside)
        btn.alpha = 0.0
        return btn
    }()

    internal lazy var viewModel = PokemonViewModel()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Pokemons"
        self.addView()
        self.bindData()
    }

    @objc fileprivate func myPokemonBtnTapped() {
        let vc = MyPokemonController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PokemonListViewController {
    fileprivate func bindData() {

        viewModel.isLoading.bind { isLoading in
            if isLoading {
                Notifier.show(view: LoadingView())
            } else {
                Notifier.dismiss()
            }
        }

        viewModel.pokemons.bind { [weak self] pokemons in
            if !pokemons.isEmpty {
                self?.initCollectionView()
                self?.pokemonsCollectionView.reloadData()
                self?.myPokemonButton.alpha = 1.0
            }
        }

        viewModel.pokemonStats.bind { pokemonStats in
            if let pokemonStats {
                let vc = PokemonDetailController.create(status: pokemonStats)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        self.delay(interval: .seconds(1)) {
            self.viewModel.getPokemons(offset: self.viewModel.offset.value)
        }
    }
}

extension PokemonListViewController {
    fileprivate func addView() {
        self.view.addSubview(pokemonsCollectionView)
        self.view.addSubview(myPokemonButton)

        pokemonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(myPokemonButton.snp.top).offset(-8)
            make.leading.trailing.equalToSuperview()
        }

        myPokemonButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(pokemonsCollectionView).inset(8)
            make.height.equalTo(40)
        }
    }
}
