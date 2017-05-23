//
//  CollectViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CollectViewController.h"
#import <MJRefresh.h>
#import "CollectModel.h"
#import "CollectCell.h"
#import <CYLTableViewPlaceHolder.h>
#import "NoDataView.h"
#import "AnnotationModel.h"
#import "ZTDriveNavViewCtrl.h"
#import "ZTRouteViewCtrl.h"
#import "ParkDetailCtrl.h"

#import "AppDelegate+Location.h"
#import "NoNetWorkView.h"

//#import <CoreLocation/CoreLocation.h>

@interface CollectViewController ()<CYLTableViewPlaceHolderDelegate, ParkDelegate, CLLocationManagerDelegate>
{
    NSMutableArray *_collectData;
    
    int _page;
    int _length;
    
    CLLocationCoordinate2D _currentLocation;
    
    NoNetWorkView *_notNetworkView;
}
//@property(strong,nonatomic)CLLocationManager *locationManager;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    
//    [self _initLocation];
    
    [self _initView];
    
    [self _loadData];
    
    [[AppDelegate shareAppDelegate] startLocation];
    [[AppDelegate shareAppDelegate] receiveLocationBlock:^(CLLocation *currentLocation, AMapLocationReGeocode *regeocode, BOOL isLocationSuccess) {
        if(isLocationSuccess){
            _currentLocation = currentLocation.coordinate;
            [[AppDelegate shareAppDelegate] stopLocation];
        }
    }];
}

/*
- (void)_initLocation {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    [_locationManager startUpdatingLocation];//开启定位
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
     CLLocation *currLocation=[locations lastObject];
    _currentLocation = currLocation.coordinate;
    [_locationManager stopUpdatingLocation];
}
 */

- (void)_initView {
    _collectData = @[].mutableCopy;
    _page = 0;
    _length = 10;
    
    self.view.backgroundColor = color(237, 237, 237, 1);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"CollectCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];

//    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];

    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self _loadData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self _loadData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    //无网络
    _notNetworkView = [[NoNetWorkView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _notNetworkView.hidden = YES;
    UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_loadData)];
    _notNetworkView.userInteractionEnabled = YES;
    [_notNetworkView addGestureRecognizer:reloadTap];
    [self.view addSubview:_notNetworkView];
}

- (void)_loadData {
    NSString *collectUrl = [NSString stringWithFormat:@"%@collect/list", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:[NSNumber numberWithInt:_page*_length] forKey:@"start"];
    [params setObject:[NSNumber numberWithInt:_length] forKey:@"length"];
    
    [self showHudInView:self.view hint:@""];
    
    [[ZTNetworkClient sharedInstance] POST:collectUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"success"] boolValue]){
            if(_page == 0){
                [_collectData removeAllObjects];
            }
            NSArray *colData = responseObject[@"data"][@"data"];
            if(colData.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [colData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CollectModel *collectModel = [[CollectModel alloc] initWithDataDic:obj];
                [_collectData addObject:collectModel];
            }];
            [self.tableView cyl_reloadData];
        }
        _notNetworkView.hidden = YES;
    } failure:^(NSError *error) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showHint:@"网络不给力,请稍后重试!"];
        [self.view bringSubviewToFront:_notNetworkView];
        _notNetworkView.hidden = NO;
    }];
}

#pragma mark UITableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _collectData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell"];
    cell.collectModel = _collectData[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ParkDetailCtrl *parkDeail = [[ParkDetailCtrl alloc] init];
    CollectModel *colModel = _collectData[indexPath.row];
    parkDeail.parkId = colModel.collectParkid;
    [self.navigationController pushViewController:parkDeail animated:YES];
}

#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    NoDataView *noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    return noDateView;
}

#pragma mark ParkDelegate
- (void)routePark:(NSString *)parkId {
    [self loadPardDetail:parkId withType:0];
}

- (void)navPark:(NSString *)parkId {
    [self loadPardDetail:parkId withType:1];
}

- (void)loadPardDetail:(NSString *)parkId withType:(int)type {   // type: 类型，0：路线规划； 1：导航
    NSString *parkUrl = [NSString stringWithFormat:@"%@park/detail", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:parkId forKey:@"parkId"];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:parkUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            AnnotationModel *annModel = [[AnnotationModel alloc] initWithDataDic:responseObject[@"data"][@"park"]];
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(annModel.parkLat.floatValue/1000000.6f, annModel.parkLng.floatValue/1000000.6f);
            if(type == 0){
                // 路线规划
                ZTRouteViewCtrl *routeVC = [[ZTRouteViewCtrl alloc] init];
                routeVC.startCoor = _currentLocation;
                routeVC.coor = coor;
                routeVC.model = annModel;
                [self.navigationController pushViewController:routeVC animated:YES];
            }else if(type == 1) {
                // 导航
                ZTDriveNavViewCtrl *driveNavVC = [[ZTDriveNavViewCtrl alloc] init];
                driveNavVC.startCoor = _currentLocation;
                driveNavVC.coor = coor;
                [self.navigationController pushViewController:driveNavVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
