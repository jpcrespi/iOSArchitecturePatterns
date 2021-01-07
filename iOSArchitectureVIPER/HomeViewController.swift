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
    func getPopularMoviesSuccess()
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
        setupUI()
        getPopularMovies()
    }

    func setupUI() {
        searchBar.layer.cornerRadius = 15
        searchBar.layer.masksToBounds = true
    }
    
    func getPopularMovies() {
        presenter?.getPopularMovies()
    }
    
    func getPopularMoviesSuccess() {
        self.movies = presenter?.movies ?? []
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
        if let text = searchBar.text, text.isEmpty {
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
        moviesFiltered = presenter?.searchMovies(searchText) ?? []
        isSearchActive = true
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
        cell.setupUI()
        cell.populate(with: moviesTableData[indexPath.row])
        
        return cell
    }
    
    
}
