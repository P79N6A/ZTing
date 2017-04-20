//
//  HisCarListView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "HisCarListView.h"
#import "HisCarCell.h"

@implementation HisCarListView
{
    UITableView *_carsTableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    
    _carsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _carsTableView.scrollEnabled = NO;
    _carsTableView.delegate = self;
    _carsTableView.dataSource = self;
    [_carsTableView registerNib:[UINib nibWithNibName:@"HisCarCell" bundle:nil] forCellReuseIdentifier:@"HisCarCell"];
    [self addSubview:_carsTableView];
}

- (void)setBindCarData:(NSArray *)bindCarData {
    _bindCarData = bindCarData;
    
    _carsTableView.frame = CGRectMake(0, 0, KScreenWidth, 70 * bindCarData.count);
    
    [_carsTableView reloadData];
}

#pragma mark UITableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bindCarData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HisCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HisCarCell"];
    BindCarModel *bindCarModel = _bindCarData[indexPath.row];
    cell._carNoLabel.text = bindCarModel.carNo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidden = YES;
    
    [_delegate selectBindCar:_bindCarData[indexPath.row]];
}

@end
