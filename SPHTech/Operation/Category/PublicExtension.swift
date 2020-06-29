//
//  PublicExtension.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/29.
//  Copyright © 2020 creazylee. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension UIColor {
    class func hexColor(_ hexString: String) -> UIColor {
        var cstr = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if(cstr.length < 6){
          return UIColor.clear;
        }
        if(cstr.hasPrefix("0X")){
          cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")){
        cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6){
        return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0;
        var g :UInt32 = 0x0;
        var b :UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }
}

extension String {
    func getTextWidth(fontSize: CGFloat) -> CGFloat {
        let statusLabelText = self
        
        let size = CGSize.init(width: 600, height: fontSize + 4)
        let font = UIFont.systemFont(ofSize: fontSize)
        let dic = [NSAttributedString.Key.font:font]
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
        
        return strSize.width + 5
    }

}

private var kContractionFactorKey: String = "kContractionFactorKey"

extension UIBezierPath {
    var contractionFactor: CGFloat {
        get {
            let contractionFactorAssociatedObject = objc_getAssociatedObject(self, &kContractionFactorKey);
            if (contractionFactorAssociatedObject == nil) {
                return 0.7;
            }
            return contractionFactorAssociatedObject as! CGFloat;
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &kContractionFactorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func ControlPointForTheBezierCanThrough3Point(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> CGPoint {
        return CGPoint.init(x: 2 * point2.x - (point1.x + point3.x) / 2, y: 2 * point2.y - (point1.y + point3.y) / 2)
    }
    
    func CenterPointOf(point1: CGPoint,  point2: CGPoint) -> CGPoint {
        return CGPoint.init(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2);
    }
    
    func DistanceBetweenPoint(point1: CGPoint,point2: CGPoint) -> CGFloat {
        return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    }
    
    func ObliqueAngleOfStraightThrough(point1: CGPoint, point2: CGPoint) -> CGFloat {
        var obliqueRatio: CGFloat = 0;
        var obliqueAngle: CGFloat = 0;
        
        if (point1.x > point2.x) {
            obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
            obliqueAngle = atan(obliqueRatio);
        }
        else if (point1.x < point2.x) {
        
            obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
            obliqueAngle = CGFloat(Double.pi) + atan(obliqueRatio);
        }
        else if (point2.y - point1.y >= 0) {
            obliqueAngle = CGFloat(Double.pi/2);
        }
        else {
            obliqueAngle = CGFloat(-Double.pi/2);
        }
        
        return obliqueAngle;
    }
    
    /**
     * 正常折线绘制
     * 必须将CGPoint结构体包装成NSValue对象并且至少一个点来画折线。
     */
    func addNormalBezierThroughPoints(pointArray: Array<NSValue>) {
        for i in 0..<pointArray.count {
            let pointIValue = pointArray[i];
            let pointI = pointIValue.cgPointValue;
            self.addLine(to: pointI)
        }
    }
    
    func addBezierThroughPoints(pointArray: Array<NSValue>) {
        if (pointArray.count < 3) {
            switch (pointArray.count) {
                case 1:
                    let point0Value = pointArray[0];
                    let point0 = point0Value.cgPointValue;
                    self.addLine(to: point0)
                    break;
                case 2:
                    let point0Value = pointArray[0];
                    let point0 = point0Value.cgPointValue
                    let point1Value = pointArray[1]
                    let point1 = point1Value.cgPointValue
                    self.addQuadCurve(to: point1, controlPoint: self.ControlPointForTheBezierCanThrough3Point(point1: self.currentPoint, point2: point0, point3: point1))
                    break;
                default:
                    break;
            }
        }
        
        var previousPoint = CGPoint.zero;
        
        var previousCenterPoint = CGPoint.zero;
        var centerPoint = CGPoint.zero;
        var centerPointDistance:CGFloat = 0;
        
        var obliqueAngle: CGFloat = 0;
        
        var previousControlPoint1 = CGPoint.zero;
        var previousControlPoint2 = CGPoint.zero;
        var controlPoint1 = CGPoint.zero;

        previousPoint = self.currentPoint;
        
        for i in 0..<pointArray.count {
            let pointIValue = pointArray[i];
            let pointI = pointIValue.cgPointValue;
            
            if (i > 0) {
                previousCenterPoint = CenterPointOf(point1: self.currentPoint, point2: previousPoint);
                centerPoint = CenterPointOf(point1: previousPoint, point2: pointI);
                
                centerPointDistance = DistanceBetweenPoint(point1: previousCenterPoint, point2: centerPoint);
                
                obliqueAngle = ObliqueAngleOfStraightThrough(point1: centerPoint, point2: previousCenterPoint);
                
                previousControlPoint2 = CGPoint.init(x: previousPoint.x - 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), y: previousPoint.y - 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
                controlPoint1 = CGPoint.init(x: previousPoint.x + 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), y: previousPoint.y + 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
            }
            
            if (i == 1) {
                self.addQuadCurve(to: previousPoint, controlPoint: previousControlPoint2)
            }
            else if (i > 1 && i < pointArray.count - 1) {
                self.addCurve(to: previousPoint, controlPoint1: previousControlPoint1, controlPoint2: previousControlPoint2)
            }
            else if (i == pointArray.count - 1) {
                self.addCurve(to: previousPoint, controlPoint1: previousControlPoint1, controlPoint2: previousControlPoint2)
                self.addQuadCurve(to: pointI, controlPoint: controlPoint1)
            }
            else {
            
            }
            
            previousControlPoint1 = controlPoint1;
            previousPoint = pointI;
        }
    }
}
