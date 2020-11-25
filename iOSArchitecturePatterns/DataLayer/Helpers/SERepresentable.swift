//
//  SERepresentable.swift
//
//  Created by Juan Pablo Crespi on 5/24/17.
//  Copyright © 2017 Juan Pablo Crespi. All rights reserved.
//

import Foundation

public extension RawRepresentable {
    
    init?(optValue: Self.RawValue?) {
        guard let rawValue = optValue, let value = Self(rawValue: rawValue) else { return nil }
        self = value
    }
}
