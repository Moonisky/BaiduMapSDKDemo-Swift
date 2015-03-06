//
//  BaseMapViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

// 基础地图功能，能够显示出地图，并且有手势响应

class BaseMapViewController: UIViewController, BMKMapViewDelegate {
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 设置标题
        self.title = arrayOfDemoName[0]
        
        // 载入视图
        mapView = BMKMapView(frame: self.view.frame)
        self.view = mapView
    }
    
    // MARK: - 百度地图相关协议实现
    
    // 地图初始化完毕后会调用此接口
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        // 弹出提示框
        var alertController = UIAlertController(title: "", message: "BMKMapView控件初始化完成", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        println("单击了地图上的空白区域！")
    }
    
    func mapview(mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
        println("双击了地图区域！")
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
