//
//  AppDelegate+Location.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

/**
 *  声明block,传递经纬度、反编码、定位是否成功、显示框
 */
typedef void (^LocationPosition)(CLLocation *currentLocation,AMapLocationReGeocode *regeocode,BOOL isLocationSuccess);

@interface AppDelegate (Location)

@property (copy,nonatomic)LocationPosition locationBlock;          //定位到位置的block
@property (strong,nonatomic)AMapLocationManager *locationManager;  //管理者

//启动定位服务
-(void)startLocation;

//接收位置block
-(void)receiveLocationBlock:(LocationPosition)block;

@end
