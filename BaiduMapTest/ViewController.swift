//
//  ViewController.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-2-14.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate {
    
    var mapView: BMKMapView!
    var locService: BMKLocationService!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView = BMKMapView(frame: self.view.frame)
        self.view = mapView
        
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        BMKLocationService.setLocationDistanceFilter(10)
        
        locService = BMKLocationService()
        locService.startUserLocationService()
        mapView.showsUserLocation = false
        mapView.userTrackingMode = BMKUserTrackingModeNone
        mapView.showsUserLocation = true
    }
    
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        locService.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        locService.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

