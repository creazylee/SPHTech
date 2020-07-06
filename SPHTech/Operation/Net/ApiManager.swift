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
        switch self {
        case .datastore_search(let resource_id,_):
            if resource_id != "" {
                return "{\"help\": \"https://data.gov.sg/api/3/action/help_show?name=datastore_search\", \"success\": true, \"result\": {\"resource_id\": \"a807b7ab-6cad-4aa6-87d0-e283a7353a0f\", \"fields\": [{\"type\": \"int4\", \"id\": \"_id\"}, {\"type\": \"text\", \"id\": \"quarter\"}, {\"type\": \"numeric\", \"id\": \"volume_of_mobile_data\"}], \"records\": [{\"volume_of_mobile_data\": \"0.000384\", \"quarter\": \"2004-Q3\", \"_id\": 1}, {\"volume_of_mobile_data\": \"0.000543\", \"quarter\": \"2004-Q4\", \"_id\": 2}, {\"volume_of_mobile_data\": \"0.00062\", \"quarter\": \"2005-Q1\", \"_id\": 3}, {\"volume_of_mobile_data\": \"0.000634\", \"quarter\": \"2005-Q2\", \"_id\": 4}, {\"volume_of_mobile_data\": \"0.000718\", \"quarter\": \"2005-Q3\", \"_id\": 5}], \"_links\": {\"start\": \"/api/action/datastore_search?limit=5&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f\", \"next\": \"/api/action/datastore_search?offset=5&limit=5&resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f\"}, \"limit\": 5, \"total\": 59}}".data(using: String.Encoding.utf8)!
            }else {
                return "404 Not Found,未找到资源id".data(using: String.Encoding.utf8)!
            }
            break
        default:
            break
        }
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
