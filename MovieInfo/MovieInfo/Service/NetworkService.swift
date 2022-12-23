//
//  NetworkService.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import Foundation
import RxSwift

struct NetworkService {
    static func getMovies() -> Single<TrendMovie>{
        return APIClient.request(.loadMovie)
    }
    
    static func getMovieDetail(id: Int) -> Single<DetailMovie> {
        return APIClient.request(.detail(id: id))
    }
}
