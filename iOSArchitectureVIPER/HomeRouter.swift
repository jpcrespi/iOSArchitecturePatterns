//
//  HomeRouter.swift
//  iOSArchitectureVIPER
//
//  Created by apple on 16/12/2020.
//

import UIKit

protocol HomeRouterProtocol: class {
    static func createModule() -> HomeViewController
}

class HomeRouter: NSObject, HomeRouterProtocol {
    static func createModule() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let view = storyboard.instantiateViewController(
                withIdentifier: "HomeViewController") as? HomeViewController else { return HomeViewController() }
        
        let presenter: HomePresenterProtocol = HomePresenter()
        
        presenter.router = HomeRouter()
        presenter.view = view
        presenter.view?.presenter = presenter
        presenter.interactor = HomeInteractor()
        presenter.interactor?.presenter = presenter
        
        return view
    }
    
    
}
