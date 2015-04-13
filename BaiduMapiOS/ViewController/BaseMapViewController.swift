//
//  BaseMapViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

/// 基础地图功能，能够显示出基本地图，并且有手势响应
class BaseMapViewController: UIViewController, BMKMapViewDelegate, UIGestureRecognizerDelegate {
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 设置导航栏标题
        self.title = arrayOfDemoName[0]
        
        // 载入地图视图
        mapView = BMKMapView(frame: self.view.frame)
        self.view = mapView
    }
    
    // MARK: - 百度地图相关协议实现
    
    // 地图初始化完毕后会调用此接口
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        // 弹出提示框，可以换用UIAlertView，但是不推荐
        var alertController = UIAlertController(title: "", message: "BMKMapView控件初始化完成", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        addCustomGestures()
    }
    
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        println("单击了地图上的空白区域！")
    }
    
    func mapview(mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
        println("双击了地图区域！")
    }
    
    // MARK: - 添加自定义手势（如果不需要自定义手势，那么无需下面的代码）
    
    func addCustomGestures() {
        /*
        *注意：
        *添加自定义手势时，必须设置UIGestureRecognizer的cancelsTouchesInView 和 delaysTouchesEnded 属性设置为false，否则影响地图内部的手势处理
        */
        // 设定双击手势，需要实现UIGestureRecognizerDelegate协议
        var doubleTap = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
        doubleTap.delegate = self
        doubleTap.numberOfTapsRequired = 2
        doubleTap.cancelsTouchesInView = false
        doubleTap.delaysTouchesEnded = false
        
        self.view.addGestureRecognizer(doubleTap)
        
        // 设定单击手势
        var singleTap = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap:"))
        singleTap.delegate = self
        singleTap.cancelsTouchesInView = false
        singleTap.delaysTouchesEnded = false
        // 如果没有响应双击手势，则响应单击手势
        singleTap.requireGestureRecognizerToFail(doubleTap)
        self.view.addGestureRecognizer(singleTap)
    }
    
    func handleDoubleTap(doubleTap: UITapGestureRecognizer) {
        println("custom double tap handle")
    }
    
    func handleSingleTap(singleTap: UITapGestureRecognizer) {
        println("custom single tap handle")
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
