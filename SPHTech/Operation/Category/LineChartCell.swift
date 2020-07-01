//
//  LineChartCell.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/29.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class LineChartCell: BaseCell {
    
    var lineChartView:LineChartView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        createUI()
    }
    
    func createUI() {
        self.lineChartView = LineChartView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: 200))
        self.contentView.addSubview(self.lineChartView)
    }
    
    override func parseData(_ data: Any) {
        
        let list:Array<ChartRecordsModel> = data as! Array<ChartRecordsModel>
        
        var maxNum: CGFloat = 0
        var minNum: CGFloat = CGFloat(MAXFLOAT)
        var lineData: Array<CGFloat> = [CGFloat]()
        var horizontalData: Array<String> = [String]()
        for model in list {
            horizontalData.append(model.quarter )
            lineData.append(model.volume_of_mobile_data.toFloat())
            maxNum = max(maxNum, model.volume_of_mobile_data.toFloat())
            minNum = min(minNum, model.volume_of_mobile_data.toFloat())
        }
        
        self.lineChartView.max = Int(ceilf(Float(maxNum)))
        self.lineChartView.min = Int(floor(Float(minNum)))
        self.lineChartView.horizontalDataArr = horizontalData
        self.lineChartView.lineDataAry = lineData;
        self.lineChartView.splitCount = 2;
        self.lineChartView.toCenter = false;
        self.lineChartView.supplement = true
        self.lineChartView.drawLineChart()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
