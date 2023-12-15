//
//  PokemonStackView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 15/12/23.
//

import UIKit

class PokemonStackView: UIView {

    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }

    func setupUI(views: [UIView]) {
        self.titleLabel.text = title

        if !stackView.arrangedSubviews.isEmpty {
            stackView.removeAllArrangedSubviews()
        }

        for view in views {
            stackView.addArrangedSubview(view)
        }
    }

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 6
        return view
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = ""
        return label
    }()

    fileprivate lazy var horDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
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

extension PokemonStackView {
    fileprivate func addView() {
        self.addSubview(containerView)
        [titleLabel, horDivider, stackView]
            .forEach { containerView.addSubview($0) }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(containerView)
        }

        horDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(1)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(horDivider.snp.bottom).offset(16)
            make.bottom.equalTo(containerView)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}
