//
//  ApiManager.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit
import Moya

enum ApiManager {
    case datastore_search(resource_id: String, limit: Int)
}


extension ApiManager: Moya.TargetType {
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    var path: String {
        switch self {
        case .datastore_search:
            return "api/action/datastore_search";
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .datastore_search:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!;
    }
    
    var task: Moya.Task {
        switch self {
        case .datastore_search(let resource_id, let limit):
            var params: [String: Any] = [:]
            params["resource_id"] = resource_id
            params["limit"] = limit
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var baseURL: URL {
        return URL.init(string: API_ADDRESS)!;
    }
}
