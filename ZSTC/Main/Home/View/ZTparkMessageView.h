//
//  ZTparkMessageView.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/17.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"

@interface ZTparkMessageView : UIView

//停车场名字
@property (nonatomic,strong) UILabel *parkNameLab;
//距离停车场距离
@property (nonatomic,strong) UILabel *distanceLab;
//分割线
@property (nonatomic,strong) UIView *sepView;
//开始导航
@property (nonatomic,strong) UIButton *naviBtn;

@property (nonatomic,strong) AnnotationModel *model;

@end
