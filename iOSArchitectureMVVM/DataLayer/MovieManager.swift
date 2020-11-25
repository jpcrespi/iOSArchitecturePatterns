//
//  MovieManager.swift
//  iOSArchitectureMVVM
//
//  Created by Juan Pablo on 25/11/2020.
//

import Foundation
import RxSwift

class MovieManager {

    static let shared = MovieManager()
    
    func getPopulars() -> Observable<[MovieModel]> {
        
        return Observable.create { observer -> Disposable in
            let request = PopularMoviesRequest()
            request.performRequest {
                request.performResponse { response in
                    if let results = response.results {
                        observer.onNext(results)
                    } else {
                        observer.onError(NSError(domain: response.statusMessage ?? "Unknow",
                                                 code: response.statusCode ?? -1,
                                                 userInfo: nil))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
