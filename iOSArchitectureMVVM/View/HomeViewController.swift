//
//  HomeViewController.swift
//  MVVMExample
//
//  Created by macbook on 11/15/20.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    private var router = HomeRouter()
    private var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    private var movies = [MovieModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        getData()
    }
    
    private func getData() {
        return viewModel.getListOfMovies()
        
        //handle concurrency or swift threads
        .subscribeOn(MainScheduler.instance)
        .observeOn(MainScheduler.instance)
        //observer subscription
            .subscribe { movies in
                self.movies = movies
            } onError: { (error) in
                print(error.localizedDescription)
            } onCompleted: {
                print("completed")
            }.disposed(by: disposeBag)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            
        }
    }
}
