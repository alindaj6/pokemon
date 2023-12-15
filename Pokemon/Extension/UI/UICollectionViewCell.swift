//
//  UICollectionViewCell.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import UIKit

public extension UICollectionViewCell {
    static func identifier() -> String {
        return String(describing: self)
    }
    static func nib() -> UINib {
        return UINib(nibName: identifier(), bundle: nil)
    }
}
