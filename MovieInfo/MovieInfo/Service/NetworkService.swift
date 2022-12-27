//
//  NetworkService.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import Foundation
import RxSwift

struct NetworkService {
    static func getMovies(page: Int) -> Single<TrendMovie>{
        return APIClient.request(.loadMovie(page: page))
    }
    
    static func getMovieDetail(id: Int) -> Single<DetailMovie> {
        return APIClient.request(.detail(id: id))
    }
    
    static func getSearchList(query: String) -> Single<SearchMovie> {
        return APIClient.request(.search(query: query))
    }
    
    static func getGenreList() -> Single<GenreList> {
        return APIClient.request(.movie_genres)
    }
}
