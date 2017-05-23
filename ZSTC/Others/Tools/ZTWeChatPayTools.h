//
//  ZTWeChatPayTools.h
//  ZSTC
//
//  Created by 焦平 on 2017/5/23.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTWeChatPayTools : NSObject

+ (void)weChatPayWithOrderId:(NSString *)orderId;  // 订单号

@end
