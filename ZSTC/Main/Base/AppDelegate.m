//
//  AppDelegate.m
//  ZSTC
//
//  Created by 焦平 on 2017/3/15.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UserGuiderViewController.h"
#import "HomeViewController.h"
#import <iflyMSC/iflyMSC.h>
#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>
#import "ZTJPushTools.h"
#import <JPUSHService.h>
#import "WXApi.h"
#import "ZTBaseNavCtrl.h"
#import "MessageViewController.h"

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>

@end

static NSString *JPushAppKey  = @"21234a323674a3471009cc12";
static NSString *JPushChannel = @"Publish channel";

#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const JPushIsProduction = FALSE;
#else
// 生产 极光TRUE为生产环境
static BOOL const JPushIsProduction = TRUE;
#endif

@implementation AppDelegate

- (void)loadRootVC {
    if (![TheUserDefaults boolForKey:@"firstLaunch"]) {
        [TheUserDefaults setBool:YES forKey:@"firstLaunch"];
        [TheUserDefaults synchronize];
        self.window.rootViewController = [[UserGuiderViewController alloc]init];
    }
    else {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavViewController"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /*初始化视图*/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self loadRootVC];
    
    //active
    [self.window makeKeyAndVisible];
    
    //极光推送
    [ZTJPushTools setupWithOption:launchOptions appKey:JPushAppKey channel:JPushChannel apsForProduction:JPushIsProduction advertisingIdentifier:nil];
    
    [self initAPServiceWithOptions:launchOptions];
    // 处理ios 10推送通知
    [self replyPushNotificationAuthorization:application];
    
    //高德地图
    [AMapServices sharedServices].apiKey = @"ea8b6fb545fe45ae2cf6d7e7798b7b92";
    //讯飞语音初始化
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"58d1d4f2"];
    [IFlySpeechUtility createUtility:initString];
    
    //微信支付
    [WXApi registerApp:@"wx37f08037003f60d1"];
    
    return YES;
}

- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    
    if (IOS10_OR_LATER) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (IOS8_OR_LATER){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
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
    
    [self reviceMsgDeal:application willPresentNotification:nil];
    
}

//iOS10新增：应用处于后台时的远程推送接受
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
        [self reviceMsgDeal:[UIApplication sharedApplication] willPresentNotification:nil];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        completionHandler(UNNotificationPresentationOptionSound);
        [self reviceMsgDeal:[UIApplication sharedApplication] willPresentNotification:notification];
        
    }else{
        //应用处于前台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark 接收消息处理
- (void)reviceMsgDeal:(UIApplication *)application willPresentNotification:(UNNotification *)notification{
    
    // 发送一条收到消息的通知
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeRefresh" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KReceiveMsgNotification object:nil];
        
        // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
        NSString *stateStr;
        if (application.applicationState == UIApplicationStateActive) {
            // 应用在前台运行时, 直接提示不做处理
            // 收到消息时，震动(系统可自带)
            //        [self playVibration];
            
            stateStr = @"UIApplicationStateActive";
            
            NSLog(@"%@",notification.request.content.body);
            
            
            
        }else if (application.applicationState == UIApplicationStateInactive){
            // 应用在后台运行时，点击通知进入应用，跳转到消息页面
            stateStr = @"UIApplicationStateInactive";
            [self inMsgControl];
        }else if (application.applicationState == UIApplicationStateBackground){
            // 不调用
            stateStr = @"UIApplicationStateBackground";
            
        }
    }
    
}

- (void)inMsgControl {
    ZTBaseNavCtrl *baseNavVC = (ZTBaseNavCtrl *)self.window.rootViewController;
    
    [baseNavVC popToRootViewControllerAnimated:NO];
    
    MessageViewController *msgVC = [[MessageViewController alloc] init];
    [baseNavVC pushViewController:msgVC animated:YES];
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if([[url absoluteString] rangeOfString:@"wx37f08037003f60d1://pay"].location == 0)//你的微信开发者appid
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        if ([url.host isEqualToString:@"safepay"]) {
            
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                
                if (orderState==9000) {
                    NSString *allString=resultDic[@"result"];
                    NSString * FirstSeparateString=@"\"&";
                    NSString *  SecondSeparateString=@"=\"";
                    NSMutableDictionary *dic=[self componentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
                    NSLog(@"ali=%@",dic);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alipaySuccess" object:nil];
                    
                }else{
                    NSString *returnStr;
                    switch (orderState) {
                        case 8000:
                            returnStr=@"订单正在处理中";
                            break;
                        case 4000:
                            returnStr=@"订单支付失败";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayfa" object:nil];
                            break;
                        case 6001:
                            returnStr=@"订单取消";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayDidntFinsh" object:nil];
                            break;
                        case 6002:
                            returnStr=@"网络连接出错";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"alipayNetWor" object:nil];
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                
            }];
            
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
        
    }
    
    return YES;
}

-(NSMutableDictionary *)componentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
        
    }
    
    return dic;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [ZTJPushTools showLocalNotificationAtFront:notification];
    return;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    return;
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp
{
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatPaySuccess" object:nil];
                
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatPayFalu" object:nil];
                
                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatPaydidntFinsh" object:nil];
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatPayFalu" object:nil];
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


@end
