//
//  ChartModel.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import SwiftyJSON
import Foundation

struct ChartModel:Mapable {
    
    let resource_id: String
    let fileds: Array<Any>
    let records: Array<ChartRecordsModel>
   
    var dataModel: Dictionary<String, Array<ChartRecordsModel>>?
    
    var yearKeys: Array<String> = Array<String>();

    init(jsonData: JSON) {
        self.resource_id = jsonData["resource_id"].stringValue;
        let r = jsonData["records"].array ?? [];
        var objects = Array<ChartRecordsModel>()
        
        var tmpModel = Dictionary<String, Array<ChartRecordsModel>>();
        for object in r {
            //将对象转为模型加入数组
            let obj: ChartRecordsModel = ChartRecordsModel(jsonData: object);
            let dateList = obj.quarter.components(separatedBy: "-");//将quarter分割成年，季度
            // 拆分数据并过滤d2008-2018年的数据
            if dateList.count == 2 {
                let year = dateList[0];// 年
                if year.toInt() < 2008 || year.toInt() > 2018 {
                    continue
                }
                var tmpList = tmpModel[year] ?? Array<ChartRecordsModel>();
                tmpList.append(obj);
                tmpModel.updateValue(tmpList, forKey: year);
                objects.append(obj)
            }
        }
        
        self.dataModel = tmpModel;
        
        self.yearKeys = (self.dataModel?.keys.sorted(by: >))!;
        
        self.records = objects;
        self.fileds = jsonData["records"].array ?? [];
    }
}

struct ChartRecordsModel:Mapable {
    let volume_of_mobile_data: String
    let quarter: String
    let _id: Int
    
    init(jsonData: JSON) {
        self.volume_of_mobile_data = jsonData["volume_of_mobile_data"].stringValue;
        self.quarter = jsonData["quarter"].stringValue;
        self._id = jsonData["_id"].intValue;
    }
}
