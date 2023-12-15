//
//  UINavigationController.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

public extension UINavigationController {

    static var topMostVc: UIViewController? {
        var topController: UIViewController?
        if #available(iOS 13.0, *) {
            topController = UIApplication.shared.windows.first?.rootViewController
        } else {
            // Code for earlier iOS versions
            topController = UIApplication.shared.keyWindow?.rootViewController
        }
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        if let tab = topController as? UITabBarController {
            topController = tab.selectedViewController
        }
        if let navigation = topController as? UINavigationController {
            topController = navigation.visibleViewController
        }
        return topController
    }

    // hide navigation bar
    func hide() {
        self.setNavigationBarHidden(true, animated: false)
    }

    // show navigation bar
    func show() {
        self.setNavigationBarHidden(false, animated: false)
    }
}

public extension UINavigationController {

    var isHiddenHairline: Bool {
        get {
            guard let hairline = findHairlineImageViewUnder(navigationBar) else { return true }
            return hairline.isHidden
        }
        set {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                hairline.isHidden = newValue
            }
        }
    }

    private func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }

        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }

        return nil
    }
}
