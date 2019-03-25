//
//  SelCarNoView.h
//  ZSTC
//
//  Created by coder on 2018/11/8.
//  Copyright © 2018年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelCarNoView : ZTBaseViewCtrl

- (instancetype)initTotalPay:(NSString *)totalBalance vc:(UIViewController *)vc dataSource:(NSArray *)dataSource;
//支付方式
@property (nonatomic, copy) void(^SelCarNum)(NSString *carNo);

@end

NS_ASSUME_NONNULL_END
