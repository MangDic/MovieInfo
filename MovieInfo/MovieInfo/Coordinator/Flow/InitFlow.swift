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
        $0.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.9076858163, green: 0.9191125035, blue: 0.9189115167, alpha: 1)
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
        
        let homeItem = UITabBarItem(title: "Home", image: UIImage.init(systemName: "house"), tag: 0)
        homeFlow.rootViewController.tabBarItem = homeItem
        
        Flows.use([homeFlow], when: .created, block: { root in
            self.rootViewController.setViewControllers(root, animated: false)
        })
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: homeFlow, withNextStepper: homeReactor)])
    }
}
