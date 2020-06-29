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

