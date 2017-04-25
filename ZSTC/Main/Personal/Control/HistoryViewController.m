//
//  HistoryViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "HistoryViewController.h"

#import "HistoryCell.h"
#import "BindCarModel.h"
#import "HistoryModel.h"
#import "HisCarListView.h"
#import "HisDetailViewController.h"
#import <CYLTableViewPlaceHolder.h>
#import "NoDataView.h"

@interface HistoryViewController ()<SelectBindCarDelegate, CYLTableViewPlaceHolderDelegate>
{
    NSMutableArray *_bindCarData;
    NSMutableArray *_recordData;
    
    int _page;
    int _length;
    
    // 自定义标题视图
    UIView *_titleView;
    
    // 车牌选择视图(绑定多辆车时)
    HisCarListView *_hisCarListView;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _loadData];
}

- (void)_initView {
    // 设置返回按钮
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    self.title = @"停车历史";
    _page = 0;
    _length = 10;
    
    _bindCarData = @[].mutableCopy;
    _recordData = @[].mutableCopy;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil] forCellReuseIdentifier:@"HistoryCell"];
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
    
    // 自定义标题视图
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    _titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _titleView;
    UITapGestureRecognizer *selTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selBindCar)];
    _titleView.userInteractionEnabled = YES;
    [_titleView addGestureRecognizer:selTap];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 30)];
    titleLabel.tag = 101;
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:titleLabel];
    
    UIButton *manyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ;manyButton.tag = 102;
    manyButton.hidden = YES;
    manyButton.frame = CGRectMake(titleLabel.right, 10, 20, 20);
    [manyButton setBackgroundImage:[UIImage imageNamed:@"icon_arrow_down_btn"] forState:UIControlStateNormal];
    [manyButton addTarget:self action:@selector(selBindCar) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:manyButton];
    
    // 创建选择车辆视图
//    [self _createView];
}

- (void)_createView {
    [_hisCarListView removeFromSuperview];
    _hisCarListView = nil;
    
    _hisCarListView = [[HisCarListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _hisCarListView.delegate = self;
    _hisCarListView.hidden = YES;
    _hisCarListView.bindCarData = _bindCarData;
    [self.view addSubview:_hisCarListView];
    [self.view bringSubviewToFront:_hisCarListView];
}
#pragma mark 选择车牌协议
- (void)selectBindCar:(BindCarModel *)bindCarModel {
    self.tableView.scrollEnabled = YES;
    _page = 0;
    UILabel *titleLabel = [_titleView viewWithTag:101];
    titleLabel.text = bindCarModel.carNo;
    [self _loadCarNoHistory:bindCarModel];
}

- (void)_loadData {
    // 获取所有绑定车辆
    NSString *bindUrl = [NSString stringWithFormat:@"%@member/getMemberCards", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [[ZTNetworkClient sharedInstance] POST:bindUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if(responseObject[@"success"]){
            NSArray *datas = responseObject[@"data"][@"carList"];
            [_bindCarData removeAllObjects];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BindCarModel *bindCarModel = [[BindCarModel alloc] initWithDataDic:obj];
                [_bindCarData addObject:bindCarModel];
            }];
            // 加载绑定第一辆车历史
            if(_bindCarData.count > 0) {
                [self _loadCarNoHistory:_bindCarData.firstObject];
                
                UILabel *titleLabel = [_titleView viewWithTag:101];
                BindCarModel *bindCarModel = _bindCarData.firstObject;
                titleLabel.text = bindCarModel.carNo;
            }
            
            if(_bindCarData.count > 1){
                UIButton *manyBt = [_titleView viewWithTag:102];
                manyBt.hidden = NO;
            }
            if(_bindCarData.count <= 0){
                [self.tableView cyl_reloadData];
                [self _createView];
            }
//            _hisCarListView.bindCarData = _bindCarData;
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark 加载某一绑定车辆的历史记录
- (void)_loadCarNoHistory:(BindCarModel *)bindCarModel {
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    
    NSString *hisUrl = [NSString stringWithFormat:@"%@trace/getMemberTraceList", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:bindCarModel.carNo forKey:@"carno"];
    [params setObject:bindCarModel.carCtime forKey:@"traceBegin"];
    [params setObject:nowDateStr forKey:@"traceEnd"];
    [params setObject:[NSNumber numberWithInt:_page*_length] forKey:@"start"];
    [params setObject:[NSNumber numberWithInt:_length] forKey:@"length"];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:hisUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"success"] boolValue]){
            if(_page == 0){
                [_recordData removeAllObjects];
            }
            NSArray *hisData = responseObject[@"data"][@"data"];
            if(hisData.count > 0){
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }else {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [hisData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HistoryModel *historyModel = [[HistoryModel alloc] initWithDataDic:obj];
                [_recordData addObject:historyModel];
            }];
            [self.tableView cyl_reloadData];
            [self _createView];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark 选择绑定车辆
- (void)selBindCar {
    if(_bindCarData.count > 1){
        _hisCarListView.hidden = !_hisCarListView.hidden;
        if(!_hisCarListView.hidden){
            [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
            self.tableView.scrollEnabled = NO;
        }else {
            self.tableView.scrollEnabled = YES;
        }
    }
}

#pragma mark tableview 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return _recordData.count;
    return _recordData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    cell.historyModel = _recordData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HisDetailViewController *hisDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HisDetailViewController"];
    hisDetailVC.historyModel = _recordData[indexPath.row];
    [self.navigationController pushViewController:hisDetailVC animated:YES];
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
