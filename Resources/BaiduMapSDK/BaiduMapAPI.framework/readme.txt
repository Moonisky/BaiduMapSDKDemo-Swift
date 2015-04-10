基础地图：包括基本矢量地图、卫星图、实时路况图和各种地图覆盖物，此外还包括各种与地图相关的操作和事件监听；
检索功能：包括POI检索，公交信息查询，路线规划，地理编码/反地理编码，在线建议查询，短串分享等；
LBS云检索：包括LBS云检索（周边、区域、城市内、详情）；
定位功能：获取当前位置信息；
计算工具：包括测距（两点之间距离）、坐标转换、调起百度地图导航等功能；
百度地图iOS SDK自v2.3.0起，采用可定制的形式为您提供开发包，当前开发包包含如下功能：

--------------------------------------------------------------------------------------

基础地图：包括基本矢量地图、卫星图、实时路况图和各种地图覆盖物，此外还包括各种与地图相关的操作和事件监听；
检索功能：包括POI检索，Place详情检索，公交信息查询，路线规划，地理编码/反地理编码，在线建议查询，短串分享等；
LBS云检索：包括LBS云检索（周边、区域、城市内、详情）；
定位功能：获取当前位置信息；
计算工具：包括测距（两点之间距离）、坐标转换、调起百度地图导航等功能；


--------------------------------------------------------------------------------------

当前版本为v2.7.0，较上一个版本（v2.6.0）的更新内容如下：


自当前版本起，百度地图iOS SDK推出 .framework形式的开发包。此种类型的开发包配置简单、使用方便，欢迎开发者选用！
【 新 增 】
基础地图
    1. 增加地图缩放等级到20级（10米）；
    2. 新增地理坐标与OpenGL坐标转换接口：
        BMKMapView新增接口：
        -(CGPoint)glPointForMapPoint:(BMKMapPoint)mapPoint;//将BMKMapPoint转换为OpenGL ES可以直接使用的坐标
        -(CGPoint *)glPointsForMapPoints:(BMKMapPoint *)mapPoints count:(NSUInteger)count;// 批量将BMKMapPoint转换为OpenGL ES可以直接使用的坐标
    3. 开放区域截图能力：
        BMKMapView新增接口：
        -(UIImage*) takeSnapshot:(CGRect)rect;// 获得地图区域区域截图
检索功能
    1. 开放驾车线路规划，返回多条线路的能力：
        BMKDrivingRouteResult中，routes数组有多条数据，支持检索结果为多条线路
    2. 驾车线路规划结果中，新增路况信息字段：
        BMKDrivingRoutePlanOption新增属性：
        ///驾车检索获取路线每一个step的路况，默认使用BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE
        @property (nonatomic) BMKDrivingRequestTrafficType drivingRequestTrafficType;
        BMKDrivingStep新增属性：
        ///路段是否有路况信息
        @property (nonatomic) BOOL hasTrafficsInfo;
        ///路段的路况信息，成员为NSNumber。0：无数据；1：畅通；2：缓慢；3：拥堵
        @property (nonatomic, strong) NSArray* traffics;
    3.废弃接口：
        BMKDrivingRouteLine中，废弃属性：isSupportTraffic
计算工具
    1. 新增点与圆、多边形位置关系判断方法：
        工具类BMKGeometry.h中新增接口：
        //判断点是否在圆内
        UIKIT_EXTERN BOOL BMKCircleContainsPoint(BMKMapPoint point, BMKMapPoint center, double radius);
        UIKIT_EXTERN BOOL BMKCircleContainsCoordinate(CLLocationCoordinate2D point, CLLocationCoordinate2D center, double radius);
        //判断点是否在多边形内
        UIKIT_EXTERN BOOL BMKPolygonContainsPoint(BMKMapPoint point, BMKMapPoint *polygon, NSUInteger count);
        UIKIT_EXTERN BOOL BMKPolygonContainsCoordinate(CLLocationCoordinate2D point, CLLocationCoordinate2D *polygon, NSUInteger count);
    2. 新增获取折线外某点到这线上距离最近的点：
        工具类BMKGeometry.h中新增接口：
        UIKIT_EXTERN BMKMapPoint BMKGetNearestMapPointFromPolyline(BMKMapPoint point, BMKMapPoint* polyline, NSUInteger count);
    3、新增计算地理矩形区域的面积
        工具类BMKGeometry.h中新增接口：
        UIKIT_EXTERN double BMKAreaBetweenCoordinates(CLLocationCoordinate2D leftTop, CLLocationCoordinate2D rightBottom);
【 优 化 】
    1. 减少首次启动SDK时的数据流量；
    2. 检索协议优化升级；
    3. 优化Annotation拖拽方法（长按后开始拖拽）；
【 修 复 】
    1. 修复在线地图和离线地图穿插使用时，地图内存不释放的bug；
    2. 修复云检索过程中偶现崩溃的bug；
    3. 修复地图在autolayout布局下无效的bug；
    4. 修复BMKAnnotationView重叠的bug；


