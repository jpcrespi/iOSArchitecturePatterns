//
//  SEObservable.swift
//
//  Created by Juan Pablo on 04/04/2020.
//  Copyright © 2020 Juan Pablo Crespi. All rights reserved.
//

import Foundation

public protocol SEObserver {
    
    var id: String { get set }
}

open class SEObservable<T>: NSObject {
        
    private var observers: [String: ((T) -> Void)?] = [:]

    open var value: T {
        didSet {
            self.notify()
        }
    }
    
    public init(value: T) {
        self.value = value
    }

    open func add(observer: SEObserver, on: ((T) -> Void)?) {
        guard observers.keys.contains(observer.id) == false else {
            return
        }
        observers[observer.id] = on
    }

    open func remove(observer: SEObserver) {
        guard observers.keys.contains(observer.id) else {
            return
        }
        observers.removeValue(forKey: observer.id)
    }

    open func notify() {
        observers.forEach { $0.value?(value) }
    }

    deinit {
        observers.removeAll()
    }
}
