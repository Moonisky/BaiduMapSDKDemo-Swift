//
//  ShortURLShareViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit
import MessageUI

class ShortURLShareViewController: UIViewController, BMKMapViewDelegate, BMKShareURLSearchDelegate, BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet var btn_sharePoiResults: UIButton!
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 分享 URL 功能
    var shareURLSearch: BMKShareURLSearch!
    /// 地理位置反向编码功能
    var geoCodeSearch: BMKGeoCodeSearch!
    /// Poi 搜索功能
    var poiSearch: BMKPoiSearch!
    /// 判断是否调启 Poi 短串分享功能
    var isPoiShortURLShare: Bool!
    
    /// 名称
    var geoName: String!
    /// 地址
    var address: String!
    /// 坐标
    var point: CLLocationCoordinate2D!
    /// 短串
    var shortURL: String!
    /// 分享字符串
    var showMessage: String!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[14]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 界面初始化
        mapView.zoomLevel = 13
        
        // 添加说明按钮
        var customRightBarButtonItem = UIBarButtonItem(title: "说明", style: .Plain, target: self, action: Selector("showGuide"))
        self.navigationItem.rightBarButtonItem = customRightBarButtonItem
        
        // 初始化搜索服务
        shareURLSearch = BMKShareURLSearch()
        geoCodeSearch = BMKGeoCodeSearch()
        poiSearch = BMKPoiSearch()
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: btn_sharePoiResults, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // 1. 点击[poi 搜索结果分享]，首先发起 poi 搜索请求
    @IBAction func sharePoiResults(sender: UIButton) {
        var citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = 0
        citySearchOption.pageCapacity = 10
        citySearchOption.city = "北京"
        citySearchOption.keyword = "故宫博物院"
        var flag = poiSearch.poiSearchInCity(citySearchOption)
        if flag {
            NSLog("城市内检索发送成功！")
        }else {
            NSLog("城市内检索发送失败！")
        }
    }
    
    // 2.搜索发送成功后，在回调中根据 UID 发起 poi 短串搜索请求
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        // 清除屏幕中所有的标注
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        
        if errorCode.value == 0 {
            if poiResult.poiInfoList.count > 0 {
                // 获取第一个 poi 点的数据
                var poi = poiResult.poiInfoList[0] as! BMKPoiInfo
                // 将数据保存到图标上
                var item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                mapView.addAnnotation(item)
                mapView.centerCoordinate = poi.pt
                
                // 保存数据以便用于分享
                // 名字
                geoName = poi.name
                // 地址
                address = poi.address
                // 发起短串搜索获取 poi 分享 URL
                var detailShareURLSearchOption = BMKPoiDetailShareURLOption()
                detailShareURLSearchOption.uid = poi.uid
                var flag = shareURLSearch.requestPoiDetailShareURL(detailShareURLSearchOption)
                if flag {
                    NSLog("详情 URL 检索发送成功！")
                }else {
                    NSLog("详情 URL 检索发送失败！")
                }
            }
        }
    }
    
    // 1.点击反向地理编码结果分享，首先发起反向地理编码搜索
    @IBAction func shareGeocodeResults(sender: UIButton) {
        // 坐标
        point = CLLocationCoordinate2DMake(116.403981, 39.915101)
        
        var reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeocodeSearchOption.reverseGeoPoint = point
        var flag = geoCodeSearch.reverseGeoCode(reverseGeocodeSearchOption)
        if flag {
            NSLog("反向地理编码检索发送成功！")
        }else {
            NSLog("反向地理编码检索发送失败！")
        }
    }
    
    // 2.搜索成功后，在回调中根据参数发起地理编码短串搜索
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
            
            // 保存数据以便用于分享
            // 名字——气泡上所显示的名字，可以自定义
            geoName = "自定义的气泡名称"
            // 地址
            address = result.address
            // 发起短串搜索功能获取反向地理位置分享 URL
            var option = BMKLocationShareURLOption()
            option.snippet = address
            option.name = geoName
            option.location = point
            var flag = shareURLSearch.requestLocationShareURL(option)
            if flag {
                NSLog("反向地理位置 URL 检索发送成功！")
            }else {
                NSLog("反向地理位置 URL 检索发送失败！")
            }
        }
    }
    
    // 3.返回短串分享 URL
    func onGetPoiDetailShareURLResult(searcher: BMKShareURLSearch!, result: BMKShareURLResult!, errorCode error: BMKSearchErrorCode) {
        shortURL = result.url
        if error.value == 0 {
            showMessage = "这里是\(geoName)\r\n\(address)\r\n\(shortURL)"
            var alertView = UIAlertController(title: "短串分享", message:  showMessage, preferredStyle: .Alert)
            var shareAction = UIAlertAction(title: "分享", style: .Default, handler: { Void in
                if MFMessageComposeViewController.canSendText() {
                    var message = MFMessageComposeViewController()
                    message.messageComposeDelegate = self
                    message.body = self.showMessage
                    self.presentViewController(message, animated: true, completion: nil)
                }else {
                    var alertView = UIAlertController(title: "当前设备暂时没有办法发送短信", message: nil, preferredStyle: .Alert)
                    var okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            })
            var cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alertView.addAction(shareAction)
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func onGetLocationShareURLResult(searcher: BMKShareURLSearch!, result: BMKShareURLResult!, errorCode error: BMKSearchErrorCode) {
        shortURL = result.url
        if error.value == 0 {
            showMessage = "这里是\(geoName)\r\n\(address)\r\n\(shortURL)"
            var alertView = UIAlertController(title: "短串分享", message:  showMessage, preferredStyle: .Alert)
            var shareAction = UIAlertAction(title: "分享", style: .Default, handler: nil)
            var cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alertView.addAction(shareAction)
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    // 显示说明
    func showGuide() {
        var alertView = UIAlertController(title: "短串分享－说明", message: "短串分享是将POI点、反Geo点，生成短链接串，此链接可通过短信等形式分享给好友，好友在终端设备点击此链接可快速打开Web地图、百度地图客户端进行信息展示", preferredStyle: .Alert)
        var okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: - 覆盖物协议设置
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 生成重用的标识 ID
        var annotationID = "testMark"
        
        // 检查是否有重用的缓存
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationID)
        
        // 缓存没有命中，则自行构造一个，一般首次添加标注代码会运行到此处
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
            (annotationView as! BMKPinAnnotationView).pinColor = UInt(BMKPinAnnotationColorRed)
            // 设置从天上掉下来的效果
            (annotationView as! BMKPinAnnotationView).animatesDrop = true
        }
        
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5))
        annotationView.annotation = annotation
        // 单击弹出气泡，弹出气泡的前提是标注必须实现title 属性   
        annotationView.canShowCallout = true
        // 设置是否可以拖拽
        annotationView.draggable = false
        
        return annotationView
    }
    
    // MARK: - Message 相关协议实现
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch result.value {
        case 0:
            // 用户自己取消，不用提醒
            NSLog("用户取消发送")
        case 1:
            // 后续可能不能够成功发送，所以不提醒
            NSLog("用户提交发送")
        case 2:
            NSLog("发送失败")
        default:
            NSLog("短信没有发送")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        shareURLSearch.delegate = self
        geoCodeSearch.delegate = self
        poiSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        shareURLSearch.delegate = nil
        geoCodeSearch.delegate = nil
        poiSearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
