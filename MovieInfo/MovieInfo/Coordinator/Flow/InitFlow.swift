//
//  InitFlow.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import RxFlow
import UIKit

class InitFlow: Flow {
    lazy var rootViewController = UITabBarController().then {
        $0.tabBar.barTintColor = .black
        $0.tabBar.selectedImageTintColor = .white
        $0.tabBar.tintColor = .white
        $0.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    var root: Presentable {
        return self.rootViewController
    }
    
    func navigate(to step: RxFlow.Step) -> RxFlow.FlowContributors {
        guard let step = step as? MainSteps else { return .none }
        
        switch step {
        case .initialized:
            return setupTabBar()
        default:
            return .none
        }
    }
    
    private func setupTabBar() -> FlowContributors{
        let homeReactor = HomeReactor()
        
        let homeFlow = HomeFlow(reactor: homeReactor)
        let searchFlow = SearchFlow()
        
        let homeItem = UITabBarItem(title: "트랜드", image: UIImage.init(systemName: "house"), tag: 0)
        homeFlow.rootViewController.tabBarItem = homeItem
        
        let searchItem = UITabBarItem(title: "검색", image: UIImage.init(systemName: "magnifyingglass"), tag: 1)
        searchFlow.rootViewController.tabBarItem = searchItem
        
        Flows.use([homeFlow, searchFlow], when: .created, block: { root in
            self.rootViewController.setViewControllers(root, animated: false)
        })
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: homeReactor),
            .contribute(withNextPresentable: searchFlow, withNextStepper: OneStepper(withSingleStep: SearchSteps.initialized))
        ])
    }
}
