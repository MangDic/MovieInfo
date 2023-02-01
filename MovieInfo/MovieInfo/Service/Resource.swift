//
//  Resource.swift
//  MovieInfo
//
//  Created by 이명직 on 2023/02/01.
//

import Foundation

struct R {
    struct String {
        struct Home { }
        struct Search { }
        struct MovieDetail { }
    }
}

extension R.String.Home {
    static let trend = "트랜드"
}

extension R.String.Search {
    static let search = "검색"
    static let movieSearchDescription = "영화를 검색해 보세요!"
    static let noMovieDescription = "앗, 검색된 영화가 없어요!"
    static let inputQueryDescription = "검색어를 입력하세요"
    static let average: (String) -> String = { "평점: \($0)점" }
}

extension R.String.MovieDetail {
    static let average: (Double) -> String = { "평점: \($0)점" }
    static let runtime: (Int) -> String = { "상영시간: \($0)분" }
}
