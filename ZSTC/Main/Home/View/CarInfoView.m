//
//  CarInfoView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CarInfoView.h"

@implementation CarInfoView

- (void)setBindCarModel:(BindCarModel *)bindCarModel {
    _bindCarModel = bindCarModel;
    
    // 车辆图片
    UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width/3, self.height/2)];
    carImgView.backgroundColor = MainColor;
    [self addSubview:carImgView];
    
    // 停车场名字
    UILabel *parkNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.left, carImgView.bottom + 6, carImgView.width, 20)];
    parkNameLabel.text = @"停车场信息";
    parkNameLabel.textColor = [UIColor blackColor];
    parkNameLabel.font = [UIFont systemFontOfSize:16];
    parkNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:parkNameLabel];

    
    // 车牌信息
    UIButton *infoBt = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBt.enabled = NO;
    infoBt.frame = CGRectMake(carImgView.right + 10, carImgView.top, 130, 60);
    [infoBt setTitle:bindCarModel.carNo forState:UIControlStateNormal];
    [infoBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [infoBt setBackgroundImage:[UIImage imageNamed:@"icon_car_card_bg"] forState:UIControlStateNormal];
    [self addSubview:infoBt];
    
    // 车辆名字
    UIButton *carNameBt = [UIButton buttonWithType:UIButtonTypeCustom];
    carNameBt.enabled = NO;
    carNameBt.frame = CGRectMake(self.width - 60, carImgView.top, 60, 30);
    if(bindCarModel.carNike != nil && ![bindCarModel.carNike isKindOfClass:[NSNull class]] && bindCarModel.carNike.length > 0) {
        [carNameBt setTitle:bindCarModel.carNike forState:UIControlStateNormal];
    }
    [carNameBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    carNameBt.backgroundColor = [UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:1];
    [self addSubview:carNameBt];
    
    // 进场时间
    UILabel *inTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoBt.left, infoBt.bottom + 8, self.width - infoBt.left, 20)];
    if(bindCarModel.carUtime != nil && ![bindCarModel.carUtime isKindOfClass:[NSNull class]] && bindCarModel.carUtime.length > 5) {
        NSString *inText = [bindCarModel.carUtime substringWithRange:NSMakeRange(5, bindCarModel.carUtime.length - 5)];
        inTimeLabel.text = [NSString stringWithFormat:@"进场时间: %@", inText];
    }else {
        inTimeLabel.text = [NSString stringWithFormat:@"进场时间:"];
    }
    inTimeLabel.textColor = [UIColor grayColor];
    inTimeLabel.font = [UIFont systemFontOfSize:15];
    inTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:inTimeLabel];

    // 停车时长
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoBt.left, inTimeLabel.bottom + 8, inTimeLabel.width, 20)];
    if(bindCarModel.carUtime != nil && ![bindCarModel.carUtime isKindOfClass:[NSNull class]] && bindCarModel.carUtime.length > 5) {
        timeLabel.text = [NSString stringWithFormat:@"停车时长: %@", [self timeLong:bindCarModel.carUtime]];
    }else {
        timeLabel.text = [NSString stringWithFormat:@"停车时长"];
    }
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
    
    // 停车费用
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoBt.left, timeLabel.bottom + 8, inTimeLabel.width, 20)];
    moneyLabel.text = [NSString stringWithFormat:@"停车费用: %@", @"0.00元"];
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:moneyLabel];
    
    
}

- (NSString *)timeLong:(NSString *)startTime {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [formatter dateFromString:startTime];
    
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval time = [nowDate timeIntervalSinceDate:startDate];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f小时%.0d分钟", time/3600, (int)time%3600/60];
    
    return timeStr;
}

@end
