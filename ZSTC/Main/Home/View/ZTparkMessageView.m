//
//  ZTparkMessageView.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/17.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTparkMessageView.h"
#import "ZTRouteViewCtrl.h"

@implementation ZTparkMessageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubViews];
    }
    return self;
}

-(void)configSubViews
{
    UILabel *parkNameLab = [[UILabel alloc] init];
    self.parkNameLab = parkNameLab;
    parkNameLab.font = [UIFont systemFontOfSize:15];
    parkNameLab.textColor = [UIColor blackColor];
    parkNameLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:parkNameLab];
    
    UILabel *distanceLab = [[UILabel alloc] init];
    self.distanceLab = distanceLab;
    distanceLab.font = [UIFont systemFontOfSize:12];
    distanceLab.textColor = [UIColor lightGrayColor];
    distanceLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:distanceLab];
    
    UIView *sepView = [[UIView alloc] init];
    self.sepView = sepView;
    sepView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepView];
    
    UIButton *naviBtn = [[UIButton alloc] init];
    self.naviBtn = naviBtn;
    [naviBtn addTarget:self action:@selector(naviBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [naviBtn setImage:[UIImage imageNamed:@"icon_park_navigation"] forState:UIControlStateNormal];
    [naviBtn setTitle:@"导航" forState:UIControlStateNormal];
    [naviBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [naviBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:naviBtn];
    
    [self subViewsAutoLayout];
}

-(void)subViewsAutoLayout
{
    
    self.parkNameLab.sd_layout
    .topSpaceToView(self, 10)
    .leftSpaceToView(self, 10);
    
    self.distanceLab.sd_layout
    .topSpaceToView(self.parkNameLab, 15)
    .rightSpaceToView(self, 10)
    .widthIs(150)
    .heightIs(20);
    
    self.sepView.sd_layout
    .topSpaceToView(self.distanceLab, 10)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.5);
    
    self.naviBtn.sd_layout
    .topSpaceToView(self.sepView, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
}

-(void)naviBtnAction:(UIButton *)sender
{
    ZTRouteViewCtrl *viewCtrl = (ZTRouteViewCtrl *)[self viewController];
    [viewCtrl beginNavAction];
}

-(void)setModel:(AnnotationModel *)model
{
    _model = model;
    
    _parkNameLab.text = model.parkName;
    NSString *content1 = self.parkNameLab.text;
    CGSize parkNameSize = [content1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    _parkNameLab.sd_layout
    .widthIs(parkNameSize.width)
    .heightIs(parkNameSize.height);
    
}

@end
