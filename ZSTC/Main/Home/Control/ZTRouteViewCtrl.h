//
//  ZTRouteViewCtrl.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/14.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AnnotationModel.h"

@interface ZTRouteViewCtrl : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D startCoor;//导航起始位置，即用户当前的位置

@property (nonatomic, assign) CLLocationCoordinate2D coor;//导航终点位置

@property (nonatomic, strong) AnnotationModel *model;

-(void)beginNavAction;

@end
