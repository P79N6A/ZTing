//
//  AppDelegate+ZTJPushSdk.m
//  ZSTC
//
//  Created by 焦平 on 2017/3/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "AppDelegate+ZTJPushSdk.h"
#import "ZTJPushTools.h"
#import <JPUSHService.h>
#import <AlipaySDK/AlipaySDK.h>

#define JPushSDK_AppKey  @"21234a323674a3471009cc12"
#define isProduction     NO

@implementation AppDelegate (ZTJPushSdk)

-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [ZTJPushTools setupWithOption:launchOptions appKey:JPushSDK_AppKey channel:nil apsForProduction:isProduction advertisingIdentifier:nil];
    
    [self initAPServiceWithOptions:launchOptions];
    
}

- (void)initAPServiceWithOptions:(NSDictionary *)launchOptions
{
    //为消息监听方法注册监听器
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    [defaultCenter addObserver:self selector:@selector(networkIsConnecting:) name:kJPFNetworkIsConnectingNotification object:nil];
    
    
}

-(void)networkIsConnecting:(NSNotification *)notification
{
//    NSLog(@"正在连接中...");
}

- (void)networkDidSetup:(NSNotification *)notification {
    
//    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
//    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    
    
//    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSString *registrationID = [JPUSHService registrationID];
    
    [TheUserDefaults setObject:registrationID forKey:@"registrationID"];
    [TheUserDefaults synchronize];
//    NSSet *set = [NSSet setWithObject:@"1"];
//    [JPUSHService setTags:set alias:@"pingjiao" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
//        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
//    }];
//    NSLog(@"registrationID:%@", registrationID);
//    NSLog(@"已登录");
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [ZTJPushTools registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [ZTJPushTools handleRemoteNotification:userInfo completion:nil];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [ZTJPushTools handleRemoteNotification:userInfo completion:completionHandler];
    
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"收到推送消息"
                              message:userInfo[@"aps"][@"alert"]
                              delegate:nil
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [ZTJPushTools showLocalNotificationAtFront:notification];
    return;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    return;
}

@end
