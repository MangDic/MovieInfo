//
//  DetailReactor.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import ReactorKit

class DetailReactor: Reactor {
    init(movie: Movie) {
        initialState.movie = movie
    }
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case setMovie(movie: Movie)
    }
    
    struct State {
        var movie = Movie()
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return Observable.just(.setMovie(movie: initialState.movie))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
        }
        return state
    }
}
