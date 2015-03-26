//
//  NavigationViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController, BMKMapViewDelegate {
    
    @IBOutlet var txf_endLatitude: UITextField!
    @IBOutlet var txf_endLongitude: UITextField!
    @IBOutlet var txf_endName: UITextField!
    @IBOutlet var txf_startLatitude: UITextField!
    @IBOutlet var txf_startLongitude: UITextField!
    @IBOutlet var txf_startName: UITextField!
    @IBOutlet var txf_endLatitude2: UITextField!
    @IBOutlet var txf_endLongitude2: UITextField!
    @IBOutlet var txf_endName2: UITextField!
    
    // 调启百度地图 APP 导航
    @IBAction func appNavigation(sender: UIButton) {
        // 初始化调启导航的参数管理类
        var parameter = BMKNaviPara()
        // 指定导航类型
        parameter.naviType = BMK_NAVI_TYPE_NATIVE
        
        // 初始化终点节点
        var end = BMKPlanNode()
        // 指定终点经纬度
        var coordinate = CLLocationCoordinate2DMake((txf_endLatitude.text as NSString).doubleValue, (txf_endLongitude.text as NSString).doubleValue)
        end.pt = coordinate
        // 指定终点名称
        end.name = txf_endName.text
        // 指定终点
        parameter.endPoint = end
        
        // 指定返回自定义 scheme
        parameter.appScheme = "baidumapsdk://mapsdk.baidu.com"
        
        // 调启百度地图客户端导航
        BMKNavigation.openBaiduMapNavigation(parameter)
    }
    @IBAction func webNavigation(sender: UIButton) {
        // 初始化调启导航时的参数管理类
        var parameter = BMKNaviPara()
        // 指定导航类型
        parameter.naviType = BMK_NAVI_TYPE_WEB
        
        // 初始化起点节点
        var start = BMKPlanNode()
        // 指定起点经纬度
        var coordinate = CLLocationCoordinate2DMake((txf_startLatitude.text as NSString).doubleValue, (txf_startLongitude.text as NSString).doubleValue)
        start.pt = coordinate
        // 指定起点名称
        start.name = txf_startName.text
        // 指定起点
        parameter.startPoint = start
        
        // 初始化终点节点
        var end = BMKPlanNode()
        // 指定终点经纬度
        coordinate = CLLocationCoordinate2DMake((txf_endLatitude2.text as NSString).doubleValue, (txf_endLongitude2.text as NSString).doubleValue)
        end.pt = coordinate
        // 指定终点名称
        end.name = txf_endName2.text
        // 指定终点
        parameter.endPoint = end
        
        // 指定调启导航的 app 名称
        parameter.appName = "BaiduMapDemo"
        // 调启 web 导航
        BMKNavigation.openBaiduMapNavigation(parameter)
    }
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = BMKMapView()
        
        // 设置标题
        self.title = arrayOfDemoName[16]
        
        // 初始化导航栏右侧按钮“说明”
        var customRightBarButtonItem = UIBarButtonItem(title: "说明", style: .Bordered, target: self, action: Selector("showGuide"))
        self.navigationItem.rightBarButtonItem = customRightBarButtonItem
    }
    
    func showGuide() {
        var alertView = UIAlertController(title: "调启导航－说明", message: "本示例为调启两种导航（客户端导航和Web导航）的基本使用方法。\n1）确定起终点时有两种方法：经纬度和名称，两者都提供时优先用经纬度，无经纬度时用名称。\n2）百度地图客户端导航默认以当前位置作为起点进行导航，所以只需定义终点即可。", preferredStyle: .Alert)
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

