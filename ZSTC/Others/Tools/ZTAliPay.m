//
//  ZTAliPay.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTAliPay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation ZTAliPay

+ (void)aliPayWithOrderId:(NSString *)orderId {
    NSString *aliPayUrl = [NSString stringWithFormat:@"%@pay/payByAlipay", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:orderId forKey:@"orderId"];
    [[ZTNetworkClient sharedInstance] POST:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSString *payTradeId = responseObject[@"payTradeId"];
            NSString *payInfo = responseObject[@"payInfo"];
            [self ailPay:payInfo];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

+ (void)ailPay:(NSString *)info {
//    total_fee
//    NSMutableArray *params = [info componentsSeparatedByString:@"&"].mutableCopy;
//    [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *key = [param componentsSeparatedByString:@"="].firstObject;
//        if([key isEqualToString:@"total_fee"]){
//            [params replaceObjectAtIndex:idx withObject:@"total_fee=\"0.1\""];
//        }
//    }];
//    
//    NSMutableString *paraInfo = @"".mutableCopy;
//    [params enumerateObjectsUsingBlock:^(NSString *param, NSUInteger idx, BOOL * _Nonnull stop) {
//        [paraInfo appendFormat:@"%@&", param];
//    }];
//    
//    NSString *newParam = [paraInfo substringWithRange:NSMakeRange(0, paraInfo.length - 1)];
    
    [[AlipaySDK defaultService] payOrder:info fromScheme:KAppScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"+++++++++++++++++++++++%@", resultDic);
    }];
}

@end
