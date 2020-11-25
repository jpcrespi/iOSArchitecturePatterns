//
//  HomeRouter.swift
//  MVVMExample
//
//  Created by macbook on 11/15/20.
//

import Foundation
import UIKit

class HomeRouter {
    
    var viewController: UIViewController {
        return UIViewController()
    }
    
    private var sourceView: UIViewController?
    
    func setSourceView(_ source: UIViewController?) {
        guard let view = source else {
            return
        }
        self.sourceView = view
    }
}
