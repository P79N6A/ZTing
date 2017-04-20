//
//  ZTMapViewCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/3/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTMapViewCtrl.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ZTCustomAntionView.h"
#import "SpeechSynthesizer.h"
#import "ZTDriveNavViewCtrl.h"
#import "UIBarButtonItem+JExtension.h"
#import "AnnotationModel.h"
#import "ZTAnnotation.h"
#import "ZTmapPopView.h"
#import "ZTRouteViewCtrl.h"
#import "SearchViewCtrl.h"

@interface ZTMapViewCtrl ()<MAMapViewDelegate>
{
    MAUserLocation *_userLocation;
    
    UIButton *locationBtn;
    UIButton *TrafficStatusBtn;
    
    //地图放大缩小按钮
    UIButton *_enlargeBtn;
    UIButton *_shrinkDownBtn;
    
    BOOL _hasCurrLoc; //只有首次定位成功跳到该经纬度位置bool
    
}

@property (nonatomic,strong) MAMapView *mapView;

@property (nonatomic,strong) NSMutableArray *locationArray;

@property (nonatomic,strong) ZTmapPopView *mapPopView;

@property (nonatomic,assign) NSInteger currentSelectedIndex;

@end

@implementation ZTMapViewCtrl

- (NSMutableArray *)locationArray{
    
    if (_locationArray == nil) {
        
        _locationArray = [NSMutableArray new];
        
    }
    return _locationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initNav];
    
    [self initMapView];
    
    [self _initView];
    
}

#pragma mark 数据请求
-(void)_loadData
{
    //获取接入停车场列表
    NSString *urlStr = [NSString stringWithFormat:@"%@park/getParkListByLngAndLat",KDomain];
    
    float lat = _mapView.userLocation.coordinate.latitude;
    float lng = _mapView.userLocation.coordinate.longitude;
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:@(lng) forKey:@"lng"];
    [params setObject:@(lat) forKey:@"lat"];
    [params setObject:@(30000) forKey:@"radius"];
    [params setObject:@(20) forKey:@"pageSize"];
    [params setObject:@(0) forKey:@"start"];
    
    [[ZTNetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if ([[responseObject[@"statusCode"] stringValue] isEqualToString:@"201"]) {
            [self showHint:responseObject[@"message"]];
            return;
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addAnnotation:responseObject];
            });
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"操作失败"];
    }];
}

#pragma mark 添加自定义大头针
-(void)addAnnotation:(id)data
{
    
    if (self.locationArray.count != 0) {
        [self.locationArray removeAllObjects];
    }
    NSMutableArray *dataArr = @[].mutableCopy;
    
    dataArr = data[@"data"];
    
    for (int i = 0; i < dataArr.count; i++) {
        
        AnnotationModel *model = [[AnnotationModel alloc] initWithDataDic:dataArr[i]];
        ZTAnnotation *annotation = [[ZTAnnotation alloc] init];
        annotation.model = model;
        
        [self.locationArray addObject:annotation];
        
    }
    
    [_mapView addAnnotations:self.locationArray];
    
}

#pragma mark 导航栏设置
-(void)_initNav
{
    self.title = @"找车位";
    
    UIBarButtonItem *rightBtn = [UIBarButtonItem itemWithImage:@"icon_title_search_nor" highImage:@"icon_title_search_h" target:self action:@selector(rightBarBtnAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)rightBarBtnAction:(UIButton *)sender
{
    NSLog(@"search");
    SearchViewCtrl *searchViewCtrl = [[SearchViewCtrl alloc] init];
    [self.navigationController pushViewController:searchViewCtrl animated:YES];
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
    .topSpaceToView(self.view, 79)
    .rightSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(40);
    
    TrafficStatusBtn = [[UIButton alloc] init];
    [TrafficStatusBtn addTarget:self action:@selector(showTrafficStatusAction:) forControlEvents:UIControlEventTouchUpInside];
    TrafficStatusBtn.selected = YES;
    [TrafficStatusBtn setImage:[UIImage imageNamed:@"icon_map_traffic_nor"] forState:UIControlStateNormal];
    [TrafficStatusBtn setImage:[UIImage imageNamed:@"icon_map_traffic_h"] forState:UIControlStateHighlighted];
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
    .bottomSpaceToView(self.view, 30)
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
        [self.mapView setShowTraffic:YES];
        sender.selected = !sender.selected;
    } else {
        [self.mapView setShowTraffic:NO];
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    // 显示定位大头针，默认是显示的
    self.mapView.showsUserLocation = YES;

}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        self.mapView = mapView;
        [self.view addSubview:self.mapView];

        [mapView setDelegate:self];
        
        //缩放等级
        [mapView setZoomLevel:18 animated:YES];
        
        //设置定位精度
        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //    设置定位距离
        mapView.distanceFilter = 5.0f;
        //普通样式
        _mapView.mapType = MAMapTypeStandard;
        
        // 显示指南针
        mapView.showsCompass = NO;
        
        // 显示标尺(单位：mi 英尺)
        mapView.showsScale = YES;

    }
}

#pragma mark - MapView Delegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!_hasCurrLoc)
    {
        _userLocation = userLocation;
        _hasCurrLoc = YES;
        
        [self.mapView setCenterCoordinate:userLocation.coordinate];
        [self.mapView setZoomLevel:12 animated:NO];
     
        [_mapView removeAnnotations:_locationArray];
        
        [self _loadData];
        
    }
}

-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.mapView removeFromSuperview];
    [self.view addSubview:self.mapView];
    [self.view insertSubview:self.mapView atIndex:0];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        
        ZTCustomAntionView *annotationView = (ZTCustomAntionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[ZTCustomAntionView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        
        
        annotationView.annotation = annotation;
        
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
    
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    NSLog(@"latitude = %f   longitude = %f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
    NSString *latiStr = [NSString stringWithFormat:@"%f",view.annotation.coordinate.latitude];
    latiStr = [latiStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    int latNum = [latiStr intValue];
    
    NSString *lngStr = [NSString stringWithFormat:@"%f",view.annotation.coordinate.longitude];
    lngStr = [lngStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    int lngNum = [lngStr intValue];
    
    for (int i = 0; i < _locationArray.count; i++) {
        if (latNum == [((ZTAnnotation *)_locationArray[i]).model.parkLat intValue] && lngNum == [((ZTAnnotation *)_locationArray[i]).model.parkLng intValue]) {
            
            [self presentDetailView:_locationArray[i]];
            _currentSelectedIndex = i;
        }
    }
}

-(void)presentDetailView:(ZTAnnotation *)anntation
{
    AnnotationModel *model = anntation.model;
//    NSLog(@"%@",model);
    [UIView animateWithDuration:0.3 animations:^{
        _shrinkDownBtn.sd_resetNewLayout
        .bottomSpaceToView(self.view, 220)
        .rightSpaceToView(self.view, 15)
        .widthIs(40)
        .heightIs(40);
        
        _enlargeBtn.sd_resetNewLayout
        .bottomSpaceToView(_shrinkDownBtn, 15)
        .rightSpaceToView(self.view, 15)
        .widthIs(40)
        .heightIs(40);
    }];
    
    if (_mapPopView) {
        [_mapPopView disMissView];
        _mapPopView = [[ZTmapPopView alloc] init];
        [_mapPopView showInView:self.view];
        _mapPopView.model = model;
    }else
    {
        _mapPopView = [[ZTmapPopView alloc] init];
        [_mapPopView showInView:self.view];
        _mapPopView.model = model;
    }
    
}

#pragma mark - Actions
#pragma  mark 开始规划路径
- (void)routePlanAction:(AMapNaviPoint *)endPoint
{
    ZTRouteViewCtrl *routeViewCtrl = [[ZTRouteViewCtrl alloc] init];

    routeViewCtrl.startCoor = _userLocation.coordinate;
    
    routeViewCtrl.coor = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude);
    
    ZTAnnotation *annotation = _locationArray[_currentSelectedIndex];
    routeViewCtrl.model = annotation.model;
    
    [self.navigationController pushViewController:routeViewCtrl animated:YES];
    
}

#pragma mark 开始导航
-(void)beginNavAction:(AMapNaviPoint *)endPoint
{
    ZTDriveNavViewCtrl *driveCtrl = [[ZTDriveNavViewCtrl alloc] init];
    
    driveCtrl.startCoor = _userLocation.coordinate;
    
    driveCtrl.coor = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude);

    [self.navigationController pushViewController:driveCtrl animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
