//
//  BusLineViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class BusLineAnnotation: BMKPointAnnotation {
    var type: Int!
    var degree: Int!
    
    override init() {
        super.init()
    }
}

class BusLineViewController: UIViewController, BMKMapViewDelegate, BMKBusLineSearchDelegate, BMKPoiSearchDelegate {
    
    @IBOutlet var txf_City: UITextField!
    @IBOutlet var txf_Busline: UITextField!
    @IBOutlet var btn_downGoing: UIButton!
    
    @IBAction func busline_upGoing(sender: UIButton) {
        
        busPoiArray.removeAll(keepCapacity: false)
        let citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = 0
        citySearchOption.pageCapacity = 10
        citySearchOption.city = txf_City.text
        citySearchOption.keyword = txf_Busline.text
        let flag = poiSearch.poiSearchInCity(citySearchOption)
        
        if flag {
            NSLog("城市内检索发送成功！")
        }else {
            NSLog("城市内检索发送失败！")
        }
    }
    @IBAction func busline_downGoing(sender: UIButton) {
        
        if busPoiArray.count > 0 {
            if ++currentIndex >= busPoiArray.count {
                currentIndex -= busPoiArray.count
            }
            let strKey = (busPoiArray[currentIndex] as BMKPoiInfo).uid
            let buslineSearchOption = BMKBusLineSearchOption()
            buslineSearchOption.city = txf_City.text
            buslineSearchOption.busLineUid = strKey
            let flag = buslineSearch.busLineSearch(buslineSearchOption)
            
            if flag {
                NSLog("公交线路检索发送成功！")
            }else {
                NSLog("公交线路检索发送失败！")
            }
        }else {
            let citySearchOption = BMKCitySearchOption()
            citySearchOption.pageIndex = 0
            citySearchOption.pageCapacity = 10
            citySearchOption.city = txf_City.text
            citySearchOption.keyword = txf_Busline.text
            let flag = poiSearch.poiSearchInCity(citySearchOption)
            
            if flag {
                NSLog("城市内检索发送成功！")
            }else {
                NSLog("城市内检索发送失败！")
            }
        }
    }
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 公交线路查询
    var buslineSearch: BMKBusLineSearch!
    /// Poi 查询
    var poiSearch: BMKPoiSearch!
    /// 公交 Poi 查询数组
    var busPoiArray: [BMKPoiInfo]!
    /// 查询到的页面序号
    var currentIndex = -1
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[11]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
        // 搜索器初始化
        buslineSearch = BMKBusLineSearch()
        poiSearch = BMKPoiSearch()
        busPoiArray = Array(count: 0, repeatedValue: BMKPoiInfo())
        
        // 界面初始化
        txf_City.text = "北京"
        txf_Busline.text = "717"
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(btn_downGoing.bottomAnchor, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // 路径获取函数
    func getBundlePath(filename: String?, Directory: String?) -> String? {
        if let bundlePath = NSBundle.mainBundle().resourceURL?.URLByAppendingPathComponent("mapapi.bundle") {
            guard let bundle = NSBundle(URL: bundlePath) else { return nil }
            if let file = filename, direc = Directory {
                let pathURL = bundle.resourceURL?.URLByAppendingPathComponent(direc)
                return pathURL?.URLByAppendingPathComponent(file).absoluteString
            } else if let file = filename {
                let pathURL = bundle.resourceURL?.URLByAppendingPathComponent(file)
                return pathURL?.absoluteString
            } else if let direct = Directory {
                let pathURL = bundle.resourceURL?.URLByAppendingPathComponent(direct)
                return pathURL?.absoluteString
            }
            return nil
        }
        
        return nil
    }
    
    // MARK: - 覆盖物协议设置
    
    // 获取不同的标注视图
    func getRouteAnnotationView(mapview: BMKMapView!, viewForAnnotation routeAnnotation: BusLineAnnotation!) -> BMKAnnotationView? {
        
        var routeType = ""
        
        switch routeAnnotation.type {
        case 0:
            routeType = "nav_start"
        case 1:
            routeType = "nav_end"
        case 2:
            routeType = "nav_bus"
        case 3:
            routeType = "nav_rail"
        case 4:
            routeType = "direction"
        case 5:
            routeType = "nav_waypoint"
        default:
            return nil
        }
        var view = mapview.dequeueReusableAnnotationViewWithIdentifier("\(routeType)Node")
        if view == nil {
            view = BMKAnnotationView(annotation: routeAnnotation, reuseIdentifier: "\(routeType)Node")
            view?.image = UIImage(contentsOfFile: getBundlePath("icon_\(routeType).png", Directory: "images")!)
            view?.centerOffset = CGPointMake(0, -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        view!.annotation = routeAnnotation
        
        return view!
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if let busLine = annotation as? BusLineAnnotation {
            return getRouteAnnotationView(mapView, viewForAnnotation: busLine)
        }
        return nil
    }
    
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        if let polyline = overlay as? BMKPolyline {
            let polylineView = BMKPolylineView(overlay: polyline)
            polylineView.fillColor = UIColor.cyanColor().colorWithAlphaComponent(1)
            polylineView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            polylineView.lineWidth = 3
            
            return polylineView
        }
        return nil
    }
    
    // MARK: - 百度搜索相关协议实现
    
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if errorCode.rawValue == 0 {
            var poi: BMKPoiInfo?
            var findBusline = false
            for i in 0..<poiResult.poiInfoList.count {
                poi = poiResult.poiInfoList[i] as? BMKPoiInfo
                if poi?.epoitype == 2 || poi?.epoitype == 4 {
                    findBusline = true
                    busPoiArray.append(poi!)
                }
            }
            // 开始 busline 详情搜索
            if findBusline {
                currentIndex = 0
                let strKey = busPoiArray[currentIndex].uid
                let buslineSearchOption = BMKBusLineSearchOption()
                buslineSearchOption.city = "北京市"
                buslineSearchOption.busLineUid = strKey
                let flag = buslineSearch.busLineSearch(buslineSearchOption)
                
                if flag {
                    NSLog("公交线路检索发送成功！")
                }else {
                    NSLog("公交线路检索发送失败！")
                }
            }
        }
    }
    
    // 获取公交详情信息
    func onGetBusDetailResult(searcher: BMKBusLineSearch!, result busLineResult: BMKBusLineResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        
        if error.rawValue == 0 {
            var item = BusLineAnnotation()
            
            // 站点信息
            let size = busLineResult.busStations.count
            for i in 0..<size {
                let station = busLineResult.busStations[i] as! BMKBusStation
                item = BusLineAnnotation()
                item.coordinate = station.location
                item.title = station.title
                item.type = 2
                mapView.addAnnotation(item)
            }
            
            // 路段信息
            var index = 0
            for i in 0..<busLineResult.busSteps.count {
                let step = busLineResult.busSteps[i] as! BMKBusStep
                index += Int(step.pointsCount)
            }
            
            // 直角坐标划线
            var tempPoints = Array(count: index, repeatedValue: BMKMapPoint(x: 0, y: 0))
            var k = 0
            for i in 0..<busLineResult.busSteps.count {
                let step = busLineResult.busSteps[i] as! BMKBusStep
                for j in 0..<step.pointsCount {
                    let point = BMKMapPoint(x: step.points[Int(j)].x, y: step.points[Int(j)].y)
                    tempPoints[k] = point
                    k++
                }
            }
            
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(index))
            mapView.addOverlay(polyLine)
            
            let start = busLineResult.busStations[0] as! BMKBusStation
            mapView.setCenterCoordinate(start.location, animated: true)
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        buslineSearch.delegate = self
        poiSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        buslineSearch.delegate = nil
        poiSearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

