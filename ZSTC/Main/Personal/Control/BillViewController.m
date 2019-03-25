//
//  BillViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BillViewController.h"
#import "BillCell.h"
#import <MJRefresh.h>
#import "BillModel.h"
#import <MJRefresh.h>
#import "CYLTableViewPlaceHolder.h"
#import "NoDataView.h"
#import "BillDetailTableViewController.h"
#import "NoNetWorkView.h"

@interface BillViewController ()<CYLTableViewPlaceHolderDelegate>
{
    NSMutableArray *_billData;
    
    int _page;
    
    int _length;
    
    NoNetWorkView *_notNetworkView;
}
@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _loadData];
}

- (void)_initView {
    self.title = @"账单";
    _page = 0;
    _length = 10;
    
    _billData = @[].mutableCopy;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // 设置返回按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(_leftBarBtnItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BillCell" bundle:nil] forCellReuseIdentifier:@"BillCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    
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
    
    _notNetworkView = [[NoNetWorkView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _notNetworkView.hidden = YES;
    UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_loadData)];
    _notNetworkView.userInteractionEnabled = YES;
    [_notNetworkView addGestureRecognizer:reloadTap];
    [self.view addSubview:_notNetworkView];
}

-(void)_leftBarBtnItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_loadData {
    NSString *billUrl = [NSString stringWithFormat:@"%@member/getConsumption", KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:[NSNumber numberWithInt:_page*_length] forKey:@"start"];
    [params setObject:[NSNumber numberWithInt:_length] forKey:@"length"];
    
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:billUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"success"] boolValue]){
            BillModel *billModel = [[BillModel alloc] initWithDataDic:responseObject[@"data"]];
            if(_page == 0){
                [_billData removeAllObjects];
            }
            if(billModel.data.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [_billData addObjectsFromArray:billModel.data];
            [self.tableView cyl_reloadData];
        }
        _notNetworkView.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
        [self showHint:@"网络不给力,请稍后重试!"];
        [self.view bringSubviewToFront:_notNetworkView];
        _notNetworkView.hidden = NO;
    }];
    
}

#pragma mark tableview 协议 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _billData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillCell"];
    cell.billInfoModel = _billData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BillDetailTableViewController *billDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BillDetailTableViewController"];
    billDetailVC.billInfoModel = _billData[indexPath.row];;
    [self.navigationController pushViewController:billDetailVC animated:YES];
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
