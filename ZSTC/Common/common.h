//
//  common.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#ifndef common_h
#define common_h

#define KDomain @"http://115.29.51.72:9080/park-service/"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define MainColor [UIColor colorWithRed:255.2f/255 green:180.2f/255 blue:0.2f/255 alpha:1]
#define color(r,g,b,a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define KLoginState @"lognState"
#define KLoginNotification @"loginNotification"
#define KLoginOutNotification @"loginOutNotification"
#define KAddCarNotification @"addCarNotification"
#define KDeleteCarNotification @"deleteCarNotification"
#define KToken [TheUserDefaults objectForKey:@"token"]
#define KMemberId [TheUserDefaults objectForKey:@"memberId"]

#import "ZSTCConfig.h"
#import "ZTNetworkClient.h"
#import "UIViewExt.h"
#import "Utils.h"
#import <SDAutoLayout.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+HUD.h"
#import <UIImageView+WebCache.h>
#import "UIView+ViewControllerRespond.h"
#import "UIImage+ScaleImage.h"
#import <MJRefresh.h>
#import "NSString+Date.h"
#import "AppDelegate+Location.h"

#endif /* common_h */
