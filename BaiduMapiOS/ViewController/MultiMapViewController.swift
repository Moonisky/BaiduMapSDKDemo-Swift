//
//  MultiMapViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

/// 多地图使用功能，能够显示出两个基本地图，并且有手势响应
class MultiMapViewController: UIViewController, BMKMapViewDelegate {
    
    /// 百度地图视图
    var mapView1: BMKMapView!
    var mapView2: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.grayColor()
        // 设置标题
        self.title = arrayOfDemoName[1]
        
        // 获取地图的高度，需要减去导航栏高度以及两个地图之间的间距（10px）
        let navigationHeight = self.navigationController?.navigationBar.frame.height
        let mapViewHeight = (self.view.frame.height - navigationHeight!) / 2 - 10
        
        // 初始化第一个地图，采用卫星视图样式
        mapView1 = BMKMapView(frame: CGRectMake(0, navigationHeight!, self.view.frame.width, mapViewHeight))
        mapView1.mapType = UInt(BMKMapTypeSatellite)
        mapView1.zoomLevel = 14
        self.view.addSubview(mapView1)
        
        // 初始化第二个地图，采用标准视图央视
        mapView2 = BMKMapView(frame: CGRectMake(0, mapViewHeight + navigationHeight! + 10, self.view.frame.width, mapViewHeight))
        mapView2.mapType = UInt(BMKMapTypeStandard)
        mapView2.zoomLevel = 14
        self.view.addSubview(mapView2)
    }
    
    // MARK: - 百度地图相关协议实现
    
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        if mapView == mapView1 {
            print("于第一个地图视图上进行了单击操作！")
        }else if mapView == mapView2 {
            print("于第二个地图视图上进行了单击操作！")
        }
    }
    
    func mapview(mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
        if mapView == mapView1 {
            print("于第一个地图视图上进行了长按操作！")
        }else if mapView == mapView2 {
            print("于第二个地图视图上进行了长按操作！")
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView1.viewWillAppear()
        mapView1.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        mapView2.viewWillAppear()
        mapView2.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView1.viewWillDisappear()
        mapView1.delegate = nil  // 不用时，置nil
        mapView2.viewWillDisappear()
        mapView2.delegate = nil
    }
    
}
