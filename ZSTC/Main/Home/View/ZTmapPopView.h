//
//  ZTmapPopView.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"

@interface ZTmapPopView : UIView

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) AnnotationModel *model;

//展示从底部向上弹出的UIView
- (void)showInView:(UIView *)view;

//移除从上向底部弹下去的UIView
- (void)disMissView;

@end
