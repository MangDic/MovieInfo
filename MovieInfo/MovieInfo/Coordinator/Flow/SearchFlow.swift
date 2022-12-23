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
    lazy var rootViewController = UINavigationController()
    
    var root: Presentable {
        return rootViewController
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? SearchSteps else { return .none }
        
        switch step {
        case .initialized:
            return setupSearchScreen()
        }
    }
    
    private func setupSearchScreen() -> FlowContributors {
        let searchVC = SearchViewController()
        rootViewController.pushViewController(searchVC, animated: false)
        return .none
    }
}
