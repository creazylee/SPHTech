//
//  LineChartView.swift
//  SPHTech
//
//  Created by 李峥 on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class LineChartView: UIView {
    
    /// 折线关键点用来显示的数据
    var lineDataAry: Array<NSNumber> = [NSNumber]()
    /// 底部横向显示文字
    var horizontalDataArr: Array<String> = [String]()
    var max: Int = 0
    var min: Int = 0
    var splitCount: Int = 0
    var circleRadius: CGFloat = 3
    var lineWidth: CGFloat = 1.5
    var horizontalLineWidth: CGFloat = 0.5
    var horizontalBottomLineWidth: CGFloat = 1
    var textFontSize: CGFloat = 10
    var edge: UIEdgeInsets = UIEdgeInsets(top: 25, left: 5, bottom: 40, right: 15)

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLineChart() {
        var pointArr: Array<NSValue> = [NSValue]()
        let labelHeight: CGFloat = self.textFontSize
        let numSpace: Int = (self.max - self.min) / self.splitCount;
        let spaceY = (self.frame.size.height - self.edge.top - self.edge.bottom - ((self.splitCount + 1) * labelHeight)) / self.splitCount;
    }
}
