//
//  RxMoya+Provider.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension MoyaProvider {
    func offlineCacheRequest(token: Target, callbackQueue: DispatchQueue? = nil) -> Observable<Moya.Response> {
        return Observable.create { [weak self](observer) -> Disposable in
            print("start");
            
            let cancelToken = self?.request(token) { Result in
                switch Result {
                    case let .success(response):
                        observer.onNext(response)
                        observer.onCompleted()
                        print("request success")
                        break
                    case let .failure(error):
                        observer.onError(error)
                        print(error)
                        break
                }
            }
            
            return Disposables.create {
                cancelToken?.cancel();
            }
        }
    }
}
