//
//  OpenGLViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-8.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

struct GLPoint {
    var x: GLfloat = 0
    var y: GLfloat = 0
}

class OpenGLViewController: UIViewController, BMKMapViewDelegate, BMKCloudSearchDelegate {
    
    /// OpenGL 点集
    var Point = [GLPoint]()
    /// 点的地理位置坐标集
    var coordinate = [CLLocationCoordinate2D]()
    /// 判断地图是否加载完毕
    var mapDidFinishLoad = false
    /// 百度地图视图
    var mapView: BMKMapView!
    /// 云检索结果
    var cloudSearch: BMKCloudSearch!
    
    // 界面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置标题
        self.title = arrayOfDemoName[17]
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        self.view = mapView
    }
    
    // MARK: - 地图加载相关协议
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        coordinate.append(CLLocationCoordinate2DMake(39.965, 116.604))
        coordinate.append(CLLocationCoordinate2DMake(39.865, 116.604))
        coordinate.append(CLLocationCoordinate2DMake(39.865, 116.704))
        coordinate.append(CLLocationCoordinate2DMake(39.965, 116.704))
        mapDidFinishLoad = true
    }
    
    // 地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
    func mapView(mapView: BMKMapView!, onDrawMapFrame status: BMKMapStatus!) {
        NSLog("地图渲染")
        if mapDidFinishLoad {
            GLRender(status)
        }
    }
    
    func GLRender(status: BMKMapStatus) {
        let centerPoint = BMKMapPointForCoordinate(status.targetGeoPt)
        let components = CGColorGetComponents(UIColor.redColor().CGColor)
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        Point = [GLPoint]()
        // 坐标系圆点为地图中心点，此处转换坐标为相对坐标
        for i in 0...3 {
            let point = BMKMapPointForCoordinate(coordinate[i])
            var glPoint = GLPoint()
            glPoint.x = GLfloat(point.x - centerPoint.x)
            glPoint.y = GLfloat(-point.y + centerPoint.y)
            Point.append(glPoint)
        }
        // 获取缩放比例，18级比例尺为1:1基准
        var fZoomUnites = powf(2, 18-status.fLevel)
        
        glPushMatrix()
        glRotatef(status.fOverlooking, 1, 0, 0)
        glRotatef(status.fRotation, 0, 0, 1)
        
        fZoomUnites = 1 / fZoomUnites
        // 缩放使随地图放大或缩小
        glScalef(fZoomUnites, fZoomUnites, fZoomUnites)
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        glColor4f(GLfloat(red), GLfloat(green), GLfloat(blue), GLfloat(alpha))
        glVertexPointer(2, GLenum(GL_FLOAT), 0, Point)
        // 绘制的点个数
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, 4)
        
        glDisable(GLenum(GL_BLEND))
        glDisableClientState(GLenum(GL_VERTEX_ARRAY))
        glPopMatrix()
        glColor4f(1, 1, 1, 1)
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
