//
//  MovieService.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import Moya
import Foundation

enum MovieService {
    case loadMovie
    case detail(id: Int)
}

extension MovieService: TargetType {
    var baseURL: URL {
        return URL(string: NetworkController.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .loadMovie:
            return "/trending/movie/week"
        case .detail(let id):
            return "movie/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .loadMovie, .detail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            let params = [
                "api_key":"\(NetworkController.apiKey)",
                "language": "ko"
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
