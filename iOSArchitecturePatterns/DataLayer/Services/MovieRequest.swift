//
//  MovieRequest.swift
//  iOSArchitecturePatterns
//
//  Created by Juan Pablo on 25/11/2020.
//

import Foundation

class PopularMoviesRequest: BaseRequest<Void, [MovieModel], Any> {

    init() {
        super.init(name: "popularMovies",
                   path: "/movie/popular",
                   method: .get,
                   data: nil)
    }
}
