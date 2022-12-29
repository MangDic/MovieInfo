//
//  SearchSteps.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/22.
//

import RxFlow

enum SearchSteps: Step {
    case initialized
    case detail(id: Int)
}
