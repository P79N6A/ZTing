//
//  ZTVoiceSearchCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTVoiceSearchCtrl.h"
#import <DOPDropDownMenu.h>
#import "CollectCell.h"
#import "AnnotationModel.h"
#import "ZTRouteViewCtrl.h"
#import "ZTDriveNavViewCtrl.h"
#import "ParkDetailCtrl.h"
#import "CYLTableViewPlaceHolder.h"
#import "NoDataView.h"
#import "NoNetWorkView.h"

@interface ZTVoiceSearchCtrl ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource,ParkDelegate,CYLTableViewPlaceHolderDelegate>
{
    NoNetWorkView *_notNetworkView;
}

@property (nonatomic, strong) DOPDropDownMenu *menu;

@property (nonatomic, strong) NSArray *priceArr;

@property (nonatomic, strong) NSArray *payMethodArr;

@property (nonatomic, strong) NSArray *sortsArr;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZTVoiceSearchCtrl

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
    
    [self _loadData];
    
}

-(void)_initView
{
    self.title = @"搜索";
    
    self.priceArr = @[@"价格便宜",@"价格适中",@"价格较贵"];
    self.payMethodArr = @[@"在线支付",@"当面付"];
    self.sortsArr = @[@"智能排序",@"距离排序",@"价格排序"];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    _menu = menu;
    
//     创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
//    [menu selectDefalutIndexPath];
    [menu selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:0]];
    
    [self.view addSubview:self.tableView];
    _tableView.sd_layout
    .topSpaceToView(_menu, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    
    _notNetworkView = [[NoNetWorkView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _notNetworkView.hidden = YES;
    UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_loadData)];
    _notNetworkView.userInteractionEnabled = YES;
    [_notNetworkView addGestureRecognizer:reloadTap];
    [self.view addSubview:_notNetworkView];
}

#pragma mark 附近停车场
-(void)_loadData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@park/getParkListByLngAndLat",KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:@(_origleCoor.longitude) forKey:@"lng"];
    [params setObject:@(_origleCoor.latitude) forKey:@"lat"];
    [params setObject:@(2000) forKey:@"radius"];
    [params setObject:@(30) forKey:@"pageSize"];
    [params setObject:@(0) forKey:@"start"];
    
    [self showHudInView:self.view hint:@""];
    
    [[ZTNetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        NSArray *arr = responseObject[@"data"];
        for (int i = 0; i < arr.count; i++) {
            AnnotationModel *model = [[AnnotationModel alloc] initWithDataDic:arr[i]];
            [self.dataArr addObject:model];
        }
        [self.tableView cyl_reloadData];
        _notNetworkView.hidden = YES;
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"网络不给力,请稍后重试!"];
        [self.view bringSubviewToFront:_notNetworkView];
        _notNetworkView.hidden = NO;
    }];
}

#pragma mark DOPDropDownMenuDelegate  and  dataSource

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.priceArr.count;
    }else if (column == 1){
        return self.payMethodArr.count;
    }else {
        return self.sortsArr.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.priceArr[indexPath.row];
    } else if (indexPath.column == 1){
        return self.payMethodArr[indexPath.row];
    } else {
        return self.sortsArr[indexPath.row];
    }
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 || indexPath.column == 1) {
        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.row];
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return [NSString stringWithFormat:@"ic_filter_category_%ld",indexPath.item];
    }
    return nil;
}

// new datasource

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld",indexPath.column,indexPath.row);
    }
}

#pragma mark tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    cell.model = _dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark tableview delagate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark parkDelegate

- (void)routePark:(NSString *)parkId
{
    [self loadPardDetail:parkId withType:0];
}

- (void)navPark:(NSString *)parkId
{
    [self loadPardDetail:parkId withType:1];
}

#warning 参数问题
- (void)loadPardDetail:(NSString *)parkId withType:(int)type {   // type: 类型，0：路线规划； 1：导航
    
    [self showHudInView:self.view hint:@""];
    
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [delegate startLocation];
    
    [delegate receiveLocationBlock:^(CLLocation *currentLocation, AMapLocationReGeocode *regeocode, BOOL isLocationSuccess) {
        if (isLocationSuccess) {
            NSString *parkUrl = [NSString stringWithFormat:@"%@park/detail", KDomain];
            NSMutableDictionary *params = @{}.mutableCopy;
//            [params setObject:KToken forKey:@"token"];
//            [params setObject:KMemberId forKey:@"memberId"];
            [params setObject:parkId forKey:@"parkId"];
            
            [[ZTNetworkClient sharedInstance] POST:parkUrl dict:params progressFloat:nil succeed:^(id responseObject) {
                [self hideHud];
                if([responseObject[@"success"] boolValue]){
                    AnnotationModel *annModel = [[AnnotationModel alloc] initWithDataDic:responseObject[@"data"][@"park"]];
                    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(annModel.parkLat.floatValue/1000000.6f, annModel.parkLng.floatValue/1000000.6f);
                    if(type == 0){
                        // 路线规划
                        ZTRouteViewCtrl *routeVC = [[ZTRouteViewCtrl alloc] init];
                        routeVC.startCoor = currentLocation.coordinate;
                        routeVC.coor = coor;
                        routeVC.model = annModel;
                        [self.navigationController pushViewController:routeVC animated:YES];
                    }else if(type == 1) {
                        // 导航
                        ZTDriveNavViewCtrl *driveNavVC = [[ZTDriveNavViewCtrl alloc] init];
                        driveNavVC.startCoor = currentLocation.coordinate;
                        driveNavVC.coor = coor;
                        [self.navigationController pushViewController:driveNavVC animated:YES];
                    }
                }
            } failure:^(NSError *error) {
                [self hideHud];
            }];
            
            [delegate stopLocation];

        }else
        {
            if (type == 0) {
                [self showHint:@"路线规划失败"];
            }
            if (type == 1) {
                [self showHint:@"开始导航失败"];
            }
            
        }
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%ld",indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnnotationModel *model = _dataArr[indexPath.row];
    
    ParkDetailCtrl *parkDeail = [[ParkDetailCtrl alloc] init];
    
    parkDeail.parkId = model.parkId;
    
    [self.navigationController pushViewController:parkDeail animated:YES];
    
}

#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    NoDataView *noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    return noDateView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
