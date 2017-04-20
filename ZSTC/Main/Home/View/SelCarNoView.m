//
//  SelCarNoView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "SelCarNoView.h"
#import "CarCell.h"
#import "BindCarModel.h"

@implementation SelCarNoView
{
    UITableView *_carTabelView;
    NSMutableArray *_carData;
    
    UIView *_headView;  // 自定义头视图
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self _initView];
        
        [self _loadData];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
    _carData = @[].mutableCopy;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    headLabel.text = @"选择车辆";
    headLabel.textColor = [UIColor blackColor];
    headLabel.font = [UIFont systemFontOfSize:16];
    headLabel.textAlignment = NSTextAlignmentLeft;
    [_headView addSubview:headLabel];

    
    _carTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _carTabelView.delegate = self;
    _carTabelView.dataSource = self;
    [_carTabelView registerNib:[UINib nibWithNibName:@"CarCell" bundle:nil] forCellReuseIdentifier:@"CarCell"];
    _carTabelView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _carTabelView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_carTabelView];
    
}

#pragma mark 加载数据
- (void)_loadData {
    // 获取所有绑定车辆
    NSString *bindUrl = [NSString stringWithFormat:@"%@member/getMemberCards", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [[ZTNetworkClient sharedInstance] POST:bindUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if(responseObject[@"success"]){
            NSArray *datas = responseObject[@"data"][@"carList"]
            ;
            _carTabelView.frame = CGRectMake(0, KScreenHeight - 80 * datas.count - 60, KScreenWidth, 80 * datas.count + 60);
            
            [_carData removeAllObjects];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BindCarModel *bindCarModel = [[BindCarModel alloc] initWithDataDic:obj];
                [_carData addObject:bindCarModel];
            }];
            [_carTabelView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark UITableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarCell"];
    BindCarModel *bindCarModel = _carData[indexPath.row];
    cell.carNoLabel.text = bindCarModel.carNo;
    cell.carNameLabel.text = bindCarModel.carNike;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_carTabelView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidden = YES;
}

@end
