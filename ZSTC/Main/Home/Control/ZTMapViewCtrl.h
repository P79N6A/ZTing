//
//  ZTMapViewCtrl.h
//  ZSTC
//
//  Created by 焦平 on 2017/3/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@class AMapNaviPoint;

@interface ZTMapViewCtrl : UIViewController

- (void)routePlanAction:(AMapNaviPoint *)endPoint;

- (void)beginNavAction:(AMapNaviPoint *)endPoint;

@end
