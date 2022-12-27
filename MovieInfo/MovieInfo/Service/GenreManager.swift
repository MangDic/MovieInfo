//
//  GenreManager.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/23.
//

import Foundation
import RxSwift

class GenreManager {
    static let shared = GenreManager()
    var genreDic = [Int: String]()
    
    var disposeBag = DisposeBag()
    
    private init() {
        loadGenreList()
    }
    
    private func loadGenreList() {
        NetworkService
            .getGenreList()
            .subscribe(onSuccess: { data in
                for genre in data.genres {
                    GenreManager.shared.genreDic[genre.id] = genre.name
                }
            }).disposed(by: disposeBag)
    }
}
