//
//  MapUIViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-6.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class MapUIViewController: UIViewController, BMKMapViewDelegate {
    
    @IBOutlet weak var ZoomSwitch: UISwitch!
    @IBOutlet weak var moveSwitch: UISwitch!
    @IBOutlet weak var scaleSwitch: UISwitch!
    @IBAction func SwitchChange(sender: UISwitch) {
        switch sender.tag {
        case 0:
            mapView.zoomEnabled = sender.on
        case 1:
            mapView.scrollEnabled = sender.on
        case 2:
            mapView.showMapScaleBar = sender.on
            mapView.mapScaleBarPosition = CGPointMake(mapView.frame.width - 70, mapView.frame.height - 40)
        default:
            return
        }
    }
    
    @IBAction func CompassPositionChange(sender: UISegmentedControl) {
        var point: CGPoint
        switch sender.selectedSegmentIndex {
        case 0:
            point = CGPointMake(10, 10)
        case 1:
            point = CGPointMake(mapView.frame.width - 50, 10)
        default:
            point = CGPointMake(0, 0)
        }
        mapView.compassPosition = point
    }
    
    @IBOutlet weak var SegmentController: UISegmentedControl!
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[4]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 界面初始化
        mapView.showMapScaleBar = false
        scaleSwitch.on = false
        mapView.overlooking = -30
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: SegmentController, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
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