//
//  MapControlViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-17.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class MapControlViewController: UIViewController, BMKMapViewDelegate {
    
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var txf_Zoom: UITextField!
    @IBOutlet weak var txf_Rotate: UITextField!
    @IBOutlet weak var txf_Overlook: UITextField!
    /// 百度地图视图
    var mapView: BMKMapView!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[3]
        
        // 相关UI控件初始化
        txf_Zoom.text = "10"
        txf_Rotate.text = "90"
        txf_Overlook.text = "-30"
        
        // 在导航栏上添加“截图”按钮
        var screenshotBarButton = UIBarButtonItem(title: "截图", style: .Plain, target: self, action: Selector("screenshoot"))
        self.navigationItem.rightBarButtonItem = screenshotBarButton
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(mapView)
        
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: lbl_text, attribute: .Bottom, multiplier: 1, constant: 8))
        self.view.addConstraints(constraints)
    }
    
    // MARK: - Selector相关函数

    // 截图并保存到相册当中
    func screenshoot() {
        var image = mapView.takeSnapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    // MARK: - MapView手势操作
    
    // 点击地图标注后调用
    func mapView(mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        println("您点击了地图标注\(mapPoi.text)，当前经纬度:(\(mapPoi.pt.longitude),\(mapPoi.pt.latitude))，缩放级别:\(mapView.zoomLevel)，旋转角度:\(mapView.rotation)，俯视角度:\(mapView.overlooking)")
    }
    
    // 点击地图空白处后调用
    func mapView(mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
         println("您点击了地图空白处，当前经纬度:(\(coordinate.longitude),\(coordinate.latitude))，缩放级别:\(mapView.zoomLevel)，旋转角度:\(mapView.rotation)，俯视角度:\(mapView.overlooking)")
    }
    
    // 双击地图后调用
    func mapview(mapView: BMKMapView!, onDoubleClick coordinate: CLLocationCoordinate2D) {
        println("您双击了地图，当前经纬度:(\(coordinate.longitude),\(coordinate.latitude))，缩放级别:\(mapView.zoomLevel)，旋转角度:\(mapView.rotation)，俯视角度:\(mapView.overlooking)")
    }
    
    // 长按地图后调用
    func mapview(mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
        println("您长按了地图，当前经纬度:(\(coordinate.longitude),\(coordinate.latitude))，缩放级别:\(mapView.zoomLevel)，旋转角度:\(mapView.rotation)，俯视角度:\(mapView.overlooking)")
    }
    
    // 地图区域发生变更后调用
    func mapView(mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        println("当前地图区域发生了变化(x = \(mapView.visibleMapRect.origin.x), y = \(mapView.visibleMapRect.origin.y), ")
        println("width = \(mapView.visibleMapRect.size.width), height = \(mapView.visibleMapRect.size.height). )")
        println("ZoomLevel = \(mapView.zoomLevel), RotateAngle = \(mapView.rotation), OverlookAngle = \(mapView.overlooking)")
    }
    
    
    // MARK: - UI控件动作处理
    
    // 当文本框区域值发生变化时操作
    @IBAction func TextfieldValueChange(sender: UITextField) {
        var value = sender.text.toInt()
        if value != nil {
            switch sender.tag {
            case 0:
                // 地图比例尺级别，在手机上当前可使用的级别为3-20级
                mapView.zoomLevel = Float(value!)
            case 1:
                // 地图旋转角度，在手机上当前可使用的范围为－180～180度
                mapView.rotation = Int32(value!)
            case 2:
                //地图俯视角度，在手机上当前可使用的范围为－45～0度
                mapView.overlooking = Int32(value!)
            default:
                break
            }
        }
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
