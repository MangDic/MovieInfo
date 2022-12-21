//
//  Movie.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import Foundation

class RequestType: Codable {
    let hoppin: Hoppin
}

class Hoppin: Codable {
    let movies: Movies
}

class Movies: Codable {
    var movie: [Movie]
}

struct Movie: Codable, Hashable {
    var genreNames: String?
    var linkUrl: String?
    var thumbnailImage: String?
    var title: String?
    var ratingAverage: String?
}
