//
//  HomeViewModel.swift
//  MVVMExample
//
//  Created by macbook on 11/13/20.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    private weak var view: HomeViewController?
    private var router: HomeRouter?
    
    func bind(view: HomeViewController, router: HomeRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func getListOfMovies() -> Observable<[MovieModel]> {
        return MovieManager.shared.getPopulars()
    }
}
