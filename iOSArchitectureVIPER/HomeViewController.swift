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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    
    var presenter: HomePresenterProtocol?
    var isSearchActive : Bool = false
    var moviesFiltered: [MovieModel] = []
    
    var movies: [MovieModel] = [] {
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    var moviesTableData: [MovieModel] {
        return isSearchActive ? moviesFiltered : movies
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

extension HomeViewController: UISearchBarDelegate {
    func disableSearchStatus() {
        isSearchActive = false
        moviesTableView.reloadData()
    }
    
    func enableSearchStatus() {
        isSearchActive = true
        moviesTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            enableSearchStatus()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            disableSearchStatus()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        disableSearchStatus()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moviesFiltered = movies.filter({ (movie) -> Bool in
            let tmp = movie.title
            let range = tmp?.localizedStandardContains(searchText) ?? false
            return range
        })
        
        isSearchActive = moviesFiltered.count != 0
        moviesTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "MoviesTableViewCell", for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.populate(with: moviesTableData[indexPath.row])
        
        return cell
    }
    
    
}
