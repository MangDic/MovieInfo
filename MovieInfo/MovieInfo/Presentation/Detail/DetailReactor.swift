//
//  DetailReactor.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import ReactorKit
import Foundation

class DetailReactor: Reactor {
    var disposeBag = DisposeBag()
    
    init(id: Int) {
        initialState = State(id: id)
    }
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setMovie(movie: DetailMovie)
    }
    
    struct State {
        var id: Int
        var movie: DetailMovie?
    }
    
    var initialState: State
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return loadDetail().flatMap { movie -> Observable<Mutation> in
                return Observable.just(.setMovie(movie: movie))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
        }
        return newState
    }
    
    private func loadDetail() -> Observable<DetailMovie> {
        return Observable<DetailMovie>.create { observer in
            NetworkService
                .getMovieDetail(id: self.initialState.id)
                .subscribe(onSuccess: { movie in
                    observer.onNext(movie)
                    observer.onCompleted()
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
