//
//  HomeReactor.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import ReactorKit
import RxCocoa
import RxFlow

class HomeReactor: Reactor, Stepper {
    var disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return HomeSteps.initialized
    }
    
    enum Action {
        case load
        case detail(movie: Movie)
    }
    
    enum Mutation {
        case loadMovies(movies: [Movie])
    }
    
    struct State {
        var movies = [Movie]()
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return loadMovies().flatMap { movies -> Observable<Mutation> in
                return Observable.just(.loadMovies(movies: movies))
            }
        case .detail(let movie):
            steps.accept(HomeSteps.detail(data: movie))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadMovies(let movies):
            newState.movies = movies
        }
        return newState
    }
    
    private func loadMovies() -> Observable<[Movie]> {
        return Observable<[Movie]>.create { observer in
            NetworkService
                .getMovies(page: 1, count: 30)
                .subscribe(onSuccess: { data in
                    var movieArr = [Movie]()
                    let movies = data.hoppin.movies.movie
                    for movie in movies {
                        movieArr.append(movie)
                    }
                    observer.onNext(movieArr)
                    observer.onCompleted()
                }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
