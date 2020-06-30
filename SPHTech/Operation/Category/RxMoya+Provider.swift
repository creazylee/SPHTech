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
import RealmSwift

extension MoyaProvider {
    func offlineCacheRequest(token: Target, callbackQueue: DispatchQueue? = nil) -> Observable<Moya.Response> {
        return Observable.create { [weak self](observer) -> Disposable in
            print("start");
            var key = token.baseURL.absoluteString + token.path
            switch token.task {
            case .requestParameters(let parameters, _):
                let sortStr = parameters.sortWithASCIIMD5Str()
                key += sortStr
                break
            default:
                break
            }
            
            key = key.md5
            
            let realm = try! Realm()
            let pre = NSPredicate.init(format: "key = %@", key)
            let cacheResponse = realm.objects(ApiCacheModel.self).filter(pre)
            
            if cacheResponse.count != 0 {
                let filterResult = cacheResponse[0];
                //还原成response并返回
                let createResponse = Response.init(statusCode: filterResult.statusCode, data: filterResult.data!)
                observer.onNext(createResponse)
            }
            
            let cancelToken = self?.request(token) { Result in
                switch Result {
                    case let .success(response):
                        observer.onNext(response)
                        observer.onCompleted()
                        //增加缓存
                        let realm = try! Realm()
                        let cache = ApiCacheModel()
                        cache.data = response.data
                        cache.statusCode = response.statusCode
                        cache.key = key
                        try! realm.write {
                            realm.add(cache, update: .all)
                        }
                        print("request success")
                        break
                    case let .failure(error):
                        let reponse = Response.init(statusCode: -999, data: error.errorDescription?.data(using: String.Encoding.utf8) ?? Data.init())
                        observer.onNext(reponse)
                        observer.onCompleted()
                        print("request error")
                        break
                }
            }
            
            return Disposables.create {
                cancelToken?.cancel();
            }
        }
    }
    
    
}
