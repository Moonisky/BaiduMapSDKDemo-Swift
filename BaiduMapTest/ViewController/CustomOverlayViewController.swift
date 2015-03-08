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
        //mapView.addOverlay(custom)
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