//
//  HomePresenter.swift
//  iOSArchitectureVIPER
//
//  Created by apple on 16/12/2020.
//

import UIKit

protocol HomePresenterProtocol: class {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    
    var movies: [MovieModel] { get set }
    
    func getPopularMovies()
    func getPopularMoviesSuccess(movies: [MovieModel])
    func getPopularMoviesFailed(error: String)
}

class HomePresenter: HomePresenterProtocol {
    var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    
    var movies: [MovieModel] = []
    
    func getPopularMovies() {
        interactor?.getPopularMovies()
    }
    
    func getPopularMoviesSuccess(movies: [MovieModel]) {
        view?.getPopularMoviesSuccess(movies: movies)
    }
    
    func getPopularMoviesFailed(error: String) {
        view?.getPopularMoviesFailed(error: error)
    }
}
