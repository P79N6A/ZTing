//
//  StartRoadParkView.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/24.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "StartRoadParkView.h"

@interface StartRoadParkView()

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UILabel *parkDurationLab;

@property (nonatomic,strong) UILabel *couponLab;

@property (nonatomic,strong) UILabel *couponDetailLab;

@property (nonatomic,strong) UIButton *selectCouponBtn;

@property (nonatomic,strong) UILabel *needPayLab;

@property (nonatomic,strong) UIButton *completeParkBtn;

@end

@implementation StartRoadParkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self _initView];
        
    }
    return self;
}

-(void)_initView
{
    UILabel *parkDurationLab = [[UILabel alloc] init];
    parkDurationLab.font = [UIFont systemFontOfSize:15];
    parkDurationLab.textAlignment = NSTextAlignmentCenter;
    parkDurationLab.textColor = [UIColor blackColor];
    self.parkDurationLab = parkDurationLab;
    parkDurationLab.text = @"停车时长";
    [self addSubview:parkDurationLab];
    
    self.parkDurationLab.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 15)
    .rightSpaceToView(self, 0)
    .heightIs(20);
    
    UILabel *durationLab = [[UILabel alloc] init];
    durationLab.text = @"1小时38分";
    durationLab.textAlignment = NSTextAlignmentCenter;
    durationLab.font = [UIFont boldSystemFontOfSize:28];
    durationLab.textColor = [UIColor blackColor];
    self.durationLab = durationLab;
    [durationLab sizeToFit];
    [self addSubview:durationLab];
    
    
    CGSize durationSize = [durationLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28]}];
    self.durationLab.sd_layout
    .topSpaceToView(self.parkDurationLab, 20)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(durationSize.height);
    
    UILabel *roadParkNameLab = [[UILabel alloc] init];
    roadParkNameLab.font = [UIFont systemFontOfSize:16];
    roadParkNameLab.textAlignment = NSTextAlignmentLeft;
    roadParkNameLab.textColor = [UIColor blackColor];
    self.roadParkNameLab = roadParkNameLab;
    roadParkNameLab.text = @"光谷大道路边A段-14号车位";
    [self addSubview:roadParkNameLab];
    
    self.roadParkNameLab.sd_layout
    .topSpaceToView(self.durationLab, 15)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(20);
    
    UILabel *rulerDetailLab = [[UILabel alloc] init];
    rulerDetailLab.font = [UIFont systemFontOfSize:16];
    rulerDetailLab.textAlignment = NSTextAlignmentLeft;
    rulerDetailLab.textColor = [UIColor blackColor];
    self.rulerDetailLab = rulerDetailLab;
    rulerDetailLab.numberOfLines = 0;
    rulerDetailLab.text = @"收费规则: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    [self addSubview:rulerDetailLab];
    
    CGSize rulerSize = [rulerDetailLab.text boundingRectWithSize:CGSizeMake(KScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    self.rulerDetailLab.sd_layout
    .topSpaceToView(self.roadParkNameLab, 10)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(rulerSize.height);
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = [UIFont systemFontOfSize:16];
    priceLab.textAlignment = NSTextAlignmentLeft;
    priceLab.textColor = [UIColor blackColor];
    self.priceLab = priceLab;
    priceLab.text = @"已产生费用: ";
    [self addSubview:priceLab];
    
    CGSize priceSize = [priceLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.priceLab.sd_layout
    .topSpaceToView(self.rulerDetailLab, 40)
    .leftSpaceToView(self, 10)
    .widthIs(priceSize.width)
    .heightIs(priceSize.height);
    
    UILabel *costLab = [[UILabel alloc] init];
    costLab.font = [UIFont systemFontOfSize:16];
    costLab.textAlignment = NSTextAlignmentLeft;
    costLab.textColor = [UIColor blackColor];
    self.costLab = costLab;
    [self addSubview:costLab];
    
    self.costLab.sd_layout
    .leftSpaceToView(_priceLab, 5)
    .topSpaceToView(self.rulerDetailLab, 40)
    .rightSpaceToView(self, 10)
    .heightIs(priceSize.height);

    UILabel *couponLab = [[UILabel alloc] init];
    couponLab.font = [UIFont systemFontOfSize:16];
    couponLab.textAlignment = NSTextAlignmentLeft;
    couponLab.textColor = [UIColor blackColor];
    self.couponLab = couponLab;
    couponLab.text = @"优惠券: ";
    [self addSubview:couponLab];
    
    self.couponLab.sd_layout
    .topSpaceToView(self.priceLab, 20)
    .leftSpaceToView(self, 10)
    .widthIs(100)
    .heightIs(priceSize.height);
    
    UIButton *selectCouponBtn = [[UIButton alloc] init];
    [selectCouponBtn addTarget:self action:@selector(selectCouponBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectCouponBtn setTitle:@"选择优惠券" forState:UIControlStateNormal];
    [selectCouponBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [selectCouponBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectCouponBtn.layer.borderColor = [UIColor blackColor].CGColor;
    selectCouponBtn.layer.borderWidth = 1;
    self.selectCouponBtn = selectCouponBtn;
    [self addSubview:selectCouponBtn];
    
    self.selectCouponBtn.sd_layout
    .topSpaceToView(self.priceLab, 20)
    .widthIs(100)
    .rightSpaceToView(self, 10)
    .heightIs(priceSize.height);
    
    UILabel *needPayLab = [[UILabel alloc] init];
    needPayLab.font = [UIFont systemFontOfSize:16];
    needPayLab.textAlignment = NSTextAlignmentLeft;
    needPayLab.textColor = [UIColor blackColor];
    self.needPayLab = needPayLab;
    needPayLab.text = @"需交费: ";
    [self addSubview:needPayLab];

    self.needPayLab.sd_layout
    .topSpaceToView(self.couponLab, 20)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(priceSize.height);


    UIButton *completeParkBtn = [[UIButton alloc] init];
    [completeParkBtn addTarget:self action:@selector(completeParkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [completeParkBtn setTitle:@"完成停车" forState:UIControlStateNormal];
    [completeParkBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [completeParkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    completeParkBtn.backgroundColor = MainColor;
    self.completeParkBtn = completeParkBtn;
    [self addSubview:completeParkBtn];
    
    completeParkBtn.sd_layout
    .bottomSpaceToView(self, 20)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(40);
}

#pragma mark 选择优惠券

-(void)selectCouponBtnAction:(id)sender
{
    
}

#pragma mark 完成停车
#warning 需完善
-(void)completeParkBtnAction:(id)sender
{
    NSString *urlStr = [NSString stringWithFormat:@"%@roadTrace/roadOrderByThirdPay",KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    //关闭定时器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeTimer" object:nil];
    
    [TheUserDefaults setBool:NO forKey:KRoadParkState];
    [TheUserDefaults synchronize];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
