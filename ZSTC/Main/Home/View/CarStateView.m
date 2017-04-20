//
//  CarStateView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CarStateView.h"
#import "BindCarModel.h"
#import "CarInfoView.h"
#import "BIndCarViewController.h"
#import "LoginViewController.h"

@implementation CarStateView
{
    UIScrollView *_scrollView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

- (void)_createView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
}

- (void)setCarData:(NSArray *)carData {
    _carData = carData;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self _createView];
    
    // 创建视图
    if(carData.count > 0){
        [self _createCarView];
    }else {
        [self _createAddCarView];
    }
    
}

- (void)_createCarView {
    _scrollView.contentSize = CGSizeMake(self.width * _carData.count, 0);
    
    [_carData enumerateObjectsUsingBlock:^(BindCarModel *bindCarModel, NSUInteger idx, BOOL * _Nonnull stop) {
        CarInfoView *carInfoView = [[CarInfoView alloc] initWithFrame:CGRectMake(_scrollView.width * idx, 0, _scrollView.width, _scrollView.height)];
        carInfoView.bindCarModel = bindCarModel;
        [_scrollView addSubview:carInfoView];
    }];
}

- (void)_createAddCarView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.height)];
    [self addSubview:bgView];
    UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCar)];
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:addTap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, bgView.width, 30)];
    label.text = @"快进快去，优惠更多!";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((bgView.width - 120)/2, label.bottom + 20, 120, 40);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [button setTitle:@"添加车辆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = MainColor;
    [button addTarget:self action:@selector(addCar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

#pragma mark 新增车辆
- (void)addCar {
    if([[NSUserDefaults standardUserDefaults]boolForKey:KLoginState]){
        BIndCarViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BIndCarViewController"];
        [self.viewController.navigationController pushViewController:bindCarVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.viewController presentViewController:loginVC animated:YES completion:nil];
    }
}

@end
