//
//  HomeViewController.swift
//  iOSArchitectureVIPER
//
//  Created by Juan Pablo on 25/11/2020.
//

import UIKit

protocol HomeViewProtocol: class {
    var presenter: HomePresenterProtocol? { get set }
    
    func getPopularMovies()
    func getPopularMoviesSuccess(movies: [MovieModel])
    func getPopularMoviesFailed(error: String)
}

class HomeViewController: UIViewController, HomeViewProtocol {
    @IBOutlet weak var searchBarTextfield: UITextField!
    @IBOutlet weak var moviesTableView: UITableView!
    
    var presenter: HomePresenterProtocol?
    
    var movies: [MovieModel] = [] {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPopularMovies()
    }
    
    func getPopularMovies() {
        presenter?.getPopularMovies()
    }
    
    func getPopularMoviesSuccess(movies: [MovieModel]) {
        self.movies = movies
    }
    
    func getPopularMoviesFailed(error: String) {
        print(error)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "MoviesTableViewCell", for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
        
        cell.populate(with: movies[indexPath.row])
        
        return cell
    }
    
    
}
