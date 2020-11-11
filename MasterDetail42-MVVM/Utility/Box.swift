//
//  Box.swift
//  MasterDetail42-MVVM
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/11.
//

import Foundation

// MARK: - Box

final class Box<T> {
    
    // MARK: - Variables And Properties
    
    // Each Box can have a Listener that Box notifies when the value changes.
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    // Box has a generic type value. The didSet property observer detects any changes and notifies Listener of any value update.
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // MARK: - Class methods
    
    // The initializer sets Box‘s initial value.
    init(_ value: T) {
        self.value = value
    }
    
    // When a Listener calls bind(listener:) on Box, it becomes Listener and immediately gets notified of the Box‘s current value.
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}
