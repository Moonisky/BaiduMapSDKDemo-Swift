//
//  PoiSearchViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-6.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class PoiSearchViewController: UIViewController, BMKMapViewDelegate, BMKPoiSearchDelegate {
    
    // MARK: - 输入口与动作
    @IBOutlet weak var txf_City: UITextField!
    @IBOutlet weak var txf_Search: UITextField!
    @IBOutlet weak var btn_Search: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    
    // 开始搜搜
    @IBAction func Search(sender: UIButton) {
        currentPage = 0
        var citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = Int32(currentPage)
        citySearchOption.pageCapacity = 10
        citySearchOption.city = txf_City.text
        citySearchOption.keyword = txf_Search.text
        if poisearch.poiSearchInCity(citySearchOption) {
            btn_Next.enabled = true
            println("城市内检索发送成功！")
        }else {
            btn_Next.enabled = false
            println("城市内检索发送失败！")
        }
    }
    
    // 查看下一组数据
    @IBAction func NextData(sender: UIButton) {
         currentPage++
        // 城市内检索，请求成功发送返回 true，请求失败返回 false
        var citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = Int32(currentPage)
        citySearchOption.pageCapacity = 10
        citySearchOption.city = txf_City.text
        citySearchOption.keyword = txf_Search.text
        if poisearch.poiSearchInCity(citySearchOption) {
            btn_Next.enabled = true
            println("城市内检索发送成功！")
        }else {
            btn_Next.enabled = false
            println("城市内检索发送失败！")
        }
    }
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// Poi 搜索
    var poisearch: BMKPoiSearch!
    /// 搜索页面
    var currentPage = 0
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[8]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 界面初始化
        txf_City.text = "北京"
        txf_Search.text = "餐厅"
        mapView.zoomLevel = 13
        btn_Next.enabled = false
        mapView.isSelectedAnnotationViewFront = true
        
        // Poi 搜索初始化
        poisearch = BMKPoiSearch()
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: btn_Search, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 覆盖物协议设置
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 生成重用标示 ID
        var annotationViewID = "Mark"
        
        // 检查是否有重用的缓存
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewID)
        
        // 缓存若没有命中，则自己构造一个，一般首次添加 annotation 代码会运行到此处
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewID)
            (annotationView as! BMKPinAnnotationView).pinColor =  UInt(BMKPinAnnotationColorRed)
            // 设置标注从天上掉下来的效果
            (annotationView as! BMKPinAnnotationView).animatesDrop = true
        }
        
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5))
        annotationView.annotation = annotation
        // 单击弹出泡泡，弹出泡泡的前提是 annotation 必须实现 title 属性
        annotationView.canShowCallout = true
        // 设置是否可以拖拽
        annotationView.draggable = false
        
        return annotationView
    }
    
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        mapView.bringSubviewToFront(view)
        mapView.setNeedsDisplay()
    }
    
    func mapView(mapView: BMKMapView!, didAddAnnotationViews views: [AnyObject]!) {
        println("标注添加前的方法调用")
    }
    
    // MARK: - Poi 搜索的相关方法实现
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        // 清除屏幕中所有的 annotation
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        
        if errorCode.value == 0 {
            for i in 0..<poiResult.poiInfoList.count {
                var poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                var item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                mapView.addAnnotation(item)
                if i == 0 {
                    // 将第一个点的坐标移到屏幕中央
                    mapView.centerCoordinate = poi.pt
                }
            }
        }else if errorCode.value == 2 {
            println("起始点有歧义")
        }else {
            // 各种情况的判断……
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        poisearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        poisearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}