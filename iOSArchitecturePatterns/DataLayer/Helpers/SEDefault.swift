//
//  SEDefault.swift
//
//  Created by Juan Pablo on 30/03/2020.
//  Copyright © 2020 Juan Pablo Crespi. All rights reserved.
//

import Foundation

public protocol SEDefaultDelegate {
    
    var rawValue: String { get }
    func get<T>() throws -> T
    func set(value: Any)
    func remove()
    func exists() -> Bool
}

extension SEDefaultDelegate {
        
    public func get<T>() throws -> T {
        if let value = UserDefaults.standard.value(forKey: rawValue) as? T {
            return value
        } else {
            throw NSError()
        }
    }
    
    public func set(value: Any) {
        UserDefaults.standard.set(value, forKey: rawValue)
    }
    
    public func remove() {
        UserDefaults.standard.removeObject(forKey: rawValue)
    }
    
    public func exists() -> Bool {
        return UserDefaults.standard.dictionaryRepresentation().keys.contains(rawValue)
    }
}
