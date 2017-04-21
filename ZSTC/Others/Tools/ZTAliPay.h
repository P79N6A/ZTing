//
//  ZTAliPay.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTAliPay : NSObject

+ (void)aliPayWithOrderId:(NSString *)orderId;  // 订单号

@end
