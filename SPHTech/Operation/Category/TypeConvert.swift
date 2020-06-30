//
//  TypeConvert.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/29.
//  Copyright © 2020 creazylee. All rights reserved.
//

import Foundation
import CoreGraphics

protocol TypeConvert {
    
}
extension Int:TypeConvert {
    func toString() -> String {
        return "\(self)"
    }

    func toFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat:TypeConvert {
    func toString() -> String {
        return String.init(format: "%f", self)
    }
    
    func toString(_ decimal: Int) -> String {
        return String.init(format: "%.\(decimal)f", self)
    }
}

extension String:TypeConvert {
    func toFloat() -> CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
}

extension Dictionary: TypeConvert {
    /// 按ascii排序后的md5
    func sortWithASCIIMD5Str() -> String {
        let params: Dictionary<String, Any> = self as! Dictionary<String, Any>
        
        let sortDict = params.sorted { (arg0, arg1) -> Bool in
            let v = arg0.key.compare(arg1.key)
            if(v == .orderedAscending) {
                return false
            }
            return true
        }
        var str: String = ""
        for (key, value) in sortDict {
            str = str + "\(key)=\(value)"
        }
        
        return str
    }
}

