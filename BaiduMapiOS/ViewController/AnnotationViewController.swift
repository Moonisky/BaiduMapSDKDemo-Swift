//
//  AnnotationViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-6.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController, BMKMapViewDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            // 内置覆盖物
        case 0:
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
            // 添加内置覆盖物
            addOverlayView()
            
            // 添加标注
        case 1:
            mapView.removeOverlays(mapView.overlays)
            addPointAnnotation()
            addAnimatedAnnotation()
            
            // 添加图片图层
        case 2:
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
            addGroundOverlay()
        default:
            return
        }
    }
    
    /// 百度地图视图
    var mapView: BMKMapView!
    
    //属性
    var pointAnnotation: BMKPointAnnotation!
    var animatedAnnotation: BMKPointAnnotation!
    var polygon: BMKPolygon!
    var polygon2: BMKPolygon!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[6]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 界面初始化
        mapView.zoomLevel = 11
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: segment, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 添加覆盖物操作
    
    /// 添加图片图层覆盖物
    func addGroundOverlay() {
        var bundlepath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent("mapapi.bundle")
        var bundle = NSBundle(path: bundlepath!)!
        var image = UIImage(contentsOfFile: bundle.pathForResource("baidumap_logo@2x", ofType: "png", inDirectory: "images")!)
    
        // 第一种
        var coordinator = CLLocationCoordinate2DMake(39.800, 116.404)
        var ground = BMKGroundOverlay(position: coordinator, zoomLevel: 11, anchor: CGPointMake(0, 0), icon: image)
        ground.alpha = 0.5
        mapView.addOverlay(ground)
        
        // 第二种
        var coordinators = [
            CLLocationCoordinate2DMake(39.910, 116.370),
            CLLocationCoordinate2DMake(39.950, 116.430)]
        
        var bound = BMKCoordinateBounds(northEast: coordinators[1], southWest: coordinators[0])
        var ground2 = BMKGroundOverlay(bounds: bound, icon: image)
        mapView.addOverlay(ground2)
    }
    
    // 添加内置覆盖物
    func addOverlayView() {
        // 添加圆形覆盖物
        var coordinator = CLLocationCoordinate2DMake(39.915, 116.404)
        var circle = BMKCircle(centerCoordinate: coordinator, radius: 5000)
        mapView.addOverlay(circle)
        
        // 添加多边形覆盖物
        var coordinators = [
            CLLocationCoordinate2DMake(39.915, 116.404),
            CLLocationCoordinate2DMake(39.815, 116.404),
            CLLocationCoordinate2DMake(39.815, 116.504),
            CLLocationCoordinate2DMake(39.915, 116.504)]
        polygon = BMKPolygon(coordinates: &coordinators, count:4)
        mapView.addOverlay(polygon)
        
        // 添加多边形覆盖物2
        coordinators = [
            CLLocationCoordinate2DMake(39.965, 116.604),
            CLLocationCoordinate2DMake(39.865, 116.604),
            CLLocationCoordinate2DMake(39.865, 116.704),
            CLLocationCoordinate2DMake(39.905, 116.654),
            CLLocationCoordinate2DMake(39.965, 116.704)]
        polygon2 = BMKPolygon(coordinates: &coordinators, count: 5)
        mapView.addOverlay(polygon2)
        
        // 添加折线覆盖物
        coordinators = [
            CLLocationCoordinate2DMake(39.895, 116.354),
            CLLocationCoordinate2DMake(39.815, 116.304)]
        var polyline = BMKPolyline(coordinates: &coordinators, count: 2)
        mapView.addOverlay(polyline)
        
        // 添加圆弧覆盖物
        coordinators = [
            CLLocationCoordinate2DMake(40.065, 116.124),
            CLLocationCoordinate2DMake(40.125, 116.304),
            CLLocationCoordinate2DMake(40.065, 116.404)]
        var arcline = BMKArcline(coordinates: &coordinators)
        mapView.addOverlay(arcline)
    }
    
    /// 添加标注
    func addPointAnnotation() {
        pointAnnotation = BMKPointAnnotation()
        var coordinator = CLLocationCoordinate2DMake(39.915, 116.404)
        pointAnnotation.coordinate = coordinator
        pointAnnotation.title = "测试标注"
        pointAnnotation.subtitle = "这个标注大头针可以被拖曳！"
        mapView.addAnnotation(pointAnnotation)
    }
    
    /// 添加动画标注
    func addAnimatedAnnotation() {
        animatedAnnotation = BMKPointAnnotation()
        var coordinator = CLLocationCoordinate2DMake(40.115, 116.404)
        animatedAnnotation.coordinate = coordinator
        animatedAnnotation.title = "动画标注"
        mapView.addAnnotation(animatedAnnotation)
    }
    
    // MARK: - 覆盖物相应协议实现
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        if (overlay as? BMKCircle) != nil {
            var circleView = BMKCircleView(overlay: overlay)
            circleView.fillColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            circleView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            circleView.lineWidth = 5
            
            return circleView
        }
        
        if (overlay as? BMKPolyline) != nil {
            var polylineView = BMKPolylineView(overlay: overlay)
            polylineView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(1)
            polylineView.lineWidth = 20
            polylineView.loadStrokeTextureImage(UIImage(named: "texture_arrow.png"))
            
            return polylineView
        }
        
        if (overlay as? BMKPolygon) != nil {
            var polygonView = BMKPolygonView(overlay: overlay)
            polygonView.strokeColor = UIColor.purpleColor().colorWithAlphaComponent(1)
            polygonView.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
            polygonView.lineWidth = 2
            polygonView.lineDash = (overlay as! BMKPolygon == polygon2)
            
            return polygonView
        }
        
        if (overlay as? BMKGroundOverlay) != nil {
            var groundView = BMKGroundOverlayView(overlay: overlay)
            
            return groundView
        }
        
        if (overlay as? BMKArcline) != nil {
            var arclineView = BMKArclineView(overlay: overlay)
            arclineView.strokeColor = UIColor.blueColor()
            arclineView.lineDash = true
            arclineView.lineWidth = 6
            
            return arclineView
        }
        return nil
    }
    
    // MARK: - 覆盖物协议设置
    // 根据标注生成对应的视图
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 普通标注
        if annotation as! BMKPointAnnotation == pointAnnotation {
            var AnnotationViewID = "renameMark"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(AnnotationViewID) as! BMKPinAnnotationView?
            if annotationView == nil {
                annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
                // 设置颜色
                annotationView!.pinColor = UInt(BMKPinAnnotationColorPurple)
                // 从天上掉下的动画
                annotationView!.animatesDrop = true
                // 设置可拖曳
                annotationView!.draggable = true
            }
            return annotationView
        }
        
        if annotation as! BMKPointAnnotation == animatedAnnotation {
            // 动画标注
            var AnnotationViewID = "AnimatedAnnotation"
            var annotationView: AnimatedAnnotationView? = nil
            if annotationView == nil {
                annotationView = AnimatedAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            }
            var images = Array(count: 3, repeatedValue: UIImage())
            for i in 1...3 {
                var image = UIImage(named: "poi_\(i).png")
                images[i-1] = image!
            }
            annotationView?.setImages(images)
            return annotationView
        }
        return nil
    }
    
    // 当点击annotation view弹出的泡泡时，调用此接口
    func mapView(mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        println("点击了泡泡~")
    }
    
    // 地图初始化完毕的设置
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        // 添加内置覆盖物
        addOverlayView()
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
