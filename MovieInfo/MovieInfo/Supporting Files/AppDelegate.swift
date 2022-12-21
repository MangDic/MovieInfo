//
//  AppDelegate.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import UIKit
import RxFlow

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coordinator = FlowCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        let initFlow = InitFlow()
        let appStepper = AppStepper()
        coordinator.coordinate(flow: initFlow, with: appStepper)
        
        window.rootViewController = initFlow.rootViewController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        return true
    }
}

