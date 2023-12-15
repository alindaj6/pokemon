//
//  PokemonDetailTopView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit
import Kingfisher

class PokemonDetailTopView: UIView {

    func setupUI(status: PokemonStatus) {
        var types = ""
        for type in status.types {
            types.append(type.type?.name ?? "")
            types.append(", ")
        }
        if !types.isEmpty {
            types.removeLast()
            types.removeLast()
        }
        self.typeLabel.text = "Type : \(types)"
        self.heightLabel.text = "Height : \(status.height)m"
        self.weightLabel.text = "Weight : \(status.weight) Kg"

        self.pokemonImgView.kf.setImage(with: status.sprites.img)
    }

    fileprivate lazy var topHorDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0x0E1F40)
        view.layer.cornerRadius = 8
        return view
    }()

    fileprivate lazy var pokemonImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage()
        return imgView
    }()

    fileprivate lazy var verticalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Pokemon"
        return label
    }()

    fileprivate lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    fileprivate lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    fileprivate lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokemonDetailTopView {
    fileprivate func addView() {
//        self.addSubview(topHorDivider)
        self.addSubview(containerView)

        [pokemonImgView, verticalDivider, titleLabel,
         typeLabel, heightLabel, weightLabel]
            .forEach { containerView.addSubview($0) }

//        topHorDivider.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(8)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(1)
//        }

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        pokemonImgView.snp.makeConstraints { make in
            make.top.bottom.equalTo(containerView).inset(40)
            make.leading.equalTo(containerView).inset(40)
            make.size.equalTo(100)
        }

        verticalDivider.snp.makeConstraints { make in
            make.top.bottom.equalTo(pokemonImgView)
            make.leading.equalTo(pokemonImgView.snp.trailing).offset(24)
            make.width.equalTo(1.5)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalDivider)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(24)
            make.trailing.equalTo(containerView).inset(16)
        }

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleLabel)
        }

        heightLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
        }

        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(heightLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}
