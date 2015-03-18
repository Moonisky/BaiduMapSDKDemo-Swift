//
//  CustomOverlayViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-6.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class CustomOverlayViewController: UIViewController, BMKMapViewDelegate {
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[7]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        self.view = mapView
        
        // 界面初始化
        
        // FIXME: CustomOverlay 遵循 BMKOverlay 协议会出错，待解决……
        var coordinator1 = CLLocationCoordinate2DMake(39.915, 116.404)
        var point1 = BMKMapPointForCoordinate(coordinator1)
        var coordinator2 = CLLocationCoordinate2DMake(40.015, 116.404)
        var point2 = BMKMapPointForCoordinate(coordinator2)
        var points = [point1, point2]
        var custom = CustomOverlay(points: points, count: 2)
        mapView.addOverlay(Sector(coordinator1, radius: 0.5, startDegree: 0, endDegree: 90))
    }
    
    func Sector(startPoint: CLLocationCoordinate2D, radius: Double, startDegree: Double, endDegree: Double) -> BMKPolygon {
        var points = [startPoint]
        var step = (endDegree - startDegree) / 10
        for var i = startDegree; i < endDegree + 0.001; i += step {
            points.append(PointMakeWith(StartPoint: startPoint, distance: radius, direction: i))
        }
        //points.append(startPoint)
        var pointss = [BMKMapPointForCoordinate(startPoint)]
        for i in points {
            pointss.append(BMKMapPointForCoordinate(i))
        }
        //var polygon = BMKPolygon(coordinates: &points, count: UInt(points.count))
        var polygon = BMKPolygon(points: &pointss, count: UInt(pointss.count))
        
        return polygon
    }
    
    func PointMakeWith(#StartPoint: CLLocationCoordinate2D, distance: CLLocationDistance, direction: CLLocationDirection) -> CLLocationCoordinate2D {
        var latitude = distance * cos(direction * M_PI / 180)
        var longtitude = distance * sin(direction * M_PI / 180)
        println("\(StartPoint.latitude + latitude) \(StartPoint.longitude + longtitude)")
        return CLLocationCoordinate2DMake(StartPoint.latitude + latitude, StartPoint.longitude + longtitude)
    }
    
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        
        if (overlay as? BMKPolygon) != nil {
            var polygonView = BMKPolygonView(overlay: overlay)
            polygonView.strokeColor = UIColor.purpleColor().colorWithAlphaComponent(1)
            polygonView.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
            polygonView.lineWidth = 2
            
            return polygonView
        }
        return nil
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}