//
//  InOutTableViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "InOutTableViewController.h"
#import "MsgCell.h"
#import <MJRefresh.h>
#import <CYLTableViewPlaceHolder.h>
#import "NoDataView.h"
#import "MsgDetailViewController.h"

@interface InOutTableViewController ()<CYLTableViewPlaceHolderDelegate>
{
    NSMutableArray *_inoutData;
    
    int _page;
    int _length;
}
@end

@implementation InOutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    [self _loadData];
}

- (void)_initView {
    _inoutData = @[].mutableCopy;
    _page = 0;
    _length = 5;
    
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
    if(_page == 0){
        [_inoutData removeAllObjects];
    }
    
    dispatch_group_t group = dispatch_group_create();
    for(int i=1; i<=2; i++) {
        dispatch_group_enter(group);
        
        NSString *msgUrl = [NSString stringWithFormat:@"%@member/getMessagePushList", KDomain];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:KToken forKey:@"token"];
        [params setObject:KMemberId forKey:@"memberId"];
        [params setObject:[NSString stringWithFormat:@"%d", i] forKey:@"pushType"];    // 消息类型(12进出场消息 3账户消息 4资产消息 5优惠消息)
        [params setObject:[NSNumber numberWithInt:_page*_length] forKey:@"start"];
        [params setObject:[NSNumber numberWithInt:_length] forKey:@"length"];
        [[ZTNetworkClient sharedInstance] POST:msgUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"success"] boolValue]){
                NSMutableArray *tempDate = @[].mutableCopy;
                NSArray *hisData = responseObject[@"data"][@"data"];
                [hisData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MsgModel *msgModel = [[MsgModel alloc] initWithDataDic:obj];
                    [tempDate addObject:msgModel];
                }];
                @synchronized (_inoutData) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    [_inoutData addObjectsFromArray:tempDate];
                }
                dispatch_group_leave(group);
            }else {
                dispatch_group_leave(group);
            }
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
        
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(_inoutData.count > 0){
            self.tableView.mj_footer.state = MJRefreshStateIdle;
        }else {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        [self sortData];
        
        [self.tableView cyl_reloadData];
    });
    
    
}

#pragma mark 按时间排序
- (void)sortData {
    for (int i=0; i<_inoutData.count; i++) {
        for (int j=i; j<_inoutData.count; j++) {
            MsgModel *iMsgModel = _inoutData[i];
            MsgModel *jMsgModel = _inoutData[j];
            
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *iPushDate = [formater dateFromString:iMsgModel.pushTime];
            NSDate *jPushDate = [formater dateFromString:jMsgModel.pushTime];
            
            if([iPushDate timeIntervalSinceDate:jPushDate] < 0.0){
                [_inoutData exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}

#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    NoDataView *noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    return noDateView;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inoutData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InOutMsgCell" forIndexPath:indexPath];
    cell.msgModel = _inoutData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MsgDetailViewController *msgDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MsgDetailViewController"];
    msgDetailVC.msgModel = _inoutData[indexPath.row];
    [self.navigationController pushViewController:msgDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
