//
//  PropertyTableViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "PropertyTableViewController.h"
#import "MsgCell.h"
#import <MJRefresh.h>
#import <CYLTableViewPlaceHolder.h>
#import "NoDataView.h"
#import "MsgDetailViewController.h"

@interface PropertyTableViewController ()<CYLTableViewPlaceHolderDelegate>

{
    NSMutableArray *_propertyData;
    
    int _page;
    int _length;
}
@end

@implementation PropertyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    [self _loadData];
}

- (void)_initView {
    _propertyData = @[].mutableCopy;
    _page = 0;
    _length = 10;
    
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgCell" bundle:nil] forCellReuseIdentifier:@"InOutMsgCell"];
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
}
- (void)_loadData {
    NSString *msgUrl = [NSString stringWithFormat:@"%@member/getMessagePushList", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:@"4" forKey:@"pushType"];    // 消息类型(12进出场消息 3账户消息 4资产消息 5优惠消息)
    [params setObject:[NSNumber numberWithInt:_page*_length] forKey:@"start"];
    [params setObject:[NSNumber numberWithInt:_length] forKey:@"length"];
    [[ZTNetworkClient sharedInstance] POST:msgUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"success"] boolValue]){
            if(_page == 0){
                [_propertyData removeAllObjects];
            }
            NSArray *hisData = responseObject[@"data"][@"data"];
            if(hisData.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [hisData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MsgModel *msgModel = [[MsgModel alloc] initWithDataDic:obj];
                [_propertyData addObject:msgModel];
            }];
            [self.tableView cyl_reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    NoDataView *noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    return noDateView;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _propertyData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InOutMsgCell" forIndexPath:indexPath];
    cell.msgModel = _propertyData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MsgDetailViewController *msgDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MsgDetailViewController"];
    msgDetailVC.msgModel = _propertyData[indexPath.row];
    [self.navigationController pushViewController:msgDetailVC animated:YES];
}


@end
