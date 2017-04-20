//
//  CarInfoView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CarInfoView.h"
#import "CarDetailModel.h"
#import "PaySelfViewController.h"

@implementation CarInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)_initView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCar)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
- (void)tapCar {
    PaySelfViewController *payVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySelfViewController"];
    payVC.carNo = _bindCarModel.carNo;
    [self.viewController.navigationController pushViewController:payVC animated:YES];
}

- (void)setBindCarModel:(BindCarModel *)bindCarModel {
    _bindCarModel = bindCarModel;
    
    [self _initView];
    
    // 车辆图片
    UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width/3, self.height/2)];
    carImgView.tag = 201;
    carImgView.backgroundColor = [UIColor grayColor];
    [self addSubview:carImgView];
    
    // 停车场名字
    UILabel *parkNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.left, carImgView.bottom + 6, carImgView.width, 20)];
    parkNameLabel.tag = 202;
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
    carNameBt.layer.masksToBounds = YES;
    carNameBt.layer.cornerRadius = 8;
    carNameBt.frame = CGRectMake(self.width - 60, carImgView.top, 68, 30);
    if(bindCarModel.carNike != nil && ![bindCarModel.carNike isKindOfClass:[NSNull class]] && bindCarModel.carNike.length > 0) {
        [carNameBt setTitle:bindCarModel.carNike forState:UIControlStateNormal];
    }else {
        carNameBt.hidden = YES;
    }
    [carNameBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.8] forState:UIControlStateNormal];
    carNameBt.backgroundColor = [UIColor colorWithRed:162.2f/255 green:226.2f/255 blue:248.2f/255 alpha:0.9];
    [self addSubview:carNameBt];
    
    // 进场时间
    UILabel *inTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoBt.left, infoBt.bottom + 8, self.width - infoBt.left, 20)];
    inTimeLabel.tag = 203;
    inTimeLabel.textColor = [UIColor grayColor];
    inTimeLabel.font = [UIFont systemFontOfSize:15];
    inTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:inTimeLabel];

    // 停车时长
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoBt.left, inTimeLabel.bottom + 8, inTimeLabel.width, 20)];
    timeLabel.tag = 204;
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:timeLabel];
    
    // 停车费用
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(infoBt.left, timeLabel.bottom + 8, inTimeLabel.width, 20)];
    moneyLabel.tag = 205;
    moneyLabel.textColor = [UIColor grayColor];
    moneyLabel.font = [UIFont systemFontOfSize:15];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:moneyLabel];
    
    [self loadCarNoDetail:bindCarModel];
}

- (void)loadCarNoDetail:(BindCarModel *)bindCarModel {
    NSString *carDetailUrl = [NSString stringWithFormat:@"%@pay/billingInquiryByCarNo", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:bindCarModel.carNo forKey:@"carNo"];
    [[ZTNetworkClient sharedInstance] POST:carDetailUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            CarDetailModel *carDelModel = [[CarDetailModel alloc] initWithDataDic:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadViewWithCarDelModel:carDelModel];
            });
        }
    } failure:^(NSError *error) {
    }];
}

- (void)uploadViewWithCarDelModel:(CarDetailModel *)carDetailModel {
    UIImageView *carImgView = [self viewWithTag:201];
    carImgView.contentMode = UIViewContentModeScaleAspectFill;
    carImgView.clipsToBounds = YES;
    if(carDetailModel.traceInphoto != nil && ![carDetailModel.traceInphoto isKindOfClass:[NSNull class]] && carDetailModel.traceInphoto.length > 0){
        NSString *utf_8UrlString = [carDetailModel.traceInphoto stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [carImgView sd_setImageWithURL:[NSURL URLWithString:utf_8UrlString] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }
    
    UILabel *parkNameLabel = [self viewWithTag:202];
    parkNameLabel.text = carDetailModel.parkName;
    
    UILabel *inTimeLabel = [self viewWithTag:203];
    NSString *viewTime = [carDetailModel.startTime substringWithRange:NSMakeRange(5, carDetailModel.startTime.length - 5)];
    inTimeLabel.text = [NSString stringWithFormat:@"进场时间: %@", viewTime];
    
    UILabel *timeLabel = [self viewWithTag:204];
    timeLabel.text = [NSString stringWithFormat:@"停车时长: %@", carDetailModel.differStr];
    
    UILabel *moneyLabel = [self viewWithTag:205];
    moneyLabel.text = [NSString stringWithFormat:@"停车费用: %.2f元", carDetailModel.fee.floatValue];
    
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
