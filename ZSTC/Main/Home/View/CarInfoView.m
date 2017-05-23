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
#import "ZTMapViewCtrl.h"

@implementation CarInfoView
{
    BOOL _isNoData;
}

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
    if(_isNoData){
        // 无数据
        ZTMapViewCtrl *mapViewCtrl = [[ZTMapViewCtrl alloc] init];
        [self.viewController.navigationController pushViewController:mapViewCtrl animated:YES];
    }else {
        PaySelfViewController *payVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySelfViewController"];
        payVC.carNo = _bindCarModel.carNo;
        [self.viewController.navigationController pushViewController:payVC animated:YES];
    }
}

- (void)setBindCarModel:(BindCarModel *)bindCarModel {
    _bindCarModel = bindCarModel;
    
    [self _initView];
    
    // 车辆图片
    UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width/3, self.height/2)];
    carImgView.tag = 201;
//    carImgView.backgroundColor = [UIColor grayColor];
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
    infoBt.tag = 200;
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
    carNameBt.frame = CGRectMake(self.width - 60, carImgView.top, 60, 30);
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
        }else {
            [self noDataUploadViewWithCarDelModel];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark 有数据加载视图
- (void)uploadViewWithCarDelModel:(CarDetailModel *)carDetailModel {
    _isNoData = NO;
    
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

#pragma mark 无数据加载视图
- (void)noDataUploadViewWithCarDelModel {
    _isNoData = YES;
    
    UIButton *infoBt = [self viewWithTag:200];
    infoBt.frame = CGRectMake((self.width - infoBt.width)/2, infoBt.top, infoBt.width, infoBt.height);
    [infoBt setBackgroundImage:[UIImage imageNamed:@"icon_car_yellow"] forState:UIControlStateNormal];
    
    UIImageView *carImgView = [self viewWithTag:201];
    carImgView.hidden = YES;
    
    UILabel *parkNameLabel = [self viewWithTag:202];
    parkNameLabel.hidden = YES;
    
    UILabel *inTimeLabel = [self viewWithTag:203];
    inTimeLabel.hidden = YES;
    
    UILabel *timeLabel = [self viewWithTag:204];
    timeLabel.hidden = YES;
    
    UILabel *moneyLabel = [self viewWithTag:205];
    moneyLabel.hidden = YES;
    
    // 添加视图
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 100)/2, infoBt.bottom + 10, 100, 20)];
    msgLabel.text = @"无进场记录";
    msgLabel.textColor = [UIColor grayColor];
    msgLabel.font = [UIFont systemFontOfSize:16];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:msgLabel];

    UIImageView *findImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 - 80, msgLabel.bottom + 8, 60,60)];
    findImgView.image = [UIImage imageNamed:@"icon_park_no_road_find"];
    [self addSubview:findImgView];
    
    UILabel *findLabel = [[UILabel alloc] initWithFrame:CGRectMake(findImgView.right + 4, msgLabel.bottom + 30, 120, 20)];
    findLabel.text = @"快速寻找车位";
    findLabel.textColor = MainColor;
    findLabel.font = [UIFont systemFontOfSize:17];
    findLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:findLabel];

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
