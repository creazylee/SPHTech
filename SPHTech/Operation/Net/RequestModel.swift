//
//  RequestModel.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class RequestModel {
    private let provider = MoyaProvider<ApiManager>();
    
    func loadData<T: Mapable>(_ model: T.Type, token: ApiManager) -> Observable<T?> {
        return provider.offlineCacheRequest(token: token)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .catchError { (error) -> Observable<Response> in
                return Observable.empty()
            }.mapResponseToObject(T.self)
    }
}
