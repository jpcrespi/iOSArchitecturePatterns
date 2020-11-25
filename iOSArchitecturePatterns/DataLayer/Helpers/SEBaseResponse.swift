//
//  SEBaseResponse.swift
//
//  Created by Juan Pablo Crespi on 1/27/17.
//  Copyright © 2017 Juan Pablo Crespi. All rights reserved.
//

import UIKit

open class SEBaseResponse<T>: NSObject {
        
    open func service(result: T, response: HTTPURLResponse? = nil) -> Self {
        return self
    }
    
    open func service(error: NSError, response: HTTPURLResponse? = nil) -> Self {
        return self
    }
}
