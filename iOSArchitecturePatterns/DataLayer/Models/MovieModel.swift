//
//  MovieModel.swift
//  iOSArchitecturePatterns
//
//  Created by Juan Pablo on 25/11/2020.
//

import Foundation

struct MovieModel: BaseModel {    

    var id: Int?
    var title: String?
    var popularity: Double?
    var voteCount: Int?
    var originalTitle: String?
    var voteAverage: Double?
    var overview: String?
    var releaseDate: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case popularity
        case voteCount = "vote_count"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
        case imageUrl = "poster_path"
    }
}
