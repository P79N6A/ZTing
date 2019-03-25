//
//  CardViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CardViewController.h"
#import "CardModel.h"
#import "CardCell.h"
#import "CYLTableViewPlaceHolder.h"
#import "NoDataView.h"
#import "NoNetWorkView.h"

@interface CardViewController ()<CYLTableViewPlaceHolderDelegate>
{
    NSMutableArray *_cardData;
    
    NoNetWorkView *_notNetworkView;
}
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _loadData];
}

- (void)_initView {
    self.title = @"卡包";
    _cardData = @[].mutableCopy;
    
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    _notNetworkView = [[NoNetWorkView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _notNetworkView.hidden = YES;
    UITapGestureRecognizer *reloadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_loadData)];
    _notNetworkView.userInteractionEnabled = YES;
    [_notNetworkView addGestureRecognizer:reloadTap];
    [self.view addSubview:_notNetworkView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CardCell" bundle:nil] forCellReuseIdentifier:@"CardCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)_loadData {
    NSString *bindUrl = [NSString stringWithFormat:@"%@member/getAccountCoupons", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:@"1" forKey:@"couponStatus"];  // 优惠券使用状态(0:未领取 1：未使用 2；已使用)
    [params setObject:@"l" forKey:@"expFlag"]; // 优惠券使用状态(g:过期 l:未过期)
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:bindUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if(responseObject[@"success"]){
            NSArray *datas = responseObject[@"data"];
            [_cardData removeAllObjects];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CardModel *cardModel = [[CardModel alloc] initWithDataDic:obj];
                [_cardData addObject:cardModel];
            }];
            [self.tableView cyl_reloadData];
        }
        
        _notNetworkView.hidden = YES;
        
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"网络不给力,请稍后重试!"];
        [self.view bringSubviewToFront:_notNetworkView];
        _notNetworkView.hidden = NO;
    }];
}

#pragma mark 历史优惠券
- (void)addCarAction {
    
}

#pragma mark UITableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cardData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    cell.cardModel = _cardData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
