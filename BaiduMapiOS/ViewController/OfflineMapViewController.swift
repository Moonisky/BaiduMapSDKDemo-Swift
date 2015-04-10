//
//  OfflineMapViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-19.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class OfflineMapViewController: UIViewController, BMKMapViewDelegate {
    
    var cityID: Int32!
    var offlineServiceOfMapview: BMKOfflineMap!
    var mapView: BMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化右边的更新按钮
        var customRightBarButtonItem = UIBarButtonItem(title: "更新", style: .Plain, target: self, action: Selector("update"))
        self.navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        // 显示当前某地的离线地图
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        var localMapInfo = offlineServiceOfMapview.getUpdateInfo(cityID)
        mapView.setCenterCoordinate(localMapInfo.pt, animated: true)
    }
    
    func update() {
        offlineServiceOfMapview.update(cityID)
        NSLog("离线地图更新")
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
