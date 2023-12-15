//
//  Observable.swift
//  Pokemon
//
//  Created by Angga Setiawan on 16/12/23.
//

import Foundation

class Observable<T> {

    var value: T {
        didSet {
            listeners.forEach {
                $0?(value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    private var listeners: [((T) -> Void)?] = []

    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.listeners.append(closure)
    }
}
