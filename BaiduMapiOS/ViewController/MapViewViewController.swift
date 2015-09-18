//
//  MapViewViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

// 图层展示功能，能够分别显示矢量地图、卫星地图的路况、3D楼宇以及百度自带的热力图功能

class MapViewViewController: UIViewController, BMKMapViewDelegate {
    
    // 输出口
    @IBOutlet weak var sgm_MapChoosen: UISegmentedControl!
    @IBOutlet weak var view_mapView: UIView!
    @IBOutlet weak var swh_Road: UISwitch!
    @IBOutlet weak var swh_3D: UISwitch!
    @IBOutlet weak var swh_Hot: UISwitch!
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[2]
        
        // 相关UI控件初始化
        sgm_MapChoosen.selectedSegmentIndex = 0
        swh_Road.on = false
        swh_3D.on = true
        swh_Hot.on = false
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view_mapView.frame)
        mapView.trafficEnabled = false
        mapView.buildingsEnabled = true
        mapView.baiduHeatMapEnabled = false
        view_mapView.removeFromSuperview()
        self.view.addSubview(mapView)
    }
    
    // MARK: - UI控件动作处理
    
    @IBAction func changeTheMapType(sender: UISegmentedControl) {
        let index = sgm_MapChoosen.selectedSegmentIndex
        switch index {
        case 0:
            mapView.mapType = UInt(BMKMapTypeStandard)
        default:
            mapView.mapType = UInt(BMKMapTypeSatellite)
        }
    }
    
    @IBAction func changeSwitchValue(sender: UISwitch) {
        let value = sender.on
        switch sender.tag {
        case 0:
            mapView.trafficEnabled = value
        case 1:
            mapView.buildingsEnabled = value
        case 2:
            mapView.baiduHeatMapEnabled = value
        default:
            break
        }
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
