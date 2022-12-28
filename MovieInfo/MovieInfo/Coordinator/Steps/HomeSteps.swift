//
//  HomeSteps.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/21.
//

import RxFlow

enum HomeSteps: Step {
    case initialized
    case detail(id: Int)
    case detailInitialized
    case exit
    case none
}
