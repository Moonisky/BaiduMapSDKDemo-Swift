//
//  GeoCodeViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class GeocodeViewController: UIViewController, BMKMapViewDelegate, BMKGeoCodeSearchDelegate {
    
    /// 输出口与动作
    @IBOutlet var txf_City: UITextField!
    @IBOutlet var txf_Address: UITextField!
    @IBOutlet var txf_Latitude: UITextField!
    @IBOutlet var txf_Longtitude: UITextField!
    
    @IBAction func geocode(sender: UIButton) {
        isGeoSearch = true
        var geocodeSearchOption = BMKGeoCodeSearchOption()
        geocodeSearchOption.city = txf_City.text
        geocodeSearchOption.address = txf_Address.text
        var flag = geocodeSearch.geoCode(geocodeSearchOption)
        if flag {
            println("geo 检索发送成功！")
        }else {
            println("geo 检索发送失败！")
        }
    }
    
    @IBAction func ungeocode(sender: UIButton) {
        isGeoSearch = false
        var point = CLLocationCoordinate2DMake(0, 0)
        if txf_Latitude.text != nil && txf_Longtitude.text != nil {
            point = CLLocationCoordinate2DMake(CLLocationDegrees((txf_Longtitude.text as NSString).floatValue), CLLocationDegrees((txf_Latitude.text as NSString).floatValue))
        }
        var unGeocodeSearchOption = BMKReverseGeoCodeOption()
        unGeocodeSearchOption.reverseGeoPoint = point
        var flag = geocodeSearch.reverseGeoCode(unGeocodeSearchOption)
        if flag {
            println("反 geo 检索发送成功")
        }else {
            println("反 geo 检索发送失败")
        }
    }
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 地理位置编码
    var geocodeSearch: BMKGeoCodeSearch!
    
    var isGeoSearch: Bool!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[9]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 界面初始化
        txf_City.text = "北京"
        txf_Address.text = "海淀区"
        txf_Latitude.text = "116.403981"
        txf_Longtitude.text = "39.915101"
        mapView.zoomLevel = 14
        
        // 地理编码器初始化
        geocodeSearch = BMKGeoCodeSearch()
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: txf_Latitude, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 覆盖物协议设置
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        var annotationViewID = "annotationViewID"
        // 根据指定标识查找一个可被复用的标注 View，一般在 delegate 中使用，用此函数来代替新申请一个 View
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
        
        return annotationView
    }
    
    // MARK: - 地理解码相关协议实现
    
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        if error.value == 0 {
            var item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            mapView.centerCoordinate = result.location
            var title = "正向地理编码"
            var showMessage = "经度:\(item.coordinate.latitude)，纬度:\(item.coordinate.longitude)"
            
            var alertView = UIAlertController(title: title, message: showMessage, preferredStyle: .Alert)
            var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        if error.value == 0 {
            var item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            mapView.centerCoordinate = result.location
            
            var title = "反向地理编码"
            var showMessage = "\(item.title)"
            
            var alertView = UIAlertController(title: title, message: showMessage, preferredStyle: .Alert)
            var okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }

    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        geocodeSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        geocodeSearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
