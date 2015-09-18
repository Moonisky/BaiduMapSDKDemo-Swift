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
        print("进入普通定位态")
        locationService.startUserLocationService()
        mapView.showsUserLocation = false  //先关闭显示的定位图层
        mapView.userTrackingMode = BMKUserTrackingModeNone  //设置定位的状态
        mapView.showsUserLocation = true //显示定位图层
        mapView.scrollEnabled = true  // 允许用户移动地图
        mapView.updateLocationData(userLocation)  // 更新当前位置信息，强制刷新定位图层
        btn_Start.enabled = false
        btn_Follow.enabled = true
        btn_FollowHead.enabled = true
        btn_Stop.enabled = true
    }
    
    @IBAction func btnact_Follow(sender: UIButton) {
        // 进入跟随态
        print("进入跟随状态")
        mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.showsUserLocation = true
        mapView.scrollEnabled = false  // 禁止用户移动地图
        mapView.updateLocationData(userLocation)
    }
    
    @IBAction func btnact_FollowHead(sender: UIButton) {
        // 进入罗盘态
        print("进入罗盘态")
        mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading
        mapView.showsUserLocation = true
        mapView.scrollEnabled = false
        mapView.updateLocationData(userLocation)
    }
    
    @IBAction func btnact_Stop(sender: UIButton) {
        // 关闭定位
        print("关闭定位状态")
        locationService.stopUserLocationService()
        mapView.showsUserLocation = false
        btn_Start.enabled = true
        btn_Follow.enabled = false
        btn_FollowHead.enabled = false
        btn_Stop.enabled = false
        mapView.scrollEnabled = true
    }

    /// 百度地图视图
    var mapView: BMKMapView!
    /// 定位服务
    var locationService: BMKLocationService!
    /// 当前用户位置
    var userLocation: BMKUserLocation!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 设置标题
        self.title = arrayOfDemoName[5]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
         self.view.addSubview(mapView)
        
        btn_Follow.enabled = false
        btn_FollowHead.enabled = false
        btn_Stop.enabled = false
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        // 定位功能初始化
        locationService = BMKLocationService()
        
        locationService.startUserLocationService()

        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(btn_Start.bottomAnchor, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 定位协议实现
    
    // 在地图将要启动定位时，会调用此函数
    func willStartLocatingUser() {
        print("启动定位……")
    }
    
    // 用户位置更新后，会调用此函数
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        mapView.centerCoordinate = userLocation.location.coordinate
        self.userLocation = userLocation
        print("目前位置：\(userLocation.location.coordinate.longitude), \(userLocation.location.coordinate.latitude)")
    }
    
    // 用户方向更新后，会调用此函数
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        print("目前朝向：\(userLocation.heading)")
    }
    
    // 在地图将要停止定位时，会调用此函数
    func didStopLocatingUser() {
        print("关闭定位")
    }
    
    // 定位失败的话，会调用此函数
    func didFailToLocateUserWithError(error: NSError!) {
        print("定位失败！")
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
