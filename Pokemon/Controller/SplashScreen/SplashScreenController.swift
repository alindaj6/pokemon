//
//  ViewController.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

class SplashScreenController: UIViewController {

    fileprivate lazy var viewModel = SplashScreenViewModel()

    fileprivate lazy var splashImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "splash-image")
        return imgView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hide()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(netHex: 0x0E1F40)
        self.addView()
        self.bindData()
    }
}

extension SplashScreenController {
    fileprivate func bindData() {
        viewModel.isCountdownDone.bind { isCountdownDone in
            if isCountdownDone {
                guard let keyWindow = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last else { return }
                let vc = PokemonListViewController()
                let navVc = UINavigationController(rootViewController: vc)
                keyWindow.rootViewController = navVc
            }
        }

        self.viewModel.startTimer()
    }
}

extension SplashScreenController {
    fileprivate func addView() {
        self.view.addSubview(splashImgView)

        splashImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(splashImgView.snp.width).dividedBy(2.25)
        }
    }
}
