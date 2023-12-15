//
//  UIViewController.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

public extension UIViewController {
    func delay(interval: DispatchTimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
        }
    }
}
