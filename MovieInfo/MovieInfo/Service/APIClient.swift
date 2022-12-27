//
//  MovieProvider.swift
//  MovieInfo
//
//  Created by 이명직 on 2022/12/20.
//

import Foundation
import Moya
import RxCocoa
import RxSwift
import RxMoya

struct APIClient {
    private static let provider = MoyaProvider<MovieService>()
    
    static func request<T: Decodable>(_ api: MovieService) -> Single<T> {
        let request = Single<T>.create { observer in
            let observable = APIClient.provider.rx
                .request(api)
                .subscribe { event in
                    switch event {
                    case .success(let response):
                        do {
//                            if let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String : Any] {
//                                print(json)
//                            }
                            let data = try response.map(T.self)
                            observer(.success(data))
                        }
                        catch {
                            observer(.failure(error))
                        }
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            return Disposables.create {
                observable.dispose()
            }
        }.observe(on: MainScheduler.instance)
        
        return request
    }
}
