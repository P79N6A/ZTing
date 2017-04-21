//
//  ZTmapPopView.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTmapPopView.h"
#import "ZTMapViewCtrl.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "ParkDetailCtrl.h"

@interface ZTmapPopView()

@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UIImageView *coverImageView;

@property (nonatomic,strong) UILabel *parkNameLab;

@property (nonatomic,strong) UILabel *distanceLab;

@property (nonatomic,strong) UILabel *parkingSpacesLab;

@property (nonatomic,strong) UILabel *troduceLab;

@property (nonatomic,strong) UIButton *routeBtn;

@property (nonatomic,strong) UIButton *navigationBtn;

@property (nonatomic,strong) UIView *verSepView;

@property (nonatomic,strong) UIView *horSepView;

@end

@implementation ZTmapPopView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initContent];
    }
    
    return self;
}

- (void)initContent
{
    self.frame = CGRectMake(0, KScreenHeight-200, KScreenWidth, 200);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(10, KScreenHeight - 200, KScreenWidth-20, 190)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        UIView *headerView = [[UIView alloc] init];
        self.headerView = headerView;
        headerView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:headerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.headerView addGestureRecognizer:tap];
        
        UIImageView *coverImageView = [UIImageView new];
        coverImageView.userInteractionEnabled = YES;
        self.coverImageView = coverImageView;
        [headerView addSubview:coverImageView];
        
        UILabel *parkNameLab = [UILabel new];
        parkNameLab.font = [UIFont systemFontOfSize:15];
        parkNameLab.textColor = [UIColor blackColor];
        parkNameLab.textAlignment = NSTextAlignmentLeft;
        self.parkNameLab = parkNameLab;
        [headerView addSubview:parkNameLab];
        
        UILabel *distanceLab = [UILabel new];
        distanceLab.font = [UIFont systemFontOfSize:12];
        distanceLab.textColor = [UIColor blackColor];
        distanceLab.textAlignment = NSTextAlignmentRight;
        self.distanceLab = distanceLab;
        [headerView addSubview:distanceLab];
        
        UILabel *parkingSpacesLab = [UILabel new];
        parkingSpacesLab.font = [UIFont systemFontOfSize:12];
        parkingSpacesLab.textColor = [UIColor blackColor];
        parkingSpacesLab.textAlignment = NSTextAlignmentLeft;
        self.parkingSpacesLab = parkingSpacesLab;
        [headerView addSubview:parkingSpacesLab];
        
        UILabel *troduceLab = [UILabel new];
        troduceLab.font = [UIFont systemFontOfSize:12];
        troduceLab.textColor = [UIColor blackColor];
        troduceLab.textAlignment = NSTextAlignmentRight;
        self.troduceLab = troduceLab;
        [headerView addSubview:troduceLab];
        
        UIButton *routeBtn = [UIButton new];
        [routeBtn addTarget:self action:@selector(routeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [routeBtn setImage:[UIImage imageNamed:@"icon_park_route"] forState:UIControlStateNormal];
        [routeBtn setTitle:@"路线" forState:UIControlStateNormal];
        [routeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [routeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.routeBtn = routeBtn;
        [_contentView addSubview:routeBtn];
        
        UIButton *navigationBtn = [UIButton new];
        [navigationBtn addTarget:self action:@selector(beginNavAction:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBtn setImage:[UIImage imageNamed:@"icon_park_navigation"] forState:UIControlStateNormal];
        [navigationBtn setTitle:@"导航" forState:UIControlStateNormal];
        [navigationBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [navigationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.navigationBtn = navigationBtn;
        [_contentView addSubview:navigationBtn];
        
        UIView *verSepView = [UIView new];
        verSepView.backgroundColor = [UIColor lightGrayColor];
        self.verSepView = verSepView;
        [_contentView addSubview:verSepView];
        
        UIView *horSepView = [UIView new];
        horSepView.backgroundColor = [UIColor lightGrayColor];
        self.horSepView = horSepView;
        [_contentView addSubview:horSepView];
        
        self.headerView.sd_layout
        .topSpaceToView(_contentView, 0)
        .leftSpaceToView(_contentView, 0)
        .rightSpaceToView(_contentView, 0)
        .heightIs(126);
        
        self.coverImageView.sd_layout
        .topSpaceToView(_headerView, 10)
        .leftSpaceToView(_headerView, 10)
        .widthIs(120)
        .heightIs(80);
        
        self.parkNameLab.sd_layout
        .topSpaceToView(_headerView, 15)
        .leftSpaceToView(self.coverImageView, 10)
        .rightSpaceToView(_headerView, 10)
        .heightIs(20);
        
        self.parkingSpacesLab.sd_layout
        .topSpaceToView(self.coverImageView, 10)
        .leftSpaceToView(_headerView, 10)
        .widthIs(150)
        .heightIs(16);
        
        self.troduceLab.sd_layout
        .topEqualToView(self.parkingSpacesLab)
        .rightSpaceToView(_headerView, 10)
        .widthIs(120)
        .heightIs(16);
        
        self.distanceLab.sd_layout
        .bottomSpaceToView(self.troduceLab, 10)
        .rightSpaceToView(_headerView, 10)
        .widthIs(120)
        .heightIs(16);
        
        self.verSepView.sd_layout
        .topSpaceToView(_headerView, 0)
        .leftSpaceToView(_contentView, 0)
        .rightSpaceToView(_contentView, 0)
        .heightIs(0.5);
        
        self.routeBtn.sd_layout
        .topSpaceToView(_verSepView, 0)
        .leftSpaceToView(_contentView, 0)
        .bottomSpaceToView(_contentView, 0)
        .widthIs(KScreenWidth/2-0.5);
        
        self.horSepView.sd_layout
        .topSpaceToView(self.verSepView, 0)
        .bottomSpaceToView(_contentView, 0)
        .widthIs(0.5)
        .leftSpaceToView(self.routeBtn, 0);
        
        self.navigationBtn.sd_layout
        .leftSpaceToView(self.horSepView, 0)
        .rightSpaceToView(_contentView, 0)
        .topSpaceToView(self.verSepView, 0)
        .bottomSpaceToView(_contentView, 0);
        
    }
}

-(void)setModel:(AnnotationModel *)model
{
    _model = model;
    
    NSString* photoString = [_model.parkPhotoid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:photoString]];
    
    NSString *parkNum = [NSString stringWithFormat:@"%@",model.parkIdle];
    
    NSString *parkTotalNum = [NSString stringWithFormat:@"%@",model.parkCapacity];
    
    NSMutableAttributedString *_parkingSpacesStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"空闲数：%@/%@",parkNum,parkTotalNum]];
    
    [_parkingSpacesStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, parkNum.length)];
    
    [_parkingSpacesStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4 + parkNum.length + 1, parkTotalNum.length)];
    
    _parkingSpacesLab.attributedText = _parkingSpacesStr;
    
    _parkNameLab.text = _model.parkName;
    
    _distanceLab.text = [NSString stringWithFormat:@"%@m",_model.distance];
    
    _troduceLab.text = _model.parkFeedesc;
    
}

#pragma mark 路线规划

-(void)routeBtnAction:(UIButton *)sender
{
    ZTMapViewCtrl *mapViewCtrl = (ZTMapViewCtrl *)[self viewController];
    
    NSString *parklat = [NSString stringWithFormat:@"%@",_model.parkLat];
    NSMutableString *parkLatStr = [NSMutableString stringWithString:parklat];
    [parkLatStr insertString:@"." atIndex:2];
    
    NSString *parklng = [NSString stringWithFormat:@"%@",_model.parkLng];
    NSMutableString *parkLngStr = [NSMutableString stringWithString:parklng];
    [parkLngStr insertString:@"." atIndex:3];

    
    AMapNaviPoint *point = [AMapNaviPoint locationWithLatitude:[parkLatStr floatValue] longitude:[parkLngStr floatValue]];
    [mapViewCtrl routePlanAction:point];
    
}

-(void)beginNavAction:(UIButton *)sender
{
    ZTMapViewCtrl *mapViewCtrl = (ZTMapViewCtrl *)[self viewController];
    
    NSString *parklat = [NSString stringWithFormat:@"%@",_model.parkLat];
    NSMutableString *parkLatStr = [NSMutableString stringWithString:parklat];
    [parkLatStr insertString:@"." atIndex:2];
    
    NSString *parklng = [NSString stringWithFormat:@"%@",_model.parkLng];
    NSMutableString *parkLngStr = [NSMutableString stringWithString:parklng];
    [parkLngStr insertString:@"." atIndex:3];
    
    
    AMapNaviPoint *point = [AMapNaviPoint locationWithLatitude:[parkLatStr floatValue] longitude:[parkLngStr floatValue]];
    [mapViewCtrl beginNavAction:point];
}

- (void)loadMaskView
{
}

//展示从底部向上弹出的UIView
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(10, KScreenHeight, KScreenWidth-20, 190)];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(10, KScreenHeight - 200, KScreenWidth-20, 190)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(10, KScreenHeight - 200, KScreenWidth-20, 190)];
    [UIView animateWithDuration:0
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(10, KScreenHeight, KScreenWidth-20, 190)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}

-(void)tapGestureAction:(id)sender
{
    ParkDetailCtrl *parkDetailCtrl = [[ParkDetailCtrl alloc] init];
    UIViewController *viewCtrl = [self viewController];
    parkDetailCtrl.parkId = _model.parkId;
    parkDetailCtrl.model = _model;
    [viewCtrl.navigationController pushViewController:parkDetailCtrl animated:YES];
}

@end
