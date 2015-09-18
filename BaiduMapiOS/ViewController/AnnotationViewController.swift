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
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
        // 界面初始化
        mapView.zoomLevel = 11
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(segment.bottomAnchor, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 添加覆盖物操作
    
    /// 添加图片图层覆盖物
    func addGroundOverlay() {
        let image = UIImage(named: "test")
    
        // 第一种
        let coordinator = CLLocationCoordinate2DMake(39.800, 116.404)
        let ground = BMKGroundOverlay(position: coordinator, zoomLevel: 11, anchor: CGPointMake(0, 0), icon: image)
        ground.alpha = 0.5
        mapView.addOverlay(ground)
        
        // 第二种
        let coordinators = [
            CLLocationCoordinate2DMake(39.910, 116.370),
            CLLocationCoordinate2DMake(39.950, 116.430)
        ]
        let bound = BMKCoordinateBounds(northEast: coordinators[1], southWest: coordinators[0])
        let ground2 = BMKGroundOverlay(bounds: bound, icon: image)
        mapView.addOverlay(ground2)
    }
    
    // 添加内置覆盖物
    func addOverlayView() {
        // 添加圆形覆盖物
        let coordinator = CLLocationCoordinate2DMake(39.915, 116.404)
        let circle = BMKCircle(centerCoordinate: coordinator, radius: 5000)
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
        let polyline = BMKPolyline(coordinates: &coordinators, count: 2)
        mapView.addOverlay(polyline)
        
        // 添加圆弧覆盖物
        coordinators = [
            CLLocationCoordinate2DMake(40.065, 116.124),
            CLLocationCoordinate2DMake(40.125, 116.304),
            CLLocationCoordinate2DMake(40.065, 116.404)]
        let arcline = BMKArcline(coordinates: &coordinators)
        mapView.addOverlay(arcline)
    }
    
    /// 添加标注
    func addPointAnnotation() {
        pointAnnotation = BMKPointAnnotation()
        let coordinator = CLLocationCoordinate2DMake(39.915, 116.404)
        pointAnnotation.coordinate = coordinator
        pointAnnotation.title = "测试标注"
        pointAnnotation.subtitle = "这个标注大头针可以被拖曳！"
        mapView.addAnnotation(pointAnnotation)
    }
    
    /// 添加动画标注
    func addAnimatedAnnotation() {
        animatedAnnotation = BMKPointAnnotation()
        let coordinator = CLLocationCoordinate2DMake(40.115, 116.404)
        animatedAnnotation.coordinate = coordinator
        animatedAnnotation.title = "动画标注"
        mapView.addAnnotation(animatedAnnotation)
    }
    
    // MARK: - 覆盖物相应协议实现
    func mapView(mapView: BMKMapView!, viewForOverlay overlay: BMKOverlay!) -> BMKOverlayView! {
        if let circle = overlay as? BMKCircle {
            let circleView = BMKCircleView(overlay: circle)
            circleView.fillColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            circleView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            circleView.lineWidth = 5
            
            return circleView
            
        } else if let polyline = overlay as? BMKPolyline {
            let polylineView = BMKPolylineView(overlay: polyline)
            polylineView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(1)
            polylineView.lineWidth = 20
            polylineView.loadStrokeTextureImage(UIImage(named: "texture_arrow.png"))
            
            return polylineView
            
        } else if let polygon = overlay as? BMKPolygon {
            let polygonView = BMKPolygonView(overlay: polygon)
            polygonView.strokeColor = UIColor.purpleColor().colorWithAlphaComponent(1)
            polygonView.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
            polygonView.lineWidth = 2
            polygonView.lineDash = (overlay as! BMKPolygon == polygon2)
            
            return polygonView
            
        } else if let ground = overlay as? BMKGroundOverlay {
            let groundView = BMKGroundOverlayView(overlay: ground)
            
            return groundView
            
        } else if let arcline = overlay as? BMKArcline {
            let arclineView = BMKArclineView(overlay: arcline)
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
            let AnnotationViewID = "renameMark"
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
            let AnnotationViewID = "AnimatedAnnotation"
            var annotationView: AnimatedAnnotationView? = nil
            if annotationView == nil {
                annotationView = AnimatedAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            }
            var images = Array(count: 3, repeatedValue: UIImage())
            for i in 1...3 {
                let image = UIImage(named: "poi_\(i).png")
                images[i-1] = image!
            }
            annotationView?.setImages(images)
            return annotationView
        }
        return nil
    }
    
    // 当点击annotation view弹出的泡泡时，调用此接口
    func mapView(mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        print("点击了泡泡~")
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
