//
//  SPHTechExtensionTests.swift
//  SPHTechTests
//
//  Created by creazylee on 2020/6/30.
//  Copyright © 2020 creazylee. All rights reserved.
//

import XCTest
@testable import SPHTech

class SPHTechExtensionTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// 正确字符串转int
    func testOnlyNumberString_Convert_Int() {
        let a = "1".toInt()
        assert(a==1, "值转换错误")
    }
    /// 非数字字符串转int
    func testString_Convert_Int() {
        let a = "1a".toInt()
        assert(a==0, "异常转换")
    }
    /// 正确字符串转float
    func testOnlyNumberString_Convert_NSFloat()  {
        let a = "1.35".toFloat()
        assert(a==1.35,"值转换错误")
    }
    /// 非数字字符串转float
    func testString_Convert_NSFloat() {
        let a = "1.25a".toFloat()
        assert(a==0, "异常转换")
    }
    
    /// int 转 字符串
    func testInt_Convert_String() {
        let a = 10.toString()
        XCTAssertEqual(a, "10", "值转换错误")
        let b = (-100).toString()
        XCTAssertEqual(b, "-100", "负数转换失败")
    }
    
    /// int 转float
    func testInt_Convert_CGFloat() {
        let a = 10.toFloat()
        assert(a==10, "值转换错误")
        let b = (-100).toFloat()
        assert(b==(-100), "负数转换失败")
    }
    
    /// cgfloat 转 string
    func testCGFloat_Convert_String() {
        let a: CGFloat = 10.98
        let s = a.toString()
        XCTAssertEqual(s, "10.98", "值转换错误")
        let b: CGFloat = -100.987
        let s1 = b.toString()
        XCTAssertEqual(s1, "-100.987", "负数转换失败")
    }
    
    /// cgfloat转string并指定保留小数位数,并四舍五入
    func testCGFloat_Convert_decimalString() {
        /// 补位
        let a: CGFloat = 10.98
        let s = a.toString(3)
        XCTAssertEqual(s, "10.980", "值转换错误")
        /// 五入
        let b: CGFloat = -100.987
        let s1 = b.toString(2)
        XCTAssertEqual(s1, "-100.99", "转换失败")
        /// 四舍
        let c: CGFloat = -100.982
        let s2 = c.toString(2)
        XCTAssertEqual(s2, "-100.98", "转换失败")
        
        /// 特殊情况 0
        let d: CGFloat = 0
        let s3 = d.toString(2)
        XCTAssertEqual(s3, "0.00", "转换失败")
    }
    
    /// 测试排序
    func testDict_Convert_String_And_Sort() {
        /// 大写排序
        let a = ["B":"2","A":"1","C":"3"].toParamsAndSort()
        XCTAssertEqual(a, "A=1&B=2&C=3", "排序错误")
        /// 大小写
        let b = ["B":"2","a":"1","C":"3"].toParamsAndSort()
        XCTAssertEqual(b, "B=2&C=3&a=1", "排序错误")
        /// 含数字
        let c = ["B":"2","2":"1","C":"3"].toParamsAndSort()
        XCTAssertEqual(c, "2=1&B=2&C=3", "排序错误")
    }
    
    /// 测试16进制字符串转uicolor
    func testHexString_Convert_UIColor() {
        /// 错误的颜色代码，默认转换为透明色
        let color = UIColor.hexColor("#00")
        XCTAssertEqual(color, UIColor.clear, "异常处理失败")
        /// 正确的颜色转换
        let color1 = UIColor.hexColor("#FF0000")
        XCTAssertEqual(color1, UIColor.red, "红色转换错误")
        /// 超过正常位数的转换
        let color2 = UIColor.hexColor("#FF0009988")
        XCTAssertEqual(color2, UIColor.clear, "异常处理失败")
        /// 正确的颜色转换
        let color3 = UIColor.hexColor("0XFF0000")
        XCTAssertEqual(color3, UIColor.red, "红色转换错误")
    }
    
    /// 获取文字宽度
    func testString_Convert_Width() {
        let str = "长度计算"
        let a = str.getTextWidth(fontSize: 12)
        XCTAssertEqual(a, 4*12+5, accuracy: 2*4, "宽度计算超过预期")
        
        let str1 = "12344"
        let a1 = str1.getTextWidth(fontSize: 12)
        XCTAssertEqual(a1, 5*12*0.6+5, accuracy: 2*5, "宽度计算超过预期")
        
        /// 空字符串计算
        let a2 = "".getTextWidth(fontSize: 12)
        XCTAssertEqual(a2, 5, accuracy: 0, "宽度计算超过预期")
    }
    // md5
    func testStringMD5() {
        let a = "md5".md5
        assert(a.count == 32, "md5失败")
    }
    
    /// 获取2个点的中心点
    func testUIBezierPath_get_centerPoint() {
        let p1 = CGPoint.init(x: 10, y: 20)
        let p2 = CGPoint.init(x: 20, y: 20)
//        let p3 =
        
    }
    
}
