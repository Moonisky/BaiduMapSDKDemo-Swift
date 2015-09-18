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
        let heatMap = BMKHeatMap()
        // 创建热力图数据数组
        var heatData = Array(count: 0, repeatedValue: BMKHeatMapNode())
        
        // 读取数据
        let jsonData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("locations", ofType: "json")!)
        if jsonData != nil {
            let json = JSON(data: jsonData!, options: .MutableContainers, error: nil)
            for (_, subJson): (String, JSON) in json {
                var dic = subJson.dictionaryValue
                // 创建 BMKHeatMapNode
                let heatMapNode = BMKHeatMapNode()
                let coordinate = CLLocationCoordinate2DMake(dic["lat"]!.double!, dic["lng"]!.double!)
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
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        mapView.zoomLevel = 5
        mapView.setCenterCoordinate(CLLocationCoordinate2DMake(35.718, 111.581), animated: true)
        
        // 添加说明按钮
        let customRightBarButtonItem = UIBarButtonItem(title: "说明", style: .Plain, target: self, action: Selector("showGuide"))
        self.navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(btn_addHeatMap.bottomAnchor, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // 说明按钮
    func showGuide() {
        let alertView = UIAlertController(title: "说明", message: "此处为热力图绘制功能，需要开发者传入空间位置数据，由SDK帮助实现本地的渲染绘制", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
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

