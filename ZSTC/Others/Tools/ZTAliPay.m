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

+ (void)aliPayWithOrderId:(NSString *)orderId payType:(NSString *)type withComplete:(PayCompleteBlock)payCompleteBlock{
    if ([type isEqualToString:@"1"]) {
        NSString *aliPayUrl = [NSString stringWithFormat:@"%@pay/memberRechargeByAliyun", KDomain];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:KToken forKey:@"token"];
        [params setObject:KMemberId forKey:@"memberId"];
        [params setObject:orderId forKey:@"orderId"];
        
        [[ZTNetworkClient sharedInstance] POST:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"success"] boolValue]){
                
                NSLog(@"%@",responseObject[@"message"]);
                
                NSDictionary *dic = responseObject[@"data"];
                
                NSString *payInfo = dic[@"payInfo"];
                
                [[AlipaySDK defaultService] payOrder:payInfo fromScheme:KAppScheme callback:^(NSDictionary *resultDic) {
                    //                NSLog(@"+++++++++++++++++++++++%@", resultDic);
                    payCompleteBlock(resultDic[@"resultStatus"]);
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }else
    {
        NSString *aliPayUrl = [NSString stringWithFormat:@"%@pay/payByAlipay", KDomain];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:KToken forKey:@"token"];
        [params setObject:KMemberId forKey:@"memberId"];
        [params setObject:orderId forKey:@"orderId"];
        
        [[ZTNetworkClient sharedInstance] POST:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"success"] boolValue]){
                
                NSLog(@"%@",responseObject[@"message"]);
                
                NSString *payInfo = responseObject[@"payInfo"];
                
                [[AlipaySDK defaultService] payOrder:payInfo fromScheme:KAppScheme callback:^(NSDictionary *resultDic) {
                    //                NSLog(@"+++++++++++++++++++++++%@", resultDic);
                    payCompleteBlock(resultDic[@"resultStatus"]);
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}

@end
