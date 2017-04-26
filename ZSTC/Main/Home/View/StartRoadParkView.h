//
//  StartRoadParkView.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/24.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartRoadParkView : UIView

//停车时长
@property (nonatomic,strong) UILabel *durationLab;
//车位名称
@property (nonatomic,strong) UILabel *roadParkNameLab;
//收费规则
@property (nonatomic,strong) UILabel *rulerDetailLab;
//已产生费用
@property (nonatomic,strong) UILabel *costLab;
//需交费
@property (nonatomic,strong) UILabel *needPayDetailLab;

@end
