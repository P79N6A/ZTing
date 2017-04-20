//
//  ZTCustomAntionView.m
//  ZSTC
//
//  Created by 焦平 on 2017/3/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "ZTCustomAntionView.h"
#import "ZTAnnotation.h"
#import "AnnotationModel.h"

@interface ZTCustomAntionView()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ZTCustomAntionView

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    ZTAnnotation *ann = (ZTAnnotation *)annotation;
    AnnotationModel *model = ann.model;
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initializeAnnotation:model];
    }
    return self;
}

- (void)initializeAnnotation:(AnnotationModel *)model {
    [self setupAnnotation:model];
}

- (void)setupAnnotation:(AnnotationModel *)model {
    
    NSString *mask;
    if ([model.parkIdle floatValue]/[model.parkCapacity floatValue]<0.3) {
        mask = @"icon_map_icon_park_pay_busy";
    }else
    {
        mask = @"icon_map_icon_park_pay_idle";
    }
    
    CGRect frame = CGRectMake(0, 0, 30, 30);
    
    self.bounds = frame;
    self.backgroundImageView.image = [UIImage imageNamed:mask];
    self.backgroundImageView.frame = self.bounds;
    
}

- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    ZTAnnotation *ann = (ZTAnnotation *)self.annotation;
    AnnotationModel *model = ann.model;
    //当annotation滑出地图时候，即ann为nil时，不设置(否则由于枚举的类型会执行不该执行的方法)，只有annotation在地图范围内出现时才设置，可以打断点调试
    if (ann) {
        [self setupAnnotation:model];
    }
}

@end
