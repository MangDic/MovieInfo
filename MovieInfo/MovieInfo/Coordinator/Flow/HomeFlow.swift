//
//  HomeFlow.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import RxFlow
import UIKit

class HomeFlow: Flow {
    lazy var rootViewController = UINavigationController().then {
        $0.navigationBar.isHidden = true
    }
    
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
        case .detail(let id):
            return navigateToDetailScreen(id: id)
        case .exit:
            return popViewContoller()
        default:
            return .none
        }
    }
    
    private func setupHomeScreen() -> FlowContributors {
        let homeVC = HomeViewController(reactor: reactor)
        
        rootViewController.pushViewController(homeVC, animated: false)
        return .none
    }
    
    private func navigateToDetailScreen(id: Int) -> FlowContributors {
        let flow = DetailFlow(rootViewController: self.rootViewController)
        
        let nextStep = OneStepper(withSingleStep: HomeSteps.detailInitialized(id: id))
        
        return .one(flowContributor: .contribute(withNextPresentable: flow, withNextStepper: nextStep))
    }
    
    private func popViewContoller() -> FlowContributors {
        rootViewController.popViewController(animated: false)
        return .none
    }
}
