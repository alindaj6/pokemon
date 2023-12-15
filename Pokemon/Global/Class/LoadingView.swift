//
//  LoadingView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

class LoadingView: UIView {

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        indicator.isHidden = false
        indicator.startAnimating()
        return indicator
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    fileprivate lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingView {
    fileprivate func addView() {
        self.addSubview(containerView)
        [titleLabel, descLabel, activityIndicator]
            .forEach { containerView.addSubview($0) }

        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
            make.size.equalTo(80)
        }

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(containerView)
        }
    }
}
