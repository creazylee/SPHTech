//
//  SPHTechTests.swift
//  SPHTechTests
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import XCTest
import RealmSwift
import RxSwift
@testable import SPHTech

class SPHTechTests: XCTestCase {
    
    let requestModel = RequestModel()
    let disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCacheModelPrimaryKey() {
        let k = ApiCacheModel.primaryKey()
        XCTAssertEqual(k, "key", "数据库主键设置错误")
    }
    
    func testBaseCell_Func_itExist() {
        let cell = BaseCell.init(style: .default, reuseIdentifier: "basecell")
        XCTAssertNoThrow(cell.parseData(""))
        XCTAssertNoThrow(cell.parseData("", indexPath: IndexPath.init(row: 0, section: 0)))
    }
    
    /// 使用错误的参数请求网络
    func testApiRequest_ErrorParams() {
        let ex = XCTestExpectation.init(description: "net")
        
        requestModel.loadData(ChartModel.self, token: ApiManager.datastore_search(resource_id: "aaa", limit: 100)).subscribe( onNext: { event in
            XCTAssertEqual(event.code, NetworkResultCode.FailureHTTP, "无数据")
            ex.fulfill()
        }).disposed(by: disposeBag)
        self.wait(for: [ex], timeout: 30)
    }
    
    /// 使用
    func testApiRequest() {
        let ex = XCTestExpectation.init(description: "netsuccess")
        
        requestModel.loadData(ChartModel.self, token: ApiManager.datastore_search(resource_id: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 10)).subscribe( onNext: { event in
            XCTAssertFalse(event.code == NetworkResultCode.NoData, "服务器错误，无数据返回")
            XCTAssertFalse(event.code == NetworkResultCode.FailureHTTP, "网络错误")
            XCTAssertFalse(event.code == NetworkResultCode.NoMoyaResponse, "系统内部错误")
            assert(event.data != nil, "无数据")
            XCTAssertEqual(event.data?.limit, 10, "数据不足")
            ex.fulfill()
        }).disposed(by: disposeBag)
        self.wait(for: [ex], timeout: 30)
    }
    
    
    /// 测试下降图标能否正确显示
    func testCell_declineImage() {
        var list:Array<ChartRecordsModel> = [ChartRecordsModel]()
        
        let m1: ChartRecordsModel = ChartRecordsModel.init(quarter: "2020-Q1", _id: 1, volume_of_mobile_data: "8.98")
        let m2: ChartRecordsModel = ChartRecordsModel.init(quarter: "2020-Q2", _id: 2, volume_of_mobile_data: "6.98")
        let m3: ChartRecordsModel = ChartRecordsModel.init(quarter: "2020-Q2", _id: 3, volume_of_mobile_data: "9.98")
        let m4: ChartRecordsModel = ChartRecordsModel.init(quarter: "2020-Q2", _id: 4, volume_of_mobile_data: "5.98")

        list.append(m1)
        list.append(m2)
        list.append(m3)
        list.append(m4)
        
        let cell: LineChartCell = LineChartCell.init(style: .default, reuseIdentifier: "LineChartCell")
        cell.parseData(list)
        let decline = cell.lineChartView.viewWithTag(103)
        assert(decline != nil, "视图不存在")
        assert(!(decline!.isHidden), "视图未正确显示")
    }
}
