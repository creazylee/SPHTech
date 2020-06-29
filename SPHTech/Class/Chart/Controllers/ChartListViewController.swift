//
//  ChartListViewController.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit
import Moya
import RxSwift

enum ListMode {
    case list
    case chart
}

class ChartListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var mTable: UITableView!
    
    var chartModel: ChartModel?
    let requestModel = RequestModel()
    let disposeBag = DisposeBag()
    var dataSource:[CGFloat] = [CGFloat]()
    var titleSource:[String] = [String]()

    var rightItemButton: UIButton!
    
    var showMode: ListMode = .chart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SPHTech";
        
        self.mTable.register(UINib.init(nibName: "ChartListCell", bundle: nil), forCellReuseIdentifier: "ChartListCell")
        
        requestModel.loadData(ChartModel.self, token: ApiManager.datastore_search(resource_id: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 100)).subscribe( onNext: { event in
            print(event?.resource_id ?? "")
            //处理数据
            self.chartModel = event;
            self.mTable.reloadData();
        }).disposed(by: disposeBag)
        
        initUI()
    }
    
    func initUI() {
        let rightBtn: UIButton = UIButton.init(type: .custom)
        if self.showMode == .list {
            rightBtn.setImage(UIImage.init(named: "chart-line"), for: .normal)
        }else {
            rightBtn.setImage(UIImage.init(named: "chart-list"), for: .normal)
        }
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24)
        rightBtn.addTarget(self, action: #selector(clickChangeModel), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        self.rightItemButton = rightBtn
    }
    
    /// 点击右上角按钮切换列表显示模式
    @objc func clickChangeModel() {
        if self.showMode == .list {
            self.showMode = .chart
            self.rightItemButton.setImage(UIImage.init(named: "chart-list"), for: .normal)
        }else {
            self.showMode = .list
            self.rightItemButton.setImage(UIImage.init(named: "chart-line"), for: .normal)
        }
        
        self.mTable.reloadData()
    }
    
    /// tableview delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chartModel?.yearKeys.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showMode == .chart {
            //折线图模式只返回一行
            return 1
        }
        
        let key = self.chartModel?.yearKeys[section] ?? "";
        let values = self.chartModel?.dataModel?[key] ?? [];
        return values.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.showMode == .chart {
            let cellID = String.init(format: "LineChartCell-%d", indexPath.section)
            var cell: LineChartCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? LineChartCell
            if cell == nil {
                cell = LineChartCell.init(style: .default, reuseIdentifier: cellID)
            }
            let key = self.chartModel?.yearKeys[indexPath.section] ?? "";
            let values = self.chartModel?.dataModel?[key] ?? [];
            
            cell?.parseData(values)
            
            return cell!
        }
        
        let cell: ChartListCell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as! ChartListCell
        let key = self.chartModel?.yearKeys[indexPath.section] ?? "";
        let values = self.chartModel?.dataModel?[key] ?? [];
        cell.parseData(values[indexPath.row])
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = self.chartModel?.yearKeys[section] ?? "";
        return key;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.showMode == .chart {
            return 220
        }
        return 32;
    }
}
