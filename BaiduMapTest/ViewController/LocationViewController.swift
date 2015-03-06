//
//  LocationViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-6.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate {
    
    @IBOutlet weak var btn_Start: UIButton!
    @IBOutlet weak var btn_Follow: UIButton!
    @IBOutlet weak var btn_FollowHead: UIButton!
    @IBOutlet weak var btn_Stop: UIButton!
    
    @IBAction func btnact_Start(sender: UIButton) {
        // 开启定位
        println("进入普通定位态")
        locationService.startUserLocationService()
        mapView.showsUserLocation = false  //先关闭显示的定位图层
        mapView.userTrackingMode = BMKUserTrackingModeNone  //设置定位的状态
        mapView.showsUserLocation = true //显示定位图层
        btn_Start.enabled = false
        btn_Follow.enabled = true
        btn_FollowHead.enabled = true
        btn_Stop.enabled = true
    }
    
    @IBAction func btnact_Follow(sender: UIButton) {
        // 进入跟随态
        println("进入跟随状态")
        mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.showsUserLocation = true
    }
    
    @IBAction func btnact_FollowHead(sender: UIButton) {
        // 进入罗盘态
        println("进入罗盘态")
        mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading
        mapView.showsUserLocation = true
    }
    
    @IBAction func btnact_Stop(sender: UIButton) {
        // 关闭定位
        println("关闭定位状态")
        locationService.stopUserLocationService()
        mapView.showsUserLocation = false
        btn_Start.enabled = true
        btn_Follow.enabled = false
        btn_FollowHead.enabled = false
        btn_Stop.enabled = false
    }

    /// 百度地图视图
    var mapView: BMKMapView!
    /// 定位服务
    var locationService: BMKLocationService!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 设置标题
        self.title = arrayOfDemoName[4]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        btn_Follow.enabled = false
        btn_FollowHead.enabled = false
        btn_Stop.enabled = false
        
        // 定位功能初始化
        locationService = BMKLocationService()
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)

        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: btn_Start, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 定位协议实现
    
    // 在地图将要启动定位时，会调用此函数
    func willStartLocatingUser() {
        println("启动定位……")
    }
    
    // 用户位置更新后，会调用此函数
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
    }
    
    // 用户方向更新后，会调用此函数
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        println("目前朝向：\(userLocation.heading)")
    }
    
    // 在地图将要停止定位时，会调用此函数
    func didStopLocatingUser() {
        println("关闭定位")
    }
    
    // 定位失败的话，会调用此函数
    func didFailToLocateUserWithError(error: NSError!) {
        println("定位失败！")
        btn_Start.enabled = true
        btn_Follow.enabled = false
        btn_FollowHead.enabled = false
        btn_Stop.enabled = false
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        locationService.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        locationService.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
