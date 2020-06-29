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
    var lineDataAry: Array<CGFloat> = [CGFloat]()
    /// 底部横向显示文字
    var horizontalDataArr: Array<String> = [String]()
    /// 纵轴最大值
    var max: Int = 0
    /// 纵轴最小值
    var min: Int = 0
    /// Y轴分割个数
    var splitCount: Int = 3
    /// 关键点圆半径（默认3）
    var circleRadius: CGFloat = 3
    /// 折线宽（默认1.5）
    var lineWidth: CGFloat = 1.5
    /// 折线颜色
    var lineColor: UIColor = UIColor.hexColor("#428eda")
    /// 横向分割线宽（默认0.5)
    var horizontalLineWidth: CGFloat = 0.5
    /// 底部横向分割线宽（默认1）
    var horizontalBottomLineWidth: CGFloat = 1
    var horizontalBottomLineColor: UIColor = UIColor.hexColor("#428eda")
    var horizontalLineColor: UIColor = UIColor.hexColor("#e8e8e8")
    /// 文本字号（默认10）
    var textFontSize: CGFloat = 10
    /// 边界
    var edge: UIEdgeInsets = UIEdgeInsets(top: 25, left: 5, bottom: 40, right: 15)
    /// 纵轴文本显示宽度
    var leftTextWidth: CGFloat = 0
    /// 纵向横向显示文本颜色
    var textColor: UIColor = UIColor.hexColor("#666666")
    /// 关键点文本颜色
    var dataTextColor: UIColor = UIColor.hexColor("#428eda")
    /// 横向分割线距离左边文本偏移距离
    var lineToLeftOffset: CGFloat = 5
    /// 关键点居中显示
    var toCenter: Bool = true
    /// 刻度上下偏移（默认0）
    var scaleOffset: CGFloat = 0
    /// toCenter=YES时是否补充前后显示
    var supplement: Bool = false
    /// 是否只显示X轴头尾,无需显示的文本赋空值可达到同样效果
    var isShowHeadTail: Bool = false
    /// 底部文本上下偏移
    var bottomOffset: CGFloat = 20
    var angle: CGFloat = CGFloat.pi*1.75
    var addCurve: Bool = true
    /// 是否填充颜色渐变
    var showColorGradient: Bool = true
    var colorArr: Array<CGColor>!
    /// 关键点边框颜色
    var circleStrokeColor: UIColor = UIColor.hexColor("#428eda")
    /// 关键点填充颜色
    var circleFillColor: UIColor = UIColor.white
    /// 折线关键点数据是否显示
    var showLineData: Bool = true
    /// 是否显示折线关键点下降警示
    var showDecline: Bool = true
    /// 关键点数据文本显示宽度
    var dataTextWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.white
        self.colorArr = [self.lineColor.withAlphaComponent(0.4).cgColor, UIColor.white.withAlphaComponent(0.1).cgColor]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawLineChart() {
        var pointArr: Array<NSValue> = [NSValue]()
        let labelHeight: CGFloat = self.textFontSize
        let numSpace: Int = (self.max - self.min) / self.splitCount
        let spaceY: CGFloat = (self.frame.size.height - self.edge.top - self.edge.bottom - ((self.splitCount.toFloat() + 1) * labelHeight)) / self.splitCount.toFloat()
        var minMidY: CGFloat = 0.0
        var maxMidY: CGFloat = 0.0
        if (self.leftTextWidth <= 0) {
            let maxStr = self.max.toString()
            self.leftTextWidth = maxStr.getTextWidth(fontSize: self.textFontSize)
        }
        
        for i in 0..<(self.splitCount+1){
            let leftLabel = self.createLabel(textColor: self.textColor, textAlignment: NSTextAlignment.center)
            leftLabel.frame = CGRect.init(x: self.edge.left, y: self.leftTextWidth + (spaceY + labelHeight)*i.toFloat(), width: self.leftTextWidth, height: labelHeight)
            var leftNum = self.max - numSpace*i;
            if i == self.splitCount {
                leftNum = self.min
            }
            leftLabel.text = leftNum.toString()
            self.addSubview(leftLabel)
            
            if i == 0 {
                minMidY = leftLabel.frame.midY
            }
            
            let linePath: UIBezierPath = UIBezierPath.init()
            let minX: CGFloat = leftLabel.frame.maxX + self.lineToLeftOffset
            let maxX: CGFloat = self.frame.maxX - self.edge.right
            linePath.move(to: CGPoint.init(x: minX, y: leftLabel.frame.midY))
            linePath.addLine(to: CGPoint.init(x: maxX, y: leftLabel.frame.midY))
            
            let hLineLayer: CAShapeLayer = CAShapeLayer.init()
            if i == self.splitCount {
                hLineLayer.strokeColor = self.horizontalBottomLineColor.cgColor
                hLineLayer.lineWidth = self.horizontalBottomLineWidth
                
                let toC = self.horizontalDataArr.count.toFloat() - (self.toCenter ? 0 : 1)
                
                let spaceX = (maxX - minX) / (toC <= 0 ? 1 : toC);
                maxMidY = leftLabel.frame.midY
                let bezierPath: UIBezierPath = UIBezierPath.init()
                var count = self.horizontalDataArr.count;
                if (self.toCenter) {
                    count = self.horizontalDataArr.count + 1;
                }
                for j in 0..<count {
                    bezierPath.move(to: CGPoint.init(x: minX + spaceX * j.toFloat(), y: maxMidY + self.scaleOffset))
                    bezierPath.addLine(to: CGPoint.init(x: minX + spaceX * j.toFloat(), y: maxMidY + 2 + self.scaleOffset))
                    linePath.append(bezierPath)
                }
                
                let ratio: CGFloat = (maxMidY - minMidY) / (self.max.toFloat() - self.min.toFloat());
                for k in 0..<self.horizontalDataArr.count {
                    let midX = minX + (spaceX * k.toFloat()) + (self.toCenter ? spaceX / 2 : 0);
                    let tempNum: CGFloat = self.lineDataAry[k];
                    let y = maxMidY - (tempNum - self.min.toFloat()) * ratio;
                    if self.toCenter && self.supplement && k == 0 {
                        let value = NSValue.init(cgPoint: CGPoint.init(x: minX, y: y))
                        pointArr.append(value)
                    }
                    let value = NSValue.init(cgPoint: CGPoint.init(x: midX, y: y))
                    pointArr.append(value)
                    
                    if self.toCenter && self.supplement && k == self.lineDataAry.count - 1 {
                        let value = NSValue.init(cgPoint: CGPoint.init(x: maxX, y: y))
                        pointArr.append(value)
                    }
                    
                    if self.isShowHeadTail && (k > 0 && k < self.horizontalDataArr.count - 1) {
                        continue
                    }
                    if self.horizontalDataArr[k].count == 0 {
                        continue
                    }
                    
                    let bottomLabelWidth: CGFloat = self.horizontalDataArr[k].getTextWidth(fontSize: self.textFontSize)
                    let bottomLabel: UILabel = self.createLabel(textColor: self.textColor, textAlignment: NSTextAlignment.center)
                    bottomLabel.frame = CGRect.init(x: midX - bottomLabelWidth / 2, y: maxMidY + self.bottomOffset, width: bottomLabelWidth, height: labelHeight)
                    bottomLabel.text = self.horizontalDataArr[k];
                    self.addSubview(bottomLabel)
                    bottomLabel.transform = CGAffineTransform(rotationAngle: self.angle);
                }
                
                drawLineLayer(pointArr: pointArr, maxMidY: maxMidY)
            }else {
                hLineLayer.strokeColor = self.horizontalLineColor.cgColor
                hLineLayer.lineWidth = self.horizontalLineWidth
            }
            hLineLayer.path = linePath.cgPath
            hLineLayer.fillColor = UIColor.clear.cgColor
            hLineLayer.lineCap = CAShapeLayerLineCap.round
            hLineLayer.lineJoin = CAShapeLayerLineJoin.round
            hLineLayer.contentsScale = UIScreen.main.scale
            self.layer.addSublayer(hLineLayer)
        }
    }
    
    func drawLineLayer(pointArr: Array<NSValue>, maxMidY: CGFloat) {
        let startPoint: CGPoint = pointArr.first!.cgPointValue
        let endPoint: CGPoint = pointArr.last!.cgPointValue
        let linePath: UIBezierPath = UIBezierPath.init()
        linePath.move(to: startPoint)
        if self.addCurve {
            linePath.addBezierThroughPoints(pointArray: pointArr)
        }else {
            linePath.addNormalBezierThroughPoints(pointArray: pointArr)
        }
        
        let lineLayer = CAShapeLayer.init();
        lineLayer.path = linePath.cgPath;
        lineLayer.strokeColor = self.lineColor.cgColor;
        lineLayer.fillColor = UIColor.clear.cgColor;
        lineLayer.lineWidth = self.lineWidth;
        lineLayer.lineCap = CAShapeLayerLineCap.round;
        lineLayer.lineJoin = CAShapeLayerLineJoin.round;
        lineLayer.contentsScale = UIScreen.main.scale;
        self.layer.addSublayer(lineLayer)
        
        //颜色渐变
        if (self.showColorGradient) {
            let colorPath = UIBezierPath.init();
            colorPath.lineWidth = 1.0;
            colorPath.move(to: startPoint)
            if (self.addCurve) {
                colorPath.addBezierThroughPoints(pointArray: pointArr);
            } else {
                colorPath.addNormalBezierThroughPoints(pointArray: pointArr)
            }
            colorPath.addLine(to: CGPoint.init(x: endPoint.x, y: maxMidY))
            colorPath.addLine(to: CGPoint.init(x: startPoint.x, y: maxMidY))
            colorPath.addLine(to: CGPoint.init(x: startPoint.x, y: startPoint.y))
            
            let bgLayer = CAShapeLayer.init();
            bgLayer.path = colorPath.cgPath;
            bgLayer.frame = self.bounds;
            
            let colorLayer = CAGradientLayer.init();
            colorLayer.frame = bgLayer.frame;
            colorLayer.mask = bgLayer;
            colorLayer.startPoint = CGPoint.zero;
            colorLayer.endPoint = CGPoint.init(x: 0, y: 1);
            colorLayer.colors = self.colorArr;
            self.layer.addSublayer(colorLayer)
        }
        
        buildDotWithPointsArr(pointsArr: pointArr)
    }
    
    func buildDotWithPointsArr(pointsArr: Array<NSValue>) {
        for i in 0..<pointsArr.count {
            if (self.toCenter && self.supplement && (i == 0 || i == pointsArr.count - 1)) {
                continue;
            }
            
            let point = pointsArr[i];
            let path = UIBezierPath.init(arcCenter: CGPoint.init(x: point.cgPointValue.x, y: point.cgPointValue.y), radius: self.circleRadius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: false)
            let circleLayer = CAShapeLayer.init()
            circleLayer.path = path.cgPath;
            circleLayer.strokeColor = self.circleStrokeColor.cgColor;
            circleLayer.fillColor = self.circleFillColor.cgColor;
            circleLayer.lineWidth = self.lineWidth;
            circleLayer.lineCap = CAShapeLayerLineCap.round;
            circleLayer.lineJoin = CAShapeLayerLineJoin.round;
            circleLayer.contentsScale = UIScreen.main.scale;
            self.layer.addSublayer(circleLayer)
            
            //关键点数据
            if (self.showLineData) {
                var index = i;
                if (self.toCenter && self.supplement) {
                    index = i - 1;
                }
                let numLabel = createLabel(textColor: self.dataTextColor, textAlignment: NSTextAlignment.center)
                numLabel.text = self.lineDataAry[index].toString(6)
                if (self.dataTextWidth <= 0) {
                    self.dataTextWidth = numLabel.text?.getTextWidth(fontSize: self.textFontSize) ?? 0
                }
                numLabel.frame = CGRect.init(x: point.cgPointValue.x - self.dataTextWidth / 2, y: point.cgPointValue.y - 18, width: self.dataTextWidth, height: self.textFontSize)
                self.addSubview(numLabel)
            }
            
            if (self.showDecline) {
                if i != 0 && pointsArr.count > 1 {
                    //不是第一个，且总数据大于1条
                    var index = i;
                    if (self.toCenter && self.supplement) {
                        index = i - 1;
                    }
                    
                    let preLineData = self.lineDataAry[index-1]
                    let lineData = self.lineDataAry[index]
                    if lineData < preLineData {
                        //下降,展示图片
                        let declineImageView = UIImageView.init(image: UIImage.init(named: "chart-decline"))
                        declineImageView.frame = CGRect.init(x: point.cgPointValue.x - 11, y: point.cgPointValue.y + 4, width: 22, height: 22)
                        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapDeclineImageView(tapGesture:)))
                        declineImageView.addGestureRecognizer(tapGesture)
                        declineImageView.isUserInteractionEnabled = true
                        declineImageView.tag = index
                        self.addSubview(declineImageView)
                    }
                }
            }
        }
    }
    
    @objc func tapDeclineImageView(tapGesture: UITapGestureRecognizer) {
        print("下降")
        let tapView = tapGesture.view
        let index = tapView?.tag ?? 0
        let alertController = UIAlertController.init(title: "提示", message: String.init(format: "您点击了下降警示，位于%d节点", index+1), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func createLabel(textColor: UIColor, textAlignment: NSTextAlignment) -> UILabel {
        let label: UILabel = UILabel.init()
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = UIFont.systemFont(ofSize: self.textFontSize)
        return label
    }

}
