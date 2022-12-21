//
//  NetworkService.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import Foundation
import RxSwift

struct NetworkService {
    static func getMovies(page: Int, count: Int) -> Single<RequestType>{
        return APIClient.request(.loadMovie(page: page, count: count))
    }
}
