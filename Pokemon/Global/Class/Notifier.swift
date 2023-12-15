//
//  Notifier.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation
import SwiftMessages

public indirect enum NotifierType {
    case success(message: String)
    case error(message: String)
    case warning(message: String)
    case info(message: String)

    case custom(title: String, type: NotifierType)

    case unknown

    var message: String {
        switch self {
        case .success(let message):
            return message
        case .error(let message):
            return message
        case .warning(let message):
            return message
        case .info(let message):
            return message
        default:
            return ""
        }
    }
}

class Notifier {

    // MARK: - Alerts
    // swiftlint:disable function_body_length
    static func alert(type: NotifierType, position: SwiftMessages.PresentationStyle = .top,
                      dismissButton: Bool = false, tapHandler: (() -> Void)? = nil) {
        self.dismiss()
        let messageView: MessageView = MessageView.viewFromNib(layout: .cardView)
        var title: String = ""
        var message: String = ""

        messageView.titleLabel?.font = .boldSystemFont(ofSize: 20)
        messageView.bodyLabel?.font = .systemFont(ofSize: 14)

        switch type {
        case .success(let messagee):
            messageView.configureTheme(.success)
            title = "Success"
            message = messagee
        case .error(let messagee):
            messageView.configureTheme(.error)
            title = "Error"
            message = messagee
        case .warning(let messagee):
            messageView.configureTheme(.warning)
            title = "Warning"
            message = messagee
        case .info(let messagee):
            messageView.configureTheme(.info)
            title = "Info"
            message = messagee
        case .custom(let titlee, let type):
            title = titlee
            switch type {
            case .success(let messagee):
                messageView.configureTheme(.success)
                message = messagee
            case .error(let messagee):
                messageView.configureTheme(.error)
                message = messagee
                messageView.titleLabel?.font = .boldSystemFont(ofSize: 20)
                messageView.bodyLabel?.font = .systemFont(ofSize: 14)
                messageView.titleLabel?.textAlignment = .center
                messageView.bodyLabel?.textAlignment = .center
                messageView.titleLabel?.numberOfLines = 0
                messageView.bodyLabel?.numberOfLines = 0
                messageView.iconImageView?.isHidden = true
            case .warning(let messagee):
                messageView.configureTheme(.warning)
                message = messagee
            case .info(let messagee):
                messageView.configureTheme(.info)
                message = messagee
            default: return
            }
        default: return
        }

        messageView.configureContent(title: title, body: message)

        messageView.configureDropShadow()

        messageView.button?.setTitle("Dismiss", for: .normal)

        messageView.iconLabel?.isHidden = true
        messageView.button?.isHidden = !dismissButton

        var messageViewConfig = SwiftMessages.defaultConfig
        messageViewConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        messageViewConfig.presentationStyle = position
        switch position {
        case .center: messageViewConfig.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        default: break
        }

        messageViewConfig.preferredStatusBarStyle = .lightContent
        messageViewConfig.duration = notifierTimeout

        messageViewConfig.eventListeners.append { event in
            switch event {
            case .didHide: tapHandler?()
            default: break
            }
        }

        // Hide when button tapped
        messageView.buttonTapHandler = { _ in SwiftMessages.hide() }

        // Hide when message view tapped
        messageView.tapHandler = { _ in SwiftMessages.hide() }
        SwiftMessages.show(config: messageViewConfig, view: messageView)
    }

    static func info(_ message: String, dismissButton: Bool = false, tapHandler: (() -> Void)? = nil) {
        self.dismiss()
        let info = MessageView.viewFromNib(layout: .cardView)
        info.configureTheme(.info)
        info.configureDropShadow()

        info.configureContent(title: "Info", body: message)
        info.button?.setTitle("Dismiss", for: .normal)
        info.titleLabel?.font = .boldSystemFont(ofSize: 20)
        info.bodyLabel?.font = .systemFont(ofSize: 14)

        info.iconLabel?.isHidden = true
        info.button?.isHidden = !dismissButton

        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        infoConfig.presentationStyle = .center
        infoConfig.dimMode = .blur(style: .dark, alpha: 0.8, interactive: true)
        infoConfig.duration = notifierTimeout
        infoConfig.preferredStatusBarStyle = .lightContent

        infoConfig.eventListeners.append { event in
            switch event {
            case .didHide: tapHandler?()
            default: break
            }
        }

        // Hide when button tapped
        info.buttonTapHandler = { _ in SwiftMessages.hide() }

        // Hide when message view tapped
        info.tapHandler = { _ in SwiftMessages.hide() }
        SwiftMessages.show(config: infoConfig, view: info)
    }

    static func alert(_ title: String, message: String,
                      action: String = "Ok",
                      from caller: UIViewController? = UINavigationController.topMostVc,
                      tapHandler: (() -> Void)? = nil) {
        guard let caller = caller else { return }
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc .addAction(UIAlertAction(title: action, style: .default, handler: { (_) in
            tapHandler?()
        }))
        caller.present(vc, animated: true, completion: nil)
    }

    // Notification View
    static func notify(title: String, subtitle: String, body: String,
                       icon: CustomNotificationIconType = .default, tapHandler: (() -> Void)? = nil) {
        let customView = CustomNotificationView()
        customView.setupUI(title: title, subtitle: subtitle, body: body, icon: icon)
        let messageView = BaseView(frame: .zero)
        messageView.layoutMargins = .zero
        do {
            let backgroundView = CornerRoundingView()
            backgroundView.cornerRadius = 12
            messageView.installBackgroundView(backgroundView)
            messageView.installContentView(customView)
            messageView.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.preferredStatusBarStyle = .lightContent
        config.duration = notifierTimeout

        messageView.tapHandler = { _ in
            SwiftMessages.hide()
            tapHandler?()
        }
        SwiftMessages.show(config: config, view: messageView)
    }

    // present popup in a second then dismiss (if second <= 0 then not dismiss)
    static func show(view: UIView,
                     presentationStyle: SwiftMessages.PresentationStyle = .center,
                     duration: SwiftMessages.Duration = .forever,
                     interactive: Bool = false,
                     swipetohide: Bool = false
    ) {
        self.dismiss()
        let messageView = SwiftMessagesBaseView(frame: .zero)
        messageView.layoutMargins = .zero
        messageView.backgroundHeight = UIScreen.main.bounds.height
        do {
            let backgroundView = CornerRoundingView()
            switch presentationStyle {
            case .bottom:
                messageView.installBackgroundView(backgroundView, insets:
                                                    UIEdgeInsets(top: 0, left: 0, bottom: -32, right: 0))
            default:
                messageView.installBackgroundView(backgroundView)
            }
            messageView.installContentView(view)
        }
        var config = SwiftMessages.defaultConfig
        config.duration = duration
        config.presentationStyle = presentationStyle
        config.dimMode = .color(color: UIColor(netHex: 0x000000, alpha: 0.7), interactive: interactive)
        config.interactiveHide = swipetohide
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: (interactive ? view : messageView))
    }

    static func loading() {
        self.show(view: LoadingView())
    }

    static func dismiss() {
        SwiftMessages.hideAll()
    }

    static var notifierTimeout: SwiftMessages.Duration {
        return .seconds(seconds: 4)
    }
}
