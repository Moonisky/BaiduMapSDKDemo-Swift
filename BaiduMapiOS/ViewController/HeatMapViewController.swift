//
//  HeatMapViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class HeatMapViewController: UIViewController, BMKMapViewDelegate {
    
    @IBOutlet var btn_addHeatMap: UIButton!
    @IBAction func addHeatMap(sender: UIButton) {
        // 创建热力图数据类
        var heatMap = BMKHeatMap()
        // 创建热力图数据数组
        var heatData = Array(count: 0, repeatedValue: BMKHeatMapNode())
        
        // 读取数据
        var jsonData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("locations", ofType: "json")!)
        if jsonData != nil {
            var json = JSON(data: jsonData!, options: .MutableContainers, error: nil)
            for (key: String, subJson: JSON) in json {
                var dic = subJson.dictionaryValue
                // 创建 BMKHeatMapNode
                var heatMapNode = BMKHeatMapNode()
                var coordinate = CLLocationCoordinate2DMake(dic["lat"]!.double!, dic["lng"]!.double!)
                heatMapNode.pt = coordinate
                // 随机生成点强度
                heatMapNode.intensity = Double(arc4random())
                // 添加 BMKHeatMapNode 到数组
                heatData.append(heatMapNode)
            }
        }
        // 将点数据赋值到热力图数据类当中
        heatMap.mData = NSMutableArray(array: heatData)
        // 调用 mapView 中的方法根据热力图数据添加热力图
        mapView.addHeatMap(heatMap)
    }
    
    @IBAction func removeHeatMap(sender: UIButton) {
        mapView.removeHeatMap()
    }
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[13]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        mapView.zoomLevel = 5
        mapView.setCenterCoordinate(CLLocationCoordinate2DMake(35.718, 111.581), animated: true)
        
        // 添加说明按钮
        var customRightBarButtonItem = UIBarButtonItem(title: "说明", style: .Bordered, target: self, action: Selector("showGuide"))
        self.navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: btn_addHeatMap, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // 说明按钮
    func showGuide() {
        var alertView = UIAlertController(title: "说明", message: "此处为热力图绘制功能，需要开发者传入空间位置数据，由SDK帮助实现本地的渲染绘制", preferredStyle: .Alert)
        var okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
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

