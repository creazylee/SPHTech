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
enum NetworkResultCode: Swift.Error {
    case Success //请求成功
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
    
    func mapResponseToObject<T: Mapable>(_ type: T.Type) -> Observable<RepsonseModel<T>> {
        return map { representor in
            var responseModel = RepsonseModel<T>.init()
            //检查是否是Moya.Response
            guard let response = representor as? Moya.Response else {
                responseModel.code = .NoMoyaResponse
                responseModel.errorMsg = "返回对象错误"
                return responseModel
            }
            
            //检查是否是一次成功的响应
            guard ((200...209) ~= response.statusCode) else {
                responseModel.code = .FailureHTTP
                responseModel.errorMsg = "网络请求异常"
                return responseModel
            }
            
            //将data转为JSON
            let json = try! JSON.init(data: response.data)
            
            //判断请求状态
            let code = json["success"].boolValue;
            if (code) {
                responseModel.code = .Success
                responseModel.data = self.resultToJson(json["result"], ModelType: type)
                
                return responseModel
            }
            
            responseModel.code = NetworkResultCode.NoData
            responseModel.errorMsg = "接口异常"
            return responseModel
        }
    }
}

