//
//  Config.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/30.
//  Copyright © 2020 creazylee. All rights reserved.
//

import Foundation
import RealmSwift

let cacheDatabaseName = "SPHCache.realm"
class DBConfig {
    func createDB() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(cacheDatabaseName)
        Realm.Configuration.defaultConfiguration = config
    }
}

