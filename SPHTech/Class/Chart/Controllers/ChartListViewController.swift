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

class ChartListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mTable: UITableView!
    var chartModel: ChartModel?
    
    let requestModel = RequestModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SPHTech";
        self.mTable.register(UINib.init(nibName: "ChartListCell", bundle: nil), forCellReuseIdentifier: "ChartListCell")
        
        print("init");
        requestModel.loadData(ChartModel.self, token: ApiManager.datastore_search(resource_id: "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", limit: 100)).subscribe( onNext: { event in
            print(event?.resource_id ?? "")
            //处理数据
            self.chartModel = event;
            self.mTable.reloadData();
        }).disposed(by: disposeBag)
    }
    
    /// tableview delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        print("%d",self.chartModel?.yearKeys.count ?? 0);
        return self.chartModel?.yearKeys.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = self.chartModel?.yearKeys[section] ?? "";
        let values = self.chartModel?.dataModel?[key] ?? [];
        print("%d",values.count)
        return values.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChartListCell = tableView.dequeueReusableCell(withIdentifier: "ChartListCell", for: indexPath) as! ChartListCell
        let key = self.chartModel?.yearKeys[indexPath.section] ?? "";
        let values = self.chartModel?.dataModel?[key] ?? [];
        cell.parseData(values[indexPath.row])
        
        return UITableViewCell.init();
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
        return 32;
    }
}
