//
//  ParkDetailCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ParkDetailCtrl.h"
#import "parkCommentModel.h"
#import "parkCommentCell.h"
#import "parkDetailModel.h"
#import "AnnotationModel.h"
#import "parkCommentCtrl.h"
#import "ZTRouteViewCtrl.h"
#import "LoginViewController.h"

@interface ParkDetailCtrl ()<UITableViewDelegate,UITableViewDataSource>
{
    int _page;
    int _length;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIButton *routeBtn;

@property (nonatomic,strong) UIButton *collectionBtn;

@property (nonatomic,strong) UIButton *commentBtn;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *parkNameLab;

@property (nonatomic,strong) UILabel *parkSpaceLab;

@property (nonatomic,strong) UILabel *locationLab;

@property (nonatomic,strong) UILabel *chargesLab;

@property (nonatomic,strong) UILabel *commentLab;

@end

static NSString * const parkCellId = @"parkCellId";

@implementation ParkDetailCtrl

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    
    [self _initBottomView];
    
    [self _loadParkDetail];
    
    [self _loadData];
    
    [self cheakIsCollect];
}

-(void)_initView
{
    self.title = @"停车场详情";
    
    // 设置返回按钮
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _page = 0;
    
    _length = 10;
    
    [self.view addSubview:self.tableView];
    _tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 48);

    [self.tableView registerClass:[parkCommentCell class] forCellReuseIdentifier:parkCellId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    
}
#pragma mark 初始化子视图
-(void)_initHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [headerView addSubview:imageView];
    
    UILabel *parkNameLab = [[UILabel alloc] init];
    parkNameLab.font = [UIFont systemFontOfSize:14];
    parkNameLab.textColor = [UIColor blackColor];
    parkNameLab.textAlignment = NSTextAlignmentLeft;
    self.parkNameLab = parkNameLab;
    [headerView addSubview:parkNameLab];
    
    UILabel *parkSpaceLab = [[UILabel alloc] init];
    parkSpaceLab.font = [UIFont systemFontOfSize:12];
    parkSpaceLab.textColor = [UIColor lightGrayColor];
    parkSpaceLab.textAlignment = NSTextAlignmentLeft;
    self.parkSpaceLab = parkSpaceLab;
    [headerView addSubview:parkSpaceLab];
    
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = [UIImage imageNamed:@"icon_address"];
    [headerView addSubview:locationImageView];
    
    UILabel *locationLab = [[UILabel alloc] init];
    locationLab.font = [UIFont systemFontOfSize:12];
    locationLab.textAlignment = NSTextAlignmentLeft;
    locationLab.textColor = [UIColor lightGrayColor];
    self.locationLab = locationLab;
    [headerView addSubview:locationLab];
    
    UILabel *chargesLab = [[UILabel alloc] init];
    chargesLab.font = [UIFont systemFontOfSize:12];
    chargesLab.textAlignment = NSTextAlignmentLeft;
    chargesLab.textColor = [UIColor lightGrayColor];
    self.chargesLab = chargesLab;
    [headerView addSubview:chargesLab];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = color(237, 237, 237, 1);
    [headerView addSubview:sepView];
    
    UILabel *commentLab = [[UILabel alloc] init];
    commentLab.font = [UIFont systemFontOfSize:12];
    commentLab.textAlignment = NSTextAlignmentLeft;
    commentLab.textColor = [UIColor lightGrayColor];
    self.commentLab = commentLab;
    [headerView addSubview:commentLab];
    
    UIView *sepView1 = [[UIView alloc] init];
    sepView1.backgroundColor = color(237, 237, 237, 1);
    [headerView addSubview:sepView1];

    imageView.sd_layout
    .topSpaceToView(headerView, 0)
    .leftSpaceToView(headerView, 0)
    .rightSpaceToView(headerView, 0)
    .heightIs(180);
    
    parkNameLab.sd_layout
    .topSpaceToView(imageView, 10)
    .leftSpaceToView(headerView, 10);
    
    parkSpaceLab.sd_layout
    .topSpaceToView(parkNameLab, 10)
    .leftSpaceToView(headerView, 10);
    
    locationImageView.sd_layout
    .topSpaceToView(parkSpaceLab, 8)
    .leftSpaceToView(headerView, 10)
    .widthIs(15)
    .heightIs(20);
    
    locationLab.sd_layout
    .leftSpaceToView(locationImageView, 8)
    .topSpaceToView(parkSpaceLab, 10);
    
    chargesLab.sd_layout
    .topSpaceToView(locationLab, 10)
    .leftSpaceToView(headerView, 10);
    
    sepView.sd_layout
    .topSpaceToView(chargesLab, 10)
    .leftSpaceToView(headerView, 0)
    .rightSpaceToView(headerView, 0)
    .heightIs(10);
    
    commentLab.sd_layout
    .topSpaceToView(sepView, 0)
    .leftSpaceToView(headerView, 10)
    .rightSpaceToView(headerView, 10)
    .bottomSpaceToView(headerView, 0.5);
    
    sepView1.sd_layout
    .topSpaceToView(commentLab, 0)
    .leftSpaceToView(headerView, 0)
    .rightSpaceToView(headerView, 0)
    .bottomSpaceToView(headerView, 0);
}

-(void)_initBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    bottomView.sd_layout
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(48);
    
    UIView *verSepView = [[UIView alloc] init];
    verSepView.backgroundColor = color(237, 237, 237, 1);
    [self.bottomView addSubview:verSepView];
    
    UIView *horSepView1 = [[UIView alloc] init];
    horSepView1.backgroundColor = color(237, 237, 237, 1);
    [self.bottomView addSubview:horSepView1];
    
    UIView *horSepView2 = [[UIView alloc] init];
    horSepView2.backgroundColor = color(237, 237, 237, 1);
    [self.bottomView addSubview:horSepView2];
    
    UIButton *routeBtn = [[UIButton alloc] init];
    [routeBtn addTarget:self action:@selector(routeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [routeBtn setImage:[UIImage imageNamed:@"icon_park_route"] forState:UIControlStateNormal];
    [routeBtn setTitle:@"路线" forState:UIControlStateNormal];
    [routeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [routeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:routeBtn];
    
    UIButton *collectionBtn = [[UIButton alloc] init];
    [collectionBtn addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [collectionBtn setImage:[UIImage imageNamed:@"icon_park_collect_nor"] forState:UIControlStateNormal];
    [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectionBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [collectionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.collectionBtn = collectionBtn;
    [self.bottomView addSubview:collectionBtn];
    
    UIButton *commentBtn = [[UIButton alloc] init];
    [commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn setImage:[UIImage imageNamed:@"icon_park_comment"] forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.bottomView addSubview:commentBtn];
    
    verSepView.sd_layout
    .leftSpaceToView(bottomView, 0)
    .rightSpaceToView(bottomView, 0)
    .topSpaceToView(bottomView, 0)
    .heightIs(0.5);
    
    routeBtn.sd_layout
    .topSpaceToView(bottomView, 0.5)
    .leftSpaceToView(bottomView, 0)
    .widthIs((KScreenWidth-1)/3)
    .heightIs(47.5);
    
    horSepView1.sd_layout
    .topSpaceToView(verSepView, 0)
    .bottomSpaceToView(bottomView, 0)
    .leftSpaceToView(routeBtn, 0)
    .widthIs(0.5);
    
    collectionBtn.sd_layout
    .topSpaceToView(bottomView, 0.5)
    .leftSpaceToView(routeBtn, 0)
    .widthIs((KScreenWidth-1)/3)
    .heightIs(47.5);
    
    horSepView2.sd_layout
    .topSpaceToView(verSepView, 0)
    .bottomSpaceToView(bottomView, 0)
    .leftSpaceToView(collectionBtn, 0)
    .widthIs(0.5);
    
    commentBtn.sd_layout
    .topSpaceToView(bottomView, 0.5)
    .leftSpaceToView(collectionBtn, 0)
    .widthIs((KScreenWidth-1)/3)
    .heightIs(47.5);
}

#pragma mark 路线规划
-(void)routeBtnAction:(UIButton *)sender
{
    [self showHudInView:self.view hint:@""];
    
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [delegate startLocation];
    
    [delegate receiveLocationBlock:^(CLLocation *currentLocation, AMapLocationReGeocode *regeocode, BOOL isLocationSuccess) {
        if (isLocationSuccess) {
            
            NSString *parkUrl = [NSString stringWithFormat:@"%@park/detail", KDomain];
            NSMutableDictionary *params = @{}.mutableCopy;
            [params setObject:KToken forKey:@"token"];
            [params setObject:KMemberId forKey:@"memberId"];
            [params setObject:_parkId forKey:@"parkId"];
            
            [[ZTNetworkClient sharedInstance] POST:parkUrl dict:params progressFloat:nil succeed:^(id responseObject) {
                
                [self hideHud];
                
                if([responseObject[@"success"] boolValue]){
                    AnnotationModel *annModel = [[AnnotationModel alloc] initWithDataDic:responseObject[@"data"][@"park"]];
                    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(annModel.parkLat.floatValue/1000000.6f, annModel.parkLng.floatValue/1000000.6f);
                        // 路线规划
                        ZTRouteViewCtrl *routeVC = [[ZTRouteViewCtrl alloc] init];
                        routeVC.startCoor = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
                        routeVC.coor = coor;
                        routeVC.model = annModel;
                        [self.navigationController pushViewController:routeVC animated:YES];
                    
                }

                [delegate stopLocation];
                
            } failure:^(NSError *error) {
                
            }];
            
//            // 路线规划
//            ZTRouteViewCtrl *routeVC = [[ZTRouteViewCtrl alloc] init];
//            routeVC.startCoor = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
//            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_model.parkLat.floatValue/1000000.6f, _model.parkLng.floatValue/1000000.6f);
//            routeVC.coor = coor;
//            routeVC.model = self.model;
//            [self.navigationController pushViewController:routeVC animated:YES];
            
//            [delegate stopLocation];
        }else
        {
            [self showHint:@"路线规划失败"];
        }
        
    }];
    
}

#pragma mark 收藏
-(void)collectionBtnAction:(UIButton *)sender
{
    if ([TheUserDefaults boolForKey:KLoginState]) {
        if (sender.selected) {
            [self showHudInView:self.view hint:@""];
            
            NSString *cancalCollectUrl = [NSString stringWithFormat:@"%@collect/cancel",KDomain];
            
            NSMutableDictionary *cancalCollectParams = @{}.mutableCopy;
            [cancalCollectParams setValue:self.parkId forKey:@"parkId"];
            [cancalCollectParams setValue:KMemberId forKey:@"memberId"];
            [cancalCollectParams setValue:KToken forKey:@"token"];
            
            [[ZTNetworkClient sharedInstance] POST:cancalCollectUrl dict:cancalCollectParams progressFloat:nil succeed:^(id responseObject) {
                //            NSLog(@"%@",responseObject);
                [self hideHud];
                if([responseObject[@"success"] boolValue]){
                    [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal] ;
                    [_collectionBtn setImage:[UIImage imageNamed:@"icon_park_collect_nor"] forState:UIControlStateNormal];
                    sender.selected = !sender.selected;
                }
                
            } failure:^(NSError *error) {
                
                [self hideHud];
            }];
            
        }else
        {
            [self showHudInView:self.view hint:@""];
            
            NSString *addCollectUrl = [NSString stringWithFormat:@"%@collect/add",KDomain];
            
            NSMutableDictionary *addCollectParams = @{}.mutableCopy;
            [addCollectParams setValue:self.parkId forKey:@"parkId"];
            [addCollectParams setValue:self.model.parkName forKey:@"parkName"];
            [addCollectParams setValue:KToken forKey:@"token"];
            [addCollectParams setValue:KMemberId forKey:@"memberId"];
            
            [[ZTNetworkClient sharedInstance] POST:addCollectUrl dict:addCollectParams progressFloat:nil succeed:^(id responseObject) {
//                NSLog(@"%@",responseObject);
                [self hideHud];
                if([responseObject[@"success"] boolValue]){
                    [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                    [_collectionBtn setImage:[UIImage imageNamed:@"icon_park_collect_h"] forState:UIControlStateNormal];
                    sender.selected = !sender.selected;
                }
                
            } failure:^(NSError *error) {
                
                [self hideHud];
            }];
        }

    }else
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
}

#pragma mark 评论
-(void)commentBtnAction:(UIButton *)sender
{
    if ([TheUserDefaults boolForKey:KLoginState]) {
        parkCommentCtrl *commentCtrl = [[parkCommentCtrl alloc] init];
        commentCtrl.parkId = self.parkId;
        [self.navigationController pushViewController:commentCtrl animated:YES];
    }else
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark 加载停车场详情
-(void)_loadParkDetail
{
    
     NSString *parkUrlStr = [NSString stringWithFormat:@"%@park/detail",KDomain];
    
     NSMutableDictionary *params = @{}.mutableCopy;
     [params setValue:KToken forKey:@"token"];
     [params setValue:self.parkId forKey:@"parkId"];
     
     [[ZTNetworkClient sharedInstance] GET:parkUrlStr dict:params progressFloat:nil succeed:^(id responseObject) {
//         NSLog(@"%@",responseObject);
         if([responseObject[@"success"] boolValue]){
             [_tableView reloadData];
             
             NSDictionary *dic = responseObject[@"data"][@"park"];
             AnnotationModel *model = [[AnnotationModel alloc] initWithDataDic:dic];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_imageView sd_setImageWithURL:[NSURL URLWithString:[model.parkPhotoid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                 
                 _parkNameLab.text = model.parkName;
                 CGSize parkNameSize = [_parkNameLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                 _parkNameLab.sd_layout
                 .widthIs(parkNameSize.width)
                 .heightIs(parkNameSize.height);
                 
                 NSString *parkNum = [NSString stringWithFormat:@"%@",model.parkIdle];
                 NSString *parkTotalNum = [NSString stringWithFormat:@"%@",model.parkCapacity];
                 NSMutableAttributedString *_parkingSpacesStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"空闲数：%@/%@",parkNum,parkTotalNum]];
                 [_parkingSpacesStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, parkNum.length)];
                 [_parkingSpacesStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4 + parkNum.length + 1, parkTotalNum.length)];
                 _parkSpaceLab.attributedText = _parkingSpacesStr;
                 
                 
                 CGSize parkSpaceSize = [_parkSpaceLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                 _parkSpaceLab.sd_layout
                 .widthIs(parkSpaceSize.width)
                 .heightIs(parkSpaceSize.height);
                 
                 _locationLab.text = model.parkAddress;
                 CGSize locationSize = [_locationLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                 _locationLab.sd_layout
                 .widthIs(locationSize.width)
                 .heightIs(locationSize.height);
                 
                 _chargesLab.text = [NSString stringWithFormat:@"收费标准 : %@",model.parkFeedesc];
                 CGSize chargesSize = [_chargesLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                 _chargesLab.sd_layout
                 .widthIs(chargesSize.width)
                 .heightIs(chargesSize.height);
                 
                 _commentLab.text = @"评论";
             });
         }
     } failure:^(NSError *error) {
     
     }];
     
}

#pragma mark 评论详情
-(void)_loadData
{
    NSString *commentDetailUrl = [NSString stringWithFormat:@"%@comment/list",KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:KToken forKey:@"token"];
    [params setValue:self.parkId forKey:@"parkId"];
    [params setObject:[NSNumber numberWithInt:_page*_length] forKey:@"start"];
    [params setObject:[NSNumber numberWithInt:_length] forKey:@"length"];
//    [params setValue:KMemberId forKey:@"memberId"];
    
    [self showHudInView:self.view hint:@""];
    
    [[ZTNetworkClient sharedInstance] GET:commentDetailUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if([responseObject[@"success"] boolValue]){
            
            if(_page == 0){
                [_dataArr removeAllObjects];
            }
            
            NSArray *hisData = responseObject[@"data"][@"data"];
            if(hisData.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            [hisData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                parkCommentModel *commentModel = [[parkCommentModel alloc] initWithDataDic:obj];
                [self.dataArr addObject:commentModel];
            }];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark 检查是否被收藏

-(void)cheakIsCollect
{
    NSString *collectUrl = [NSString stringWithFormat:@"%@park/isCollect",KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:self.parkId forKey:@"parkId"];
    [params setValue:KMemberId forKey:@"memberId"];
    [params setValue:KToken forKey:@"token"];
    
    [[ZTNetworkClient sharedInstance] POST:collectUrl dict:params progressFloat:nil succeed:^(id responseObject) {

        if([responseObject[@"success"] boolValue]){
            
            if ([responseObject[@"message"] isEqualToString:@"未被收藏"]) {
                [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [_collectionBtn setImage:[UIImage imageNamed:@"icon_park_collect_nor"] forState:UIControlStateNormal];
                
                _collectionBtn.selected = NO;
            }
            
            if ([responseObject[@"message"] isEqualToString:@"该停车场已收藏"]) {
                [_collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [_collectionBtn setImage:[UIImage imageNamed:@"icon_park_collect_h"] forState:UIControlStateNormal];
                
                _collectionBtn.selected = YES;
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    parkCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:parkCellId];
    
    if (cell == nil) {
        cell = [[parkCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:parkCellId];
    }
    
    cell.model = _dataArr[indexPath.row];
    return cell;
}

#pragma mark tableview delagate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_headerView == nil) {
        [self _initHeaderView];
    }

    return _headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 330;
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
