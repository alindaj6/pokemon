//
//  CustomNotificationView.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

public enum CustomNotificationIconType {
    case `default`
    case custom(image: UIImage)
}

class CustomNotificationView: UIView {

    func setupUI(title: String, subtitle: String, body: String,
                 icon: CustomNotificationIconType = .default) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.bodyLabel.text = body
        switch icon {
        case .custom(let image):
            self.iconImageView.image = image
        default:
            self.iconImageView.image = UIImage()
        }
    }

    fileprivate lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.alpha(0.8)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
        return view
    }()

    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    fileprivate lazy var iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = #imageLiteral(resourceName: "icon-ios")
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        return imgView
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    fileprivate lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
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

extension CustomNotificationView {
    fileprivate func addView() {
        self.addSubview(shadowView)
        shadowView.addSubview(containerView)
        [iconImageView, titleLabel, subtitleLabel, bodyLabel]
            .forEach { containerView.addSubview($0) }

        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalTo(shadowView).inset(16)
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(2)
            make.leading.equalTo(containerView)
            make.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
        }

        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(containerView)
        }
    }
}
