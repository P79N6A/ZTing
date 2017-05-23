//
//  ZTRouteViewCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/14.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTRouteViewCtrl.h"
#import "SpeechSynthesizer.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZTDriveNavViewCtrl.h"
#import "ZTparkMessageView.h"

@interface ZTRouteViewCtrl ()<MAMapViewDelegate,AMapSearchDelegate>
{
    BOOL _hasCurrLoc;
    
    UIButton *locationBtn;
    UIButton *TrafficStatusBtn;
    
    //地图放大缩小按钮
    UIButton *_enlargeBtn;
    UIButton *_shrinkDownBtn;
}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAPointAnnotation *endAnnotation;
@property (nonatomic, strong) MAPointAnnotation *beginAnnotation;
@property (nonatomic, strong) NSArray *pathPolylines;
@property (nonatomic, retain) AMapSearchAPI *SearchManager; //POI检索引擎

@property (nonatomic, strong) ZTparkMessageView *parkMessageView;

@end

@implementation ZTRouteViewCtrl

- (NSArray *)pathPolylines
{
    if (!_pathPolylines) {
        _pathPolylines = [NSArray array];
    }
    return _pathPolylines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view insertSubview:self.mapView atIndex:0];
    
    [self _initSearchManager];
        
    self.title = @"路线规划";
    
    [self _initView];

}

#pragma mark 创建视图
-(void)_initView
{
    locationBtn = [[UIButton alloc] init];
    [locationBtn addTarget:self action:@selector(showSelfLocationAction:) forControlEvents:UIControlEventTouchUpInside];
    [locationBtn setImage:[UIImage imageNamed:@"icon_map_locate_nor"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"icon_map_locate_h"] forState:UIControlStateHighlighted];
    [self.view addSubview:locationBtn];
    
    locationBtn.sd_layout
    .topSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(40);
    
    TrafficStatusBtn = [[UIButton alloc] init];
    [TrafficStatusBtn addTarget:self action:@selector(showTrafficStatusAction:) forControlEvents:UIControlEventTouchUpInside];
    TrafficStatusBtn.selected = YES;
    [TrafficStatusBtn setImage:[UIImage imageNamed:@"icon_map_traffic_nor"] forState:UIControlStateNormal];
    [TrafficStatusBtn setImage:[UIImage imageNamed:@"icon_map_traffic_h"] forState:UIControlStateSelected];
    [self.view addSubview:TrafficStatusBtn];
    
    TrafficStatusBtn.sd_layout
    .topSpaceToView(locationBtn, 15)
    .rightSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(40);
    
    UIButton *shrinkDownBtn = [[UIButton alloc] init];
    [shrinkDownBtn addTarget:self action:@selector(zoomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [shrinkDownBtn setImage:[UIImage imageNamed:@"icon_map_zoom_out_h"] forState:UIControlStateHighlighted];
    [shrinkDownBtn setImage:[UIImage imageNamed:@"icon_map_zoom_out_nor"] forState:UIControlStateNormal];
    shrinkDownBtn.tag = 100;
    [self.view addSubview:shrinkDownBtn];
    _shrinkDownBtn = shrinkDownBtn;
    
    shrinkDownBtn.sd_layout
    .bottomSpaceToView(self.view, 155)
    .rightSpaceToView(self.view, 15)
    .widthIs(40)
    .heightIs(40);
    
    UIButton *enlargeBtn = [[UIButton alloc] init];
    [enlargeBtn addTarget:self action:@selector(zoomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [enlargeBtn setImage:[UIImage imageNamed:@"icon_map_zoom_in_h"] forState:UIControlStateHighlighted];
    [enlargeBtn setImage:[UIImage imageNamed:@"icon_map_zoom_in_nor"] forState:UIControlStateNormal];
    enlargeBtn.tag = 110;
    [self.view addSubview:enlargeBtn];
    _enlargeBtn = enlargeBtn;
    
    enlargeBtn.sd_layout
    .bottomSpaceToView(shrinkDownBtn, 15)
    .rightSpaceToView(self.view, 15)
    .widthIs(40)
    .heightIs(40);
    
}

#pragma mark 定位
-(void)showSelfLocationAction:(UIButton *)sender
{
    
    CLLocationCoordinate2D coordinate = _mapView.userLocation.location.coordinate;
    // 设置跨度 = 当前地图的跨度
    MACoordinateSpan spn = _mapView.region.span;
    [_mapView setRegion:MACoordinateRegionMake(coordinate, spn) animated:YES];
    
}

#pragma mark 显示交通状况
-(void)showTrafficStatusAction:(UIButton *)sender
{
    if (sender.selected) {
        [self.mapView setShowTraffic:NO];
        sender.selected = !sender.selected;
    } else {
        [self.mapView setShowTraffic:YES];
        sender.selected = !sender.selected;
    }
}

#pragma mark 地图放大缩小
-(void)zoomBtnAction:(UIButton *)sender
{
    CLLocationCoordinate2D coordinate = _mapView.region.center;
    MACoordinateSpan spn;
    if (sender.tag == 110) {
        _shrinkDownBtn.hidden = NO;
        spn = MACoordinateSpanMake(_mapView.region.span.latitudeDelta * 0.5, _mapView.region.span.longitudeDelta * 0.5);
    }else{
        spn = MACoordinateSpanMake(_mapView.region.span.latitudeDelta * 2, _mapView.region.span.longitudeDelta * 2);
        
        if (spn.latitudeDelta >= 114 && spn.longitudeDelta >= 102) {
            _shrinkDownBtn.hidden = YES;
            return;
        }
    }
    
    [_mapView setRegion:MACoordinateRegionMake(coordinate, spn) animated:YES];
}

-(ZTparkMessageView *)parkMessageView
{
    if (!_parkMessageView) {
        _parkMessageView = [[ZTparkMessageView alloc] initWithFrame:CGRectMake(10, KScreenHeight-204, KScreenWidth - 20, 130)];
        _parkMessageView.backgroundColor = [UIColor whiteColor];
    }
    
    return _parkMessageView;
}

-(void)_initSearchManager
{
    if (_SearchManager == nil) {
        _SearchManager = [[AMapSearchAPI alloc] init];
        _SearchManager.delegate = self;

    }
    AMapDrivingRouteSearchRequest *carRouteRequest = [[AMapDrivingRouteSearchRequest alloc] init];
    carRouteRequest.requireExtension = YES;
    carRouteRequest.strategy = 5;
    carRouteRequest.origin = [AMapGeoPoint locationWithLatitude:_startCoor.latitude
                                                      longitude:_startCoor.longitude];
    carRouteRequest.destination = [AMapGeoPoint locationWithLatitude:_coor.latitude
                                                           longitude:_coor.longitude];
    
    
    //发起请求,开始POI的驾车出行路线查询检索
    [_SearchManager AMapDrivingRouteSearch:carRouteRequest];
}

#pragma mark 地图初始化
- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        _mapView.showsScale = NO;
        _mapView.showTraffic = YES;
        _mapView.showsCompass = NO;
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO]; //地图跟着位置移动
        _mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        //自定义定位经度圈样式
        _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
//        后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        
    }
    return _mapView;
}

#pragma mark - <AMapSearchDelegate>
//检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    [self showHint:@"路线规划失败"];
}

//收集检索到的路线出行规划目标
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{

    if(response.route == nil)
    {
        return;
    }
    
    [self.view addSubview:self.parkMessageView];
    _parkMessageView.model = _model;
    
    if (response.route.paths[0].distance < 1000) {
        _parkMessageView.distanceLab.text = [NSString stringWithFormat:@"%ldm",response.route.paths[0].distance];
    }else
    {
        _parkMessageView.distanceLab.text = [NSString stringWithFormat:@"%.2fkm",response.route.paths[0].distance/1000.0];
    }
    
    if (response.count > 0)
    {
        //移除地图原本的遮盖
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
        
        // 只显⽰示第⼀条 规划的路径
        _pathPolylines = [self polylinesForPath:response.route.paths[0]];

        //添加新的遮盖，然后会触发代理方法进行绘制
        [_mapView addOverlays:_pathPolylines];
    }
    
    [_mapView showOverlays:_pathPolylines edgePadding:UIEdgeInsetsMake(50, 30, 150, 30) animated:YES];
    
    [self initAnnotations];

}

//路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{

    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        
//        MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
    
    
}

//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}

#pragma mark 开始导航
-(void)beginNavAction
{
    ZTDriveNavViewCtrl *driveCtrl = [[ZTDriveNavViewCtrl alloc] init];
    
    driveCtrl.startCoor = _startCoor;
    
    driveCtrl.coor = _coor;
    
    [self.navigationController pushViewController:driveCtrl animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view insertSubview:self.mapView atIndex:0];
}

#pragma mark 起点终点标注
- (void)initAnnotations {
    _endAnnotation = [[MAPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coordinate = _coor;
    [_endAnnotation setCoordinate:coordinate];
    _endAnnotation.title = @"终点";
    [self.mapView addAnnotation:_endAnnotation];
    
    _beginAnnotation = [[MAPointAnnotation alloc] init];
    
    CLLocationCoordinate2D coordinatebegin = _startCoor;
    [_beginAnnotation setCoordinate:coordinatebegin];
    _beginAnnotation.title = @"起点";
    [self.mapView addAnnotation:_beginAnnotation];
}

#pragma mark - MapView Delegate

/**
 *  添加路径的线条
 *
 *  @param naviRoute 导航路径信息
 */


#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!_hasCurrLoc)
    {
        _hasCurrLoc = YES;
        [self.mapView setCenterCoordinate:userLocation.coordinate];
        [self.mapView setZoomLevel:12 animated:NO];
    }
}

//-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    [self.mapView removeFromSuperview];
//    [self.view addSubview:self.mapView];
//    
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage scaleToSize:[UIImage imageNamed:@"location_map_gps_locked"] size:CGSizeMake(50, 50)];
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MAAnnotationView *pointAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.canShowCallout = NO;
        pointAnnotationView.draggable      = NO;
        
        if ([annotation.title isEqualToString:@"起点"]) {
            pointAnnotationView.image = [UIImage scaleToSize:[UIImage imageNamed:@"amap_start"] size:CGSizeMake(40, 40)];
        }
        
        if ([annotation.title isEqualToString:@"终点"]) {
            pointAnnotationView.image = [UIImage scaleToSize:[UIImage imageNamed:@"amap_end"] size:CGSizeMake(40, 40)];
        }
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        pointAnnotationView.centerOffset = CGPointMake(0, -20);
        
        return pointAnnotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = color(83, 126, 220, 1);
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    
    return nil;
}

@end
