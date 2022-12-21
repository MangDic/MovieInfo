//
//  MovieService.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import Moya
import Foundation

enum MovieService {
    case loadMovie(page: Int, count: Int)
}

extension MovieService: TargetType {
    var baseURL: URL {
        return URL(string: NetworkController.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .loadMovie:
            return "/hoppin/movies"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .loadMovie:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .loadMovie(let page, let count):
            let params: [String: Any] = [
                "order": "releasedateasc",
                "count": count,
                "page": page,
                "version": 1,
                "genreId": ""
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return ["Content-Type" : "application/json"]
        }
    }
}

extension MovieService {
    enum Error: Swift.Error {
        case serverMaintenance(message: String)
        // 비정상 응답 (오류코드)
        case failureResponse(api: MovieService, code: MovieService.ResultCode, desc: String)
        // 잘못된 응답 데이터 (발생시 서버 문의)
        case invalidResponseData(api: MovieService)
    }

    enum ResultCode: String {
        case er = "-1"
    }
}
