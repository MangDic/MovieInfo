//
//  SearchReactor.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/27.
//

import Foundation
import ReactorKit
import RxFlow
import RxSwift
import RxRelay

class SearchReactor: Reactor, Stepper {
    var disposeBag = DisposeBag()
    
    var steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return SearchSteps.initialized
    }
    
    enum Action {
        case search(query: String)
        case detail(id: Int)
    }
    
    enum Mutation {
        case loadSearchData(movies: [ResultMovie?])
        case moveToDetail
    }
    
    struct State {
        var movies = [ResultMovie?]()
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let query):
            return loadSearchData(query: query).flatMap { movies -> Observable<Mutation> in
                return Observable.just(.loadSearchData(movies: movies.results ?? []))
            }
        case .detail(let id):
            steps.accept(SearchSteps.detail(id: id))
            return .empty()
        }
    }
    
    private func loadSearchData(query: String) -> Observable<SearchMovie> {
        return Observable<SearchMovie>.create { observer in
            NetworkService
                .getSearchList(query: query)
                .subscribe(onSuccess: { data in
                    observer.onNext(data)
                    observer.onCompleted()
                }).disposed(by: self.disposeBag)
        
            return Disposables.create()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadSearchData(let movies):
            newState.movies = movies
        default:
            print("")
        }
        
        return newState
    }
}
