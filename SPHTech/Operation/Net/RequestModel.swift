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
import SwiftyJSON

class RequestModel {
    private let provider = MoyaProvider<ApiManager>();
    
    func loadData<T: Mapable>(_ model: T.Type, token: ApiManager) -> Observable<RepsonseModel<T>> {
        return provider.offlineCacheRequest(token: token)
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
            .distinctUntilChanged()
            .mapResponseToObject(T.self)
    }
}

struct RepsonseModel<T: Mapable> {
    var code: NetworkResultCode!
    var errorMsg: String?
    var data: T?
}
