//
//  MoviesTableViewCell.swift
//  iOSArchitectureVIPER
//
//  Created by apple on 16/12/2020.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var voteAverageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var originalTitleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!
    @IBOutlet weak var containerView: UIView!

    func setupUI() {
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
    }

    func populate(with movie: MovieModel) {
        voteAverageLbl.text = String(movie.voteAverage ?? 0)
        titleLbl.text = movie.title
        originalTitleLbl.text = movie.originalTitle
        descriptionLbl.text = movie.overview

        let posterPath = "https://www.themoviedb.org/t/p/w200\(movie.imageUrl ?? "")"
        if let imageUrl = URL(string: posterPath) {
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, _, _) in
                if let imageData = data, let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            }
            
            task.resume()
        }
    }
    
}
