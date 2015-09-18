//
//  WayPointRouteSearchViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-18.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class WayPointRouteSearchViewController: UIViewController, BMKMapViewDelegate, BMKRouteSearchDelegate {
    
    @IBOutlet var txf_startAddress: UITextField!
    @IBOutlet var txf_wayPoint: UITextField!
    @IBOutlet var txf_endAddress: UITextField!
    
    @IBAction func drivePathSearch(sender: UIButton) {
        
        let start = BMKPlanNode()
        start.name = txf_startAddress.text
        start.cityName = "北京市"
        let end = BMKPlanNode()
        end.name = txf_endAddress.text
        end.cityName = "北京市"
        var array = Array(count: 0, repeatedValue: BMKPlanNode())
        let wayPointItem1 = BMKPlanNode()
        wayPointItem1.cityName = "北京市"
        wayPointItem1.name = txf_wayPoint.text
        array.append(wayPointItem1)
        
        let drivingRouteSearchOption = BMKDrivingRoutePlanOption()
        drivingRouteSearchOption.from = start
        drivingRouteSearchOption.to = end
        drivingRouteSearchOption.wayPointsArray = array
        let flag = routeSearch.drivingSearch(drivingRouteSearchOption)
        
        if flag {
            NSLog("搜索成功！")
        }else {
            NSLog("搜素失败！")
        }
    }
    
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 路径搜索控制器
    var routeSearch: BMKRouteSearch!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[18]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
        // 界面初始化
        txf_startAddress.text = "天安门"
        txf_wayPoint.text = "东直门"
        txf_endAddress.text = "中关村"
        
        // 路径搜索初始化
        routeSearch = BMKRouteSearch()
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(txf_endAddress.bottomAnchor, constant: 8))
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
    
    func getRouteAnnotationView(mapview: BMKMapView, viewForAnnotation routeAnnotation: RouteAnnotation) -> BMKAnnotationView? {
        
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
        if let route = annotation as? RouteAnnotation {
            return getRouteAnnotationView(mapView, viewForAnnotation: route)
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
    
    // MARK: - 路径获取协议实现
    
    func onGetDrivingRouteResult(searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        
        if error.rawValue == 0 {
            let plan = result.routes[0] as! BMKDrivingRouteLine
            // 计算路线方案中的路段数目
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKDrivingStep
                if i == 0 {
                    let item = RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }else if i == size - 1 {
                    let item = RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                // 添加 annotation 节点
                let item = RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.instruction
                item.degree = Int(transitStep.direction) * 30
                item.type = 4
                mapView.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 添加途径点
            if plan.wayPoints != nil {
                for tempNode in plan.wayPoints as! [BMKPlanNode] {
                    let item = RouteAnnotation()
                    item.coordinate = tempNode.pt
                    item.type = 5
                    item.title = tempNode.name
                    mapView.addAnnotation(item)
                }
            }
            
            // 轨迹点
            var tempPoints = Array(count: planPointCounts, repeatedValue: BMKMapPoint(x: 0, y: 0))
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i++
                }
            }
            
            // 通过 points 构建 BMKPolyline
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            mapView.addOverlay(polyLine)  // 添加路线 overlay
        }
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        routeSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        routeSearch.delegate = nil
    }
    
    // MARK: - 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
