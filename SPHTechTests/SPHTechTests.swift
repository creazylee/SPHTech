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
import Moya

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
    
    func testMockApiRequest() {
        let ex = XCTestExpectation.init(description: "mock success")
        
        let endpointClosure = {(target: ApiManager) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            return Endpoint.init(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: nil)
        }
        
        let apiProvider = MoyaProvider<ApiManager>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        apiProvider.offlineCacheRequest(token: ApiManager.datastore_search(resource_id: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 10)).subscribe(onNext: { event in
            assert(event.statusCode == 200, "请求成功")
            ex.fulfill()
            }).disposed(by: disposeBag)
        
        self.wait(for: [ex], timeout: 30)
    }
    
    func testMockAPIRequest_neterror() {
        let ex = XCTestExpectation.init(description: "mock net error")
        let endpointClosure = {(target: ApiManager) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let error = NSError.init(domain: url, code: -999, userInfo: ["description":"网络错误"])
            return Endpoint.init(url: url, sampleResponseClosure: {.networkError(error)}, method: target.method, task: target.task, httpHeaderFields: nil)
        }
        
        let apiProvider = MoyaProvider<ApiManager>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        apiProvider.offlineCacheRequest(token: ApiManager.datastore_search(resource_id: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 10)).subscribe(onNext: { event in
            assert(event.statusCode == -999, "网络错误")
            ex.fulfill()
            }).disposed(by: disposeBag)
        self.wait(for: [ex], timeout: 30)
    }
    
    func testMockAPIRequest_resourceIdError() {
        let ex = XCTestExpectation.init(description: "mock resourceid error")
        let endpointClosure = {(target: ApiManager) -> Endpoint in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let error = NSError.init(domain: url, code: 404, userInfo: ["description":"未找到资源"])
            return Endpoint.init(url: url, sampleResponseClosure: {.networkError(error)}, method: target.method, task: target.task, httpHeaderFields: nil)
        }
        
        let apiProvider = MoyaProvider<ApiManager>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        apiProvider.offlineCacheRequest(token: ApiManager.datastore_search(resource_id: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 10)).subscribe(onNext: { event in
            assert(event.statusCode == -999, NSString(data:event.data ,encoding: String.Encoding.utf8.rawValue)! as String)
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
