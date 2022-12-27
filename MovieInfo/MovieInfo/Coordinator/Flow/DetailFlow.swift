//
//  DetailFlow.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/22.
//

import Foundation
import RxFlow
import UIKit

class DetailFlow: Flow {
    var root: RxFlow.Presentable
    
    var reactor: DetailReactor
    
    init(rootViewController: UINavigationController, reactor: DetailReactor) {
        self.root = rootViewController
        self.reactor = reactor
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeSteps else { return .none }
        switch step {
        case .detailInitialized:
            return setupDetailScreen()
        case .exit:
            return popViewContoller()
        default:
            return .none
        }
    }
    
    private func setupDetailScreen() -> FlowContributors {
        let vc = DetailViewController(reactor: reactor)
        
        (root as! UINavigationController).pushViewController(vc, animated: false)
        return .none
    }
    
    private func popViewContoller() -> FlowContributors {
        (root as! UINavigationController).popViewController(animated: false)
        return .none
    }
}
