//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

protocol PokemonListDelegate: AnyObject {
    func didPokemonListTapped(_ name: String, nextIndex: Int)
}

class PokemonListView: UIView {

    fileprivate var name: String = ""
    fileprivate var fibIndex: Int = 0

    func setupUi(image: URL?, name: String, fibIndex: Int, fibNumber: Int, delegate: PokemonListDelegate?) {
        self.delegate = delegate
        self.name = name
        self.fibIndex = fibIndex
        self.pokemonName.text = fibIndex == -1 ? name : "\(name)-\(fibNumber)"
        self.pokemonImgView.kf.setImage(with: image)
    }

    func setupUi(image: URL?, myPokemon: MyPokemon, delegate: PokemonListDelegate?) {
        self.delegate = delegate
        self.name = myPokemon.nickname
        self.fibIndex = myPokemon.nextIndex
        self.pokemonName.text = myPokemon.index == -1 ? name : "\(myPokemon.nickname)-\(myPokemon.fibNumber)"
        self.pokemonImgView.kf.setImage(with: myPokemon.status?.sprites.img)
    }

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate lazy var pokemonImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage()
        return imgView
    }()

    fileprivate lazy var pokemonName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    weak var delegate: PokemonListDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.addView()
        self.backgroundColor = UIColor.init(netHex: 0x0E1F40)
        self.layer.cornerRadius = 8
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pokemonTapped)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc fileprivate func pokemonTapped() {
        self.delegate?.didPokemonListTapped(
            self.name, nextIndex: self.fibIndex)
    }
}

extension PokemonListView {
    fileprivate func addView() {
        self.addSubview(containerView)
        containerView.addSubview(pokemonImgView)
        containerView.addSubview(pokemonName)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pokemonImgView.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(16)
            make.bottom.equalTo(pokemonName.snp.top).offset(-8)
            make.centerX.equalTo(containerView)
            make.width.equalTo(pokemonImgView.snp.height)
        }

        pokemonName.snp.makeConstraints { make in
            make.leading.trailing.equalTo(pokemonImgView)
            make.bottom.equalTo(containerView).inset(16)
        }
    }
}
