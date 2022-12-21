//
//  AppStepper.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import RxFlow
import RxCocoa

class AppStepper: Stepper {
    var steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return MainSteps.initialized
    }
}
