//
//  Observable+mapper.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya
import RxSwift

/// 定义数据转JSON协议
public protocol Mapable {
    init(jsonData: JSON);
}

/// 定义网络错误代码
enum NetworkError: Swift.Error {
    case NoMoyaResponse //response 错误
    case FailureHTTP //网络请求失败
    case NoData //没有数据
}

/// 扩展Map
extension Observable {
    /// 数据转JSON
    fileprivate func resultToJson<T: Mapable>(_ jsonData: JSON, ModelType: T.Type) -> T? {
        return T(jsonData: jsonData);
    }
    
    func mapResponseToObject<T: Mapable>(_ type: T.Type) -> Observable<T?> {
        return map { representor in
            //检查是否是Moya.Response
            guard let response = representor as? Moya.Response else {
                throw NetworkError.NoMoyaResponse
            }
            
            //检查是否是一次成功的响应
            guard ((200...209) ~= response.statusCode) else {
                throw NetworkError.FailureHTTP
            }
            
            //将data转为JSON
            let json = try! JSON.init(data: response.data)
            
            //判断请求状态
            let code = json["success"].boolValue;
            if (code) {
                return self.resultToJson(json["result"], ModelType: type)
            }else {
                throw NetworkError.NoData
            }
        }
    }
    
    /// 数据为数组的用这个转
    func mapResponseToArray<T: Mapable>(_ type: T.Type) -> Observable<[T]> {
        return map { response in
            guard let response = response as? Moya.Response else {
                throw NetworkError.NoMoyaResponse
            }
            
            guard ((200...209) ~= response.statusCode) else {
                throw NetworkError.FailureHTTP
            }
            
            let json = try! JSON.init(data: response.data)
            let code = json["success"].boolValue;
            if (code) {
                    //建立一个模型数组(T为泛型)
                    var objects = [T]()
                    //获取数据包字段中的数据用JSON转为Array类型
                    let objectsArrays = json["records"].array
                    
                    if let array = objectsArrays {
                        //遍历数组
                        for object in array {
                            //将对象转为模型加入数组
                            if let obj = self.resultToJson(object, ModelType:type) {
                                objects.append(obj)
                            }
                        }
                    return objects
                }else {
                    throw NetworkError.NoData
                }
            }else {
                throw NetworkError.NoData
            }
        }
    }

}

