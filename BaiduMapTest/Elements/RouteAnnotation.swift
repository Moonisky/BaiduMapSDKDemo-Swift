//
//  RouteAnnotation.swift
//  BaiduMapTest
//
//  Created by Semper Idem on 15-3-9.
//  Copyright (c) 2015年 益行人-星夜暮晨. All rights reserved.
//

import UIKit

class RouteAnnotation: BMKPointAnnotation {
    
    var type: Int!
    var degree: Int!
    
    override init() {
        super.init()
    }
    
    init(type: Int, degree: Int) {
        self.type = type
        self.degree = degree
    }
    
}
