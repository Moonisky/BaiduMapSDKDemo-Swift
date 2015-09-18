//
//  CloudSearchViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

/* 

本示例代码使用了测试 ak 和测试数据，开发者在检索自己的 LBS 数据之前，需要替换 cloudLocalSearch.ak 和 cloudLocalSearch.geoTableId 的值

1、替换 cloudLocalSearch.ak 的值
（1）请访问http://lbsyun.baidu.com/apiconsole/key申请一个“服务端”的ak，其他类型的ak无效；
（2）将申请的ak替换cloudLocalSearch.ak的值;

2、替换cloudLocalSearch.geoTableId值
（1）申请完服务端ak后访问http://lbsyun.baidu.com/datamanager/datamanage创建一张表；
（2）在“表名称”处自由填写表的名称，如MyData，点击保存；
（3）“创建”按钮右方将会出现形如“MyData(34195)”字样，其中的“34195”即为geoTableId的值；
（4）添加或修改字段：点击“字段”标签修改和添加字段；
（5）添加数据：
    a、标注模式：“数据” ->“标注模式”，输入要添加的地址然后“百度一下”，点击地图蓝色图标，再点击保存即可；
    b、批量模式： “数据” ->“批量模式”，可上传文件导入，具体文件格式要求请参见当页的“批量导入指南”；
（6）选择左边“设置”标签，“是否发布到检索”选择“是”，然后"保存";
（7）数据发布后，替换cloudLocalSearch.geoTableId的值即可；
备注：切记添加、删除或修改数据后要再次发布到检索，否则将会出现检索不到修改后数据的情况
*/

import UIKit

class CloudSearchViewController: UIViewController, BMKMapViewDelegate, BMKCloudSearchDelegate {
    
    @IBOutlet var btn_localCloudSearch: UIButton!
    
    // 发起本地云检索
    @IBAction func localCloudSearch(sender: UIButton) {
        let cloudLocalSearch = BMKCloudLocalSearchInfo()
        cloudLocalSearch.ak = "B266f735e43ab207ec152deff44fec8b"
        cloudLocalSearch.geoTableId = 31869
        cloudLocalSearch.pageIndex = 0
        cloudLocalSearch.pageSize = 10
        cloudLocalSearch.region = "北京市"
        cloudLocalSearch.keyword = "天安门"
        let flag = cloudSearch.localSearchWithSearchInfo(cloudLocalSearch)
        if flag {
            NSLog("本地云检索发送成功！")
        }else {
            NSLog("本地云检索发送失败！")
        }
    }
    
    // 发起周边云检索
    @IBAction func nearbySearch(sender: UIButton) {
        let cloudNearbySearch = BMKCloudNearbySearchInfo()
        cloudNearbySearch.ak = "B266f735e43ab207ec152deff44fec8b"
        cloudNearbySearch.geoTableId = 31869
        cloudNearbySearch.pageIndex = 0
        cloudNearbySearch.pageSize = 10
        cloudNearbySearch.location = "116.403402,39.915067"
        cloudNearbySearch.radius = 5
        cloudNearbySearch.keyword = "天安门"
        let flag = cloudSearch.nearbySearchWithSearchInfo(cloudNearbySearch)
        if flag {
            NSLog("周边云检索发送成功！")
        }else {
            NSLog("周边云检索发送失败！")
        }
    }
    
    // 发起矩形云检索
    @IBAction func boundSearch(sender: UIButton) {
        let cloudBoundSearch = BMKCloudBoundSearchInfo()
        cloudBoundSearch.ak = "B266f735e43ab207ec152deff44fec8b"
        cloudBoundSearch.geoTableId = 31869
        cloudBoundSearch.pageIndex = 0
        cloudBoundSearch.pageSize = 10
        cloudBoundSearch.bounds = "116.30,36.20;118.30,40.20"
        cloudBoundSearch.keyword = "天安门"
        let flag = cloudSearch.boundSearchWithSearchInfo(cloudBoundSearch)
        if flag {
            NSLog("矩形云检索发送成功！")
        }else {
            NSLog("矩形云检索发送失败！")
        }
    }
    
    // 发起详情云检索
    @IBAction func DetailSearch(sender: UIButton) {
        let cloudDetailSearch = BMKCloudDetailSearchInfo()
        cloudDetailSearch.ak = "B266f735e43ab207ec152deff44fec8b"
        cloudDetailSearch.geoTableId = 31869
        cloudDetailSearch.uid = "19150264"
        let flag = cloudSearch.detailSearchWithSearchInfo(cloudDetailSearch)
        if flag {
            NSLog("详情云检索发送成功！")
        }else {
            NSLog("详情云检索发送失败！")
        }
    }
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 百度地图云检索服务
    var cloudSearch: BMKCloudSearch!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[15]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        mapView.zoomLevel = 13
        mapView.isSelectedAnnotationViewFront = true
          
        // 初始化导航栏右侧按钮“说明”
        let customRightBarBuutonItem = UIBarButtonItem(title: "说明", style: .Plain, target: self, action: Selector("showGuide"))
        self.navigationItem.rightBarButtonItem = customRightBarBuutonItem
        
        // 初始化云检索服务
        cloudSearch = BMKCloudSearch()
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(btn_localCloudSearch.bottomAnchor, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // 说明按钮
    func showGuide() {
        let alertView = UIAlertController(title: "LBS.云检索－说明", message: "本示例使用了测试ak,开发者若需使用自有LBS数据,请留意代码中相关注释", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: - 地图覆盖物相关协议实现
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 生成重用标识 ID
        let annotationViewID = "'xidanMark"
        
        // 检查是否有重用的缓存
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewID)
        
        // 如果缓存没有命中，则自行构建一个标注
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewID)
            (annotationView as! BMKPinAnnotationView).pinColor = UInt(BMKPinAnnotationColorRed)
            // 设置从天上掉下来的效果
            (annotationView as! BMKPinAnnotationView).animatesDrop = true
        }
        
        // 设置位置
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5))
        annotationView.annotation = annotation
        // 单击弹出气泡，弹出气泡的前提是标注必须要实现 title 属性
        annotationView.canShowCallout = true
        // 设置是否可以拖拽
        annotationView.draggable = false
        
        return annotationView
    }
    
    // MARK: - 百度云检索相关协议
    
    func onGetCloudPoiResult(poiResultList: [AnyObject]!, searchType type: Int32, errorCode error: Int32) {
        // 清除屏幕中所有的标注
        let array = mapView.annotations
        mapView.removeAnnotations(array)
        
        if error == 0 {
            let result = poiResultList[0] as! BMKCloudPOIList
            for i in 0..<result.POIs.count {
                let poi = result.POIs[i] as! BMKCloudPOIInfo
                // 自定义字段
                if poi.customDict != nil && poi.customDict.count > 1 {
                    let customStringField = poi.customDict.objectForKey("custom") as! String
                    NSLog("custom field output = \(customStringField)")
                    let customDoubleField = poi.customDict.objectForKey("double") as! Double
                    NSLog("custom double field output = \(customDoubleField)")
                }
                
                let item = BMKPointAnnotation()
                let point = CLLocationCoordinate2DMake(Double(poi.longitude), Double(poi.latitude))
                item.coordinate = point
                item.title = poi.title
                mapView.addAnnotation(item)
                if i == 0 {
                    // 将第一个点的坐标移到屏幕中央
                    mapView.centerCoordinate = point
                }
            }
        }else {
            NSLog("error == \(error)")
        }
    }
    
    func onGetCloudPoiDetailResult(poiDetailResult: BMKCloudPOIInfo!, searchType type: Int32, errorCode error: Int32) {
        // 清除屏幕中所有的标注
        let array = mapView.annotations
        mapView.removeAnnotations(array)
        
        if error == 0 {
            let poi = poiDetailResult
            let item = BMKPointAnnotation()
            let point = CLLocationCoordinate2DMake(Double(poi.longitude), Double(poi.latitude))
            item.coordinate = point
            item.title = poi.title
            mapView.addAnnotation(item)
            // 将第一个点的坐标移到屏幕中央
            mapView.centerCoordinate = point
        }else {
            NSLog("error == \(error)")
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        cloudSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        cloudSearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

