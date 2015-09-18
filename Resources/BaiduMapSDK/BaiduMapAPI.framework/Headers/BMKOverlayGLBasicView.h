/*
*  BMKOverlayGLBasicView.h
*  BMapKit
*
*  Copyright 2011 Baidu Inc. All rights reserved.
*
*/

#import <UIKit/UIKit.h>
#import "BMKOverlayView.h"

/// 该类定义了一个用opengl绘制的OverlayView的基类，如果需要用gdi进行绘制请继承于BMKOverlayPathView类
@interface BMKOverlayGLBasicView : BMKOverlayView {

}

/// 填充颜色
@property (strong, nonatomic) UIColor *fillColor;
/// 画笔颜色
@property (strong, nonatomic) UIColor *strokeColor;
/// 画笔宽度，默认为0
@property  (nonatomic) CGFloat lineWidth;
/// path对象
@property CGPathRef path;
/// 是否为虚线样式
@property (nonatomic) BOOL lineDash;


@end
