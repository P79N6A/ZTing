//
//  PayTypeView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "PayTypeView.h"

@implementation PayTypeView
{
    UIView *_bgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
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
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 180)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 22)];
    titleLabel.text = @"请选择支付方式";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabel.bottom + 8, KScreenWidth - 20, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    [_bgView addSubview:lineView];

    NSArray *names = @[@"余额(0.0元)", @"支付宝", @"微信"];
    NSArray *imageNames = @[@"icon_pay_balance", @"icon_pay_ali", @"icon_pay_wx"];
    for (int i=0; i<3; i++) {
        CGFloat itemWidth = self.width/3;
        UIButton *payBt = [UIButton buttonWithType:UIButtonTypeCustom];
        payBt.tag = 300 + i;
        payBt.frame = CGRectMake((itemWidth - 60)/2 + itemWidth * i, lineView.bottom + 20, 60, 60);
        [payBt setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [payBt addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:payBt];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, payBt.bottom + 8, itemWidth, 20)];
        label.tag = 400 + i;
        label.text = names[i];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17];
        label.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:label];

    }
}

- (void)payAction:(UIButton *)payBt {
    self.hidden = YES;
    switch (payBt.tag - 300) {
        case 0:
            // 余额
            [_delegate selPay:AccountPay];
            break;
            
        case 1:
            // 支付宝
            [_delegate selPay:AliPay];
            break;
            
        case 2:
            // 微信
            [_delegate selPay:WeChatPay];
            break;
    }
}

#pragma mark 加动画
- (void)setHidden:(BOOL)hidden {
    
    if(hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.frame = CGRectMake(0, self.height, _bgView.width, _bgView.height);
        } completion:^(BOOL finished) {
            [super setHidden:hidden];
        }];
    }else {
        [super setHidden:hidden];
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.frame = CGRectMake(0, self.height - 180, _bgView.width, _bgView.height);
        }];
    }
}

@end
