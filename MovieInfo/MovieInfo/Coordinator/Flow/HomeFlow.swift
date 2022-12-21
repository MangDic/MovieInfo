//
//  HomeFlow.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import RxFlow
import UIKit

class HomeFlow: Flow {
    lazy var rootViewController = UINavigationController()
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var reactor: HomeReactor
    
    init(reactor: HomeReactor) {
        self.reactor = reactor
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? HomeSteps else { return .none }
        
        switch step {
        case .initialized:
            return setupHomeScreen()
        case .detail(let data):
            return navigateToDetailScreen(data: data)
        case .exit:
            return popViewContoller()
        }
    }
    
    private func setupHomeScreen() -> FlowContributors {
        let homeVC = HomeViewController(reactor: reactor)
        rootViewController.pushViewController(homeVC, animated: false)
        return .none
    }
    
    private func navigateToDetailScreen(data: Movie) -> FlowContributors {
        let reactor = DetailReactor(movie: data)
        let detailVC = DetailViewController(reactor: reactor)
        
        rootViewController.pushViewController(detailVC, animated: false)
        return .none
    }
    
    private func popViewContoller() -> FlowContributors {
        rootViewController.popViewController(animated: false)
        return .none
    }
}
