//
//  HomeInteractor.swift
//  iOSArchitectureVIPER
//
//  Created by apple on 16/12/2020.
//

import UIKit

protocol HomeInteractorProtocol: class {
    var presenter: HomePresenterProtocol? { get set }
    
    func getPopularMovies()
}

class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomePresenterProtocol?
    
    func getPopularMovies() {
        let request = PopularMoviesRequest()
        
        request.performRequest {
            print("Request")
            request.performResponse { (response) in
                print("Response")
                if let results = response.results {
                    self.presenter?.getPopularMoviesSuccess(movies: results)
                } else {
                    self.presenter?.getPopularMoviesFailed(error: "Popular movies not found")
                }
            }
        }

    }
}
