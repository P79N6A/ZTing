//
//  ParkDetailCtrl.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTBaseViewCtrl.h"
#import "AnnotationModel.h"

@interface ParkDetailCtrl : ZTBaseViewCtrl

@property (nonatomic,copy) NSString *parkId;

@property (nonatomic,strong) AnnotationModel *model;

@end
