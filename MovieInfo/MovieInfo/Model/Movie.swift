//
//  Movie.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import Foundation

struct TrendMovie: Codable {
    let results: [Movie]
    let page: Int
}

struct Movie: Codable {
    let adult: Bool
    let backdrop_path: String?
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let media_type : String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}

struct DetailMovie: Codable {
    var id: Int
    var title: String
    var vote_average: Double
    var runtime: Int
    var release_date: String
    var tagline: String
    var status: String
    var overview: String
    var homepage: String
    var imdb_id: String
    var poster_path: String
    var genres: [Genre]
}

struct SearchMovie: Codable {
    var page: Int?
    var results: [ResultMovie?]?
}

struct ResultMovie: Codable {
    var original_title: String
    var id: Int
    var poster_path: String?
    var vote_average: Double
    var overview: String
    var genre_ids: [Int]
}

struct GenreList: Codable {
    let genres: Array<Genre>
}

struct Genre: Codable {
    let id: Int
    let name: String
}

