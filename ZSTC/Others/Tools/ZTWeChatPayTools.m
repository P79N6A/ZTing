//
//  ZTWeChatPayTools.m
//  ZSTC
//
//  Created by 焦平 on 2017/5/23.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTWeChatPayTools.h"
#import "WXApi.h"

@implementation ZTWeChatPayTools

+ (void)weChatPayWithOrderId:(NSString *)orderId payType:(NSString *)type
{
    if ([type isEqualToString:@"1"]) {
        NSString *aliPayUrl = [NSString stringWithFormat:@"%@pay/memberRechargeByWeixin", KDomain];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:KToken forKey:@"token"];
        [params setObject:KMemberId forKey:@"memberId"];
        [params setObject:orderId forKey:@"orderId"];
        
        [[ZTNetworkClient sharedInstance] POST:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"success"] boolValue]){
                
                [self weChatPay:responseObject];
            }
            
            
            NSLog(@"%@",responseObject[@"message"]);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }else
    {
        NSString *aliPayUrl = [NSString stringWithFormat:@"%@pay/payByWeixin", KDomain];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:KToken forKey:@"token"];
        [params setObject:KMemberId forKey:@"memberId"];
        [params setObject:orderId forKey:@"orderId"];
        
        [[ZTNetworkClient sharedInstance] POST:aliPayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            if([responseObject[@"success"] boolValue]){
                
                [self weChatPay:responseObject];
            }
            
            
            NSLog(@"%@",responseObject[@"message"]);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
    
    
}

#pragma mark 微信支付方法
+ (void)weChatPay:(id)data{
    
    NSDictionary *respDic = data[@"data"];
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = @"";
    
    // 商家id，在注册的时候给的
    req.partnerId = respDic[@"partnerid"];
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = respDic[@"prepayid"];
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package = @"Sign=WXPay";
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = respDic[@"noncestr"];
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = respDic[@"timestamp"];
    req.timeStamp = stamp.intValue;
    
    // 这个签名也是后台做的
    req.sign = respDic[@"sign"];
    
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:req];
}

@end
