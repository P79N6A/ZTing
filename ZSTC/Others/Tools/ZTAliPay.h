//
//  ZTAliPay.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PayCompleteBlock)(NSString *stateCode);

@interface ZTAliPay : NSObject

+ (void)aliPayWithOrderId:(NSString *)orderId withComplete:(PayCompleteBlock)payCompleteBlock;  // 订单号

@property (nonatomic, assign) PayCompleteBlock payCompleteBlock;

@end
