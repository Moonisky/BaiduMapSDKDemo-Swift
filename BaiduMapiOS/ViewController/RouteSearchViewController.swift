//
//  RouteSearchViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class RouteSearchViewController: UIViewController, BMKMapViewDelegate, BMKRouteSearchDelegate {
    
    /// 输出口与动作
    @IBOutlet var txf_StartCity: UITextField!
    @IBOutlet var txf_StartPlace: UITextField!
    @IBOutlet var txf_EndCity: UITextField!
    @IBOutlet var txf_EndPlace: UITextField!
    @IBOutlet var btn_Bus: UIButton!
    
    @IBAction func SearchBusRoute(sender: UIButton) {
        var start = BMKPlanNode()
        start.name = txf_StartPlace.text
        var end = BMKPlanNode()
        end.name = txf_EndPlace.text
        
        var transitRouteSearchOption = BMKTransitRoutePlanOption()
        transitRouteSearchOption.city = txf_StartCity.text
        transitRouteSearchOption.from = start
        transitRouteSearchOption.to = end
        
        var flag = routeSearch.transitSearch(transitRouteSearchOption)
        if flag {
            println("公交检索发送成功！")
        }else {
            println("公交检索发送失败！")
        }
    }
    
    @IBAction func SearchDriveRoute(sender: UIButton) {
        var start = BMKPlanNode()
        start.name = txf_StartPlace.text
        start.cityName = txf_StartCity.text
        var end = BMKPlanNode()
        end.name = txf_EndPlace.text
        end.cityName = txf_EndCity.text
        
        var drivingRouteSearchOption = BMKDrivingRoutePlanOption()
        drivingRouteSearchOption.from = start
        drivingRouteSearchOption.to = end
        var flag = routeSearch.drivingSearch(drivingRouteSearchOption)
        
        if flag {
            println("驾乘检索发送成功！")
        }else {
            println("驾乘检索发送失败！")
        }
    }
    
    @IBAction func SearchWalkRoute(sender: UIButton) {
        var start = BMKPlanNode()
        start.name = txf_StartPlace.text
        start.cityName = txf_StartCity.text
        var end = BMKPlanNode()
        end.name = txf_EndPlace.text
        end.cityName = txf_EndCity.text
        
        var walkingRouteSearchOption = BMKWalkingRoutePlanOption()
        walkingRouteSearchOption.from = start
        walkingRouteSearchOption.to = end
        var flag = routeSearch.walkingSearch(walkingRouteSearchOption)
        
        if flag {
            println("步行检索发送成功！")
        }else {
            println("步行检索发送失败！")
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
        self.title = arrayOfDemoName[10]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 界面初始化
        txf_StartCity.text = "北京"
        txf_StartPlace.text = "天安门"
        txf_EndCity.text = "北京"
        txf_EndPlace.text = "中关村"
        
        // 路径搜索初始化
        routeSearch = BMKRouteSearch()
        
        // 在导航栏上添加“途径点”按钮
        var screenshotBarButton = UIBarButtonItem(title: "途经点", style: .Plain, target: self, action: Selector("wayPointRouteSearch"))
        self.navigationItem.rightBarButtonItem = screenshotBarButton
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: btn_Bus, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // 路径获取函数
    func getBundlePath(filename: String?, Directory: String?) -> String? {
        var bundlePath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent("mapapi.bundle")
        var bundle = NSBundle(path: bundlePath!)
        if bundle != nil && filename != nil && Directory != nil {
            var directory = bundle?.resourcePath?.stringByAppendingPathComponent(Directory!)
            var string = directory?.stringByAppendingPathComponent(filename!)
            return string!
        }
        if bundle != nil && filename != nil {
            var string = bundle?.resourcePath?.stringByAppendingPathComponent(filename!)
            return string!
        }
        if bundle != nil && Directory != nil {
            var string = bundle?.resourcePath?.stringByAppendingPathComponent(Directory!)
            return string!
        }
        return nil
    }
    
    // MARK: - 途径点函数的实现
    func wayPointRouteSearch() {
        
        var wayPointRouteSearch = self.storyboard?.instantiateViewControllerWithIdentifier("WayPointRouteSearch") as! WayPointRouteSearchViewController
        var backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "返回"
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationController!.pushViewController(wayPointRouteSearch, animated: true)
    }
    
    // MARK: - 覆盖物协议设置
    
    func getRouteAnnotationView(mapview: BMKMapView, viewForAnnotation routeAnnotation: RouteAnnotation) -> BMKAnnotationView? {
        
        var view: BMKAnnotationView? = nil
        var routeType: String = ""
        
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
        view = mapview.dequeueReusableAnnotationViewWithIdentifier("\(routeType)Node")
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
        if annotation as! RouteAnnotation? != nil {
            return getRouteAnnotationView(mapView, viewForAnnotation: annotation as! RouteAnnotation)
        }
        return nil
    }
    
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            var polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView.fillColor = UIColor.cyanColor().colorWithAlphaComponent(1)
            polylineView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            polylineView.lineWidth = 3
            
            return polylineView
        }
        return nil
    }
    
    // MARK: - 路径获取协议实现
    
    func onGetTransitRouteResult(searcher: BMKRouteSearch!, result: BMKTransitRouteResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        
        if error.value == 0 {
            var plan = result.routes[0] as! BMKTransitRouteLine
            // 计算路线方案中的路段数目
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                var transitStep = plan.steps[i] as! BMKTransitStep
                if i == 0 {
                   var item = RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }else if i == size - 1 {
                    var item = RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                var item = RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.instruction
                item.type = 3
                mapView.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 轨迹点
            var tempPoints = Array(count: planPointCounts, repeatedValue: BMKMapPoint(x: 0, y: 0))
            var i = 0
            for j in 0..<size {
                var transitStep = plan.steps[j] as! BMKTransitStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i++
                }
            }
            
            // 通过 points 构建 BMKPolyline
            var polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            mapView.addOverlay(polyLine)  // 添加路线 overlay
        }
    }
    
    func onGetDrivingRouteResult(searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        
        if error.value == 0 {
            var plan = result.routes[0] as! BMKDrivingRouteLine
            // 计算路线方案中的路段数目
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                var transitStep = plan.steps[i] as! BMKDrivingStep
                if i == 0 {
                    var item = RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }else if i == size - 1 {
                    var item = RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                // 添加 annotation 节点
                var item = RouteAnnotation()
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
                    var item = RouteAnnotation()
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
                var transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i++
                }
            }
            
            // 通过 points 构建 BMKPolyline
            var polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            mapView.addOverlay(polyLine)  // 添加路线 overlay
        }
    }
    
    func onGetWalkingRouteResult(searcher: BMKRouteSearch!, result: BMKWalkingRouteResult!, errorCode error: BMKSearchErrorCode) {
        var array = mapView.annotations
        mapView.removeAnnotations(array)
        array = mapView.overlays
        mapView.removeOverlays(array)
        
        if error.value == 0 {
            var plan = result.routes[0] as! BMKWalkingRouteLine
            // 计算路线方案中的路段数目
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                var transitStep = plan.steps[i] as! BMKWalkingStep
                if i == 0 {
                    var item = RouteAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }else if i == size - 1 {
                    var item = RouteAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                // 添加 annotation 节点
                var item = RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.entraceInstruction
                item.degree = Int(transitStep.direction) * 30
                item.type = 4
                mapView.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 轨迹点
            var tempPoints = Array(count: planPointCounts, repeatedValue: BMKMapPoint(x: 0, y: 0))
            var i = 0
            for j in 0..<size {
                var transitStep = plan.steps[j] as! BMKWalkingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i++
                }
            }
            
            // 通过 points 构建 BMKPolyline
            var polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
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
