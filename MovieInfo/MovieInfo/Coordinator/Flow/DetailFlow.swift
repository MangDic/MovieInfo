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
    
    init(rootViewController: UINavigationController) {
        self.root = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeSteps else { return .none }
        switch step {
        case .detailInitialized(let id):
            return setupDetailScreen(id: id)
        default:
            return .none
        }
    }
    
    private func setupDetailScreen(id: Int) -> FlowContributors {
        let reactor = DetailReactor(id: id)
        let vc = DetailViewController(reactor: reactor)
        
        (root as! UINavigationController).pushViewController(vc, animated: false)
        return .none
    }
}
