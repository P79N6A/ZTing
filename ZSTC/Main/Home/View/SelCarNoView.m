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

- (void)hidView {
    self.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view == self){
        return YES;
    }else{
        return NO;
    }
}

- (void)_initView {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidView)];
    self.userInteractionEnabled = YES;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _carData = @[].mutableCopy;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    _headView.backgroundColor = [UIColor whiteColor];
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    headLabel.text = @"选择车辆";
    headLabel.textColor = [UIColor blackColor];
    headLabel.font = [UIFont systemFontOfSize:16];
    headLabel.textAlignment = NSTextAlignmentLeft;
    [_headView addSubview:headLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 59, KScreenWidth - 20, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [_headView addSubview:lineView];

    _carTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 80 * 3 + 60) style:UITableViewStylePlain];
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
        if([responseObject[@"success"] boolValue]){
            NSArray *datas = responseObject[@"data"][@"carList"];
            
            [_carData removeAllObjects];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BindCarModel *bindCarModel = [[BindCarModel alloc] initWithDataDic:obj];
                [_carData addObject:bindCarModel];
            }];
            [_carTabelView reloadData];
        }else if ([responseObject[@"statusCode"] integerValue] == 202) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginState];
            // 发送登出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KLoginOutNotification object:nil];
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
    
    BindCarModel *bindCarModel = _carData[indexPath.row];
    [_delegate selCarNoCompelete:bindCarModel.carNo];
}

#pragma mark 加动画
- (void)setHidden:(BOOL)hidden {
    
    if(hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            _carTabelView.frame = CGRectMake(0, self.height, _carTabelView.width, _carTabelView.height);
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    }else {
        [super setHidden:hidden];
        [UIView animateWithDuration:0.2 animations:^{
            _carTabelView.frame = CGRectMake(0, self.height - 300, _carTabelView.width, _carTabelView.height);
        }];
    }
}


@end
