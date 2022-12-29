//
//  SearchFlow.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/22.
//

import Foundation
import RxFlow
import UIKit

class SearchFlow: Flow {
    lazy var rootViewController = UINavigationController().then {
        $0.navigationBar.isHidden = true
    }
    
    var root: Presentable {
        return rootViewController
    }
    
    var reactor: SearchReactor
    
    init(reactor: SearchReactor) {
        self.reactor = reactor
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? SearchSteps else { return .none }
        
        switch step {
        case .initialized:
            return setupSearchScreen()
        case .detail(let id):
            return navigateToDetailScreen(id: id)
        }
    }
    
    private func setupSearchScreen() -> FlowContributors {
        let searchVC = SearchViewController(reactor: reactor)
        rootViewController.pushViewController(searchVC, animated: false)
        return .none
    }
    
    private func navigateToDetailScreen(id: Int) -> FlowContributors {
        let reactor = DetailReactor(id: id)
        let flow = DetailFlow(rootViewController: self.rootViewController, reactor: reactor)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: reactor))
    }
}
