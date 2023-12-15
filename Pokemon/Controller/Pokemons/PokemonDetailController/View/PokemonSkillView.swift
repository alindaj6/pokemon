//
//  PokemonSkillView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

class PokemonSkillView: UIView {

    func setupUI(name: String, value: String) {
        self.skillNameLabel.text = !value.isEmpty ? "\(name) :" : "\(name)"
        self.skillValueLabel.text = value
    }

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(netHex: 0x0E1F40)
        view.layer.cornerRadius = 6
        return view
    }()

    fileprivate lazy var skillNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .white
        label.text = ""
        return label
    }()

    fileprivate lazy var skillValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .white
        label.text = ""
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

extension PokemonSkillView {
    fileprivate func addView() {
        self.addSubview(containerView)
        [skillNameLabel, skillValueLabel]
            .forEach { containerView.addSubview($0) }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        skillNameLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(containerView).inset(8)
        }

        skillValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(skillNameLabel)
            make.trailing.equalTo(containerView).inset(8)
        }
    }
}
