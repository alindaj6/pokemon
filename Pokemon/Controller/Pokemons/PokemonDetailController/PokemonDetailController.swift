//
//  PokemonDetailController.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

class PokemonDetailController: UIViewController {

    fileprivate lazy var topView: PokemonDetailTopView = {
        let view = PokemonDetailTopView()
        return view
    }()

    fileprivate lazy var skillsPokemonStackView = {
        let pokemonStackView = PokemonStackView()
        pokemonStackView.title = "Skills"
        return pokemonStackView
    }()

    fileprivate lazy var movesPokemonStackView = {
        let pokemonStackView = PokemonStackView()
        pokemonStackView.title = "Moves"
        return pokemonStackView
    }()

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    fileprivate lazy var scrollContainerView: UIView = {
        let view = UIView()
        return view
    }()

    fileprivate lazy var catchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Catch", for: .normal)
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(catchBtnTapped), for: .touchUpInside)
        return btn
    }()

    static func create(status: PokemonStatus) -> PokemonDetailController {
        let vc = PokemonDetailController()
        vc.viewModel.pokemonStats.value = status
        return vc
    }

    internal var viewModel = PokemonDetailViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = ""
        self.addView()
        self.bindData()
    }

    @objc fileprivate func catchBtnTapped() {
        if let pokemonStats = viewModel.pokemonStats.value {
            self.viewModel.catchPokemon(pokemonStatus: pokemonStats)
        }
    }
}

extension PokemonDetailController {
    fileprivate func bindData() {

        viewModel.isLoading.bind { isLoading in
            if isLoading {
                Notifier.show(view: LoadingView())
            } else {
                Notifier.dismiss()
            }
        }

        viewModel.pokemonStats.bind { [weak self] pokemonStats in
            guard let strongSelf = self else { return }
            if let pokemonStats {
                strongSelf.delay(interval: .microseconds(200)) {
                    strongSelf.title = pokemonStats.name.capitalizingFirstLetter
                    strongSelf.topView.setupUI(status: pokemonStats)

                    var skillsView: [PokemonSkillView] = []
                    for skill in pokemonStats.stat {
                        let pokemonSkillView = PokemonSkillView()
                        pokemonSkillView.setupUI(name: skill.stat?.name.capitalizingFirstLetter ?? "", value: "\(skill.baseStat)")
                        skillsView.append(pokemonSkillView)
                    }
                    strongSelf.skillsPokemonStackView.setupUI(views: skillsView)

                    var movesView: [PokemonSkillView] = []
                    for move in pokemonStats.moves {
                        let pokemonSkillView = PokemonSkillView()
                        pokemonSkillView.setupUI(name: move.move?.name.capitalizingFirstLetter ?? "", value: "")
                        movesView.append(pokemonSkillView)
                    }
                    strongSelf.movesPokemonStackView.setupUI(views: movesView)
                }
            }
        }

        viewModel.catchPokemonSuccess.bind { [weak self] pokemonStatus in
            guard let strongSelf = self else { return }
            if let pokemonStatus {
                //1. Create the alert controller.
                let alert = UIAlertController(title: "Name Your Pokemon", message: "", preferredStyle: .alert)

                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.placeholder = "Name Your Pokemon"
                    textField.text = ""
                }

                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields?.first

                    if let text = textField?.text, !text.isEmpty {
                        let myPokemons = MyPokemon(status: pokemonStatus,
                                                   nickname: text,
                                                   index: -1, nextIndex: 1,
                                                   fibNumber: 0)
                        PokemonSession.shared.myPokemons.value.append(myPokemons)
                        strongSelf.delay(interval: .milliseconds(500)) {
                            strongSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }))

                // 4. Present the alert.
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension PokemonDetailController {
    fileprivate func addView() {
        self.view.addSubview(topView)
        self.view.addSubview(scrollView)
        self.view.addSubview(catchButton)
        scrollView.addSubview(scrollContainerView)

        [skillsPokemonStackView, movesPokemonStackView]
            .forEach { scrollContainerView.addSubview($0) }

        topView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.leading.trailing.width.equalTo(topView)
            make.bottom.equalTo(catchButton.snp.top).offset(-8)
            make.bottom.equalTo(scrollContainerView).offset(8)
        }

        catchButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(topView)
            make.height.equalTo(40)
        }

        scrollContainerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(movesPokemonStackView).offset(-8)
        }

        skillsPokemonStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollContainerView)
            make.leading.trailing.equalTo(scrollContainerView)
        }

        movesPokemonStackView.snp.makeConstraints { make in
            make.top.equalTo(skillsPokemonStackView.snp.bottom).offset(32)
            make.leading.trailing.equalTo(skillsPokemonStackView)
        }
    }
}
