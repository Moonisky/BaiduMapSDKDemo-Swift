//
//  CustomOverlay.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class CustomOverlay:  BMKShape {
    
    // 类方法
    class func customWithPoints(points: [BMKMapPoint], count: UInt) -> CustomOverlay{
        let polyline = CustomOverlay(points: points, count: count)
        return polyline
    }
    
    class func MapRectUnionWithPoints(rect1 rect1: BMKMapRect, point: BMKMapPoint) -> BMKMapRect {
        var rcRet = BMKMapRectMake(0, 0, 0, 0)
        var tmp = max(rect1.origin.x + rect1.size.width, point.x)
        rcRet.origin.x = min(rect1.origin.x, point.x)
        rcRet.size.width = tmp - rcRet.origin.x
        tmp = max(rect1.origin.y + rect1.size.height, point.y)
        rcRet.origin.y = min(rect1.origin.y, point.y)
        rcRet.size.height = tmp - rcRet.origin.y
        return rcRet
    }
    
    // 属性
    var points: [BMKMapPoint]!
    override var coordinate: CLLocationCoordinate2D {
        get {
            return self.coordinate
        }
    }
    var boundingMapRect: BMKMapRect!
    var pointCount: Int!
    
    init(points: [BMKMapPoint]?, count: UInt) {
        super.init()
        if points != nil && count > 0 {
            self.points = Array(count: Int(count), repeatedValue: BMKMapPoint(x: 0, y: 0))
            if self.points == nil {
                return
            }
            self.points = Array(points![0...Int(count-1)])
            
            pointCount = Int(count)
        }
    }
    
    func setBoundingMapRect() -> BMKMapRect {
        if points != nil && pointCount > 0 {
            boundingMapRect.origin = points[0]
            boundingMapRect.size.width = 0
            boundingMapRect.size.height = 0
            for i in 0..<pointCount {
                boundingMapRect = CustomOverlay.MapRectUnionWithPoints(rect1: boundingMapRect, point: points[i])
            }
        }
        if boundingMapRect.size.width == 0 {
            boundingMapRect.size.width = 1
        }
        if boundingMapRect.size.height == 0 {
            boundingMapRect.size.height = 1
        }
        
        return boundingMapRect
    }
}
