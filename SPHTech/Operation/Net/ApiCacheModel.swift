//
//  ApiCacheModel.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/30.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit
import RealmSwift

class ApiCacheModel: Object {
    @objc dynamic var data: Data? = nil
    @objc dynamic var statusCode: Int = 0
    @objc dynamic var key: String = ""
    
    override static func primaryKey() -> String? {
        return "key"
    }
}
