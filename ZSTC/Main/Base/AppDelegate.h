//
//  AppDelegate.h
//  ZSTC
//
//  Created by 焦平 on 2017/3/15.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTBaseViewCtrl.h"
#import "ZTBaseNavCtrl.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) ZTBaseNavCtrl *ztBaseBavCtrl;

/// func
+ (AppDelegate* )shareAppDelegate;

@end

