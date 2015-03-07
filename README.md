# BaiduMapSDKDemo-Swift
使用百度地图 SDK创建的 DEMO，具体样式参考自官方 DEMO，使用 Swift 语言编写

##版本说明
1. 目前采用的是百度地图 iOS SDK 2.6.0
2. Xcode版本采用的是6.1.1
3. 项目采用 Swift 语言来进行编写
4. 项目采用 Storyboard 技术，试图以最简单的方式来展示百度地图 SDK 的使用

##功能说明

在使用前请定位到 `AppDelegate.swift`文件中，将 ak 更换为自己的百度地图 ak

应用界面如下图所示，主要提供了以下几种功能：

![主界面](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8A%E5%8D%8811.39.21.png)

###基本地图功能

能够显示基础地图，支持多点触摸、双击放大、多点单击缩小、旋转等手势操作，效果如图所示：

![基本地图功能](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8A%E5%8D%8811.39.29.png)

###多地图使用功能

![多地图使用功能](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8A%E5%8D%8811.39.36.png)

###图层展示功能

![图层展示功能](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8A%E5%8D%8811.39.43.png)

###地图操作功能

![地图操作功能](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8A%E5%8D%8811.39.49.png)

###UI 控制功能

![UI 控制功能](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8A%E5%8D%8811.39.54.png)

###定位功能

**开启定位功能**

![定位功能开启](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8B%E5%8D%8811.15.45.png)

**跟随态**

![跟随态](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8B%E5%8D%8811.16.26.png)

**罗盘态**

![罗盘态](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8B%E5%8D%8811.16.21.png)

###覆盖物功能

**内置覆盖物**

![内置覆盖物](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8B%E5%8D%8811.16.32.png)

**添加标注**

![添加标注](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8B%E5%8D%8811.16.34.png)

**图片图层**

![图片图层](https://github.com/SemperIdem/BaiduMapSDKDemo-Swift/blob/master/Screenshots/iOS%20Simulator%20Screen%20Shot%202015%E5%B9%B43%E6%9C%887%E6%97%A5%20%E4%B8%8B%E5%8D%8811.16.40.png)

##-----------以下未完成--------------

###自定义绘制

###POI 搜索功能

###地理编码功能

###路径规划功能

###公交线路查询

###离线地图功能

###热力图功能

###短串分享功能

###云检索功能

###调起百度导航功能

###OpenGL 绘制功能

##待解决问题

1.iOS SDK 2.6.0 版本，Xcode 会提示一个警告：

> ld: warning: instance method 'update3DView:overlook:' in category from /Users/semper_idem/编程项目/BaiduMapTest/libs/Release-iphonesimulator/libbaidumapapi.a(BMKMapView.o) overrides method from class in /Users/semper_idem/编程项目/BaiduMapTest/libs/Release-iphonesimulator/libbaidumapapi.a(BMKAnnotationView.o)


大体意思是百度的 SDK 中的BMKMapView.o这个文件重写了BMKAnnotationView.p这个文件的update3DView:overlook:这个方法。因此会导致后面这个文件的这个方法不可用。

这个是 SDK 2.6.0的一个 BUG，目前官方尚未给出解决方法，只是提出没有任何影响，因为那个方法并不会被调用。

2.iOS SDK 地图操作功能中的截图功能未实现，貌似Swift使用百度地图的 takeSnapshoot()功能会导致项目崩溃，待解决。

3.仅对 iPhone 5s 做了简要的适配，对 iPad 以及 iPhone 6 Plus 等设备的适配并未完善。
