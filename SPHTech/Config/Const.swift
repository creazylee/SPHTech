//
//  Const.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//
import UIKit
import CoreGraphics

// MARK - 服务器配置
let API_ADDRESS = "https://data.gov.sg/"



// MARK - 常量
var ScreenBounds: CGRect = UIScreen.main.bounds
var ScreenWidth: CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
var ScreenHeight:CGFloat = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

var IS_iPhoneX: Bool = (ScreenHeight >= 812)
var SafeAreaBottom: CGFloat = IS_iPhoneX ? 34 : 0
var SafeAreaTop: CGFloat = IS_iPhoneX ? 24 : 0
var NavigationHeight: CGFloat = IS_iPhoneX ? 88 : 64
