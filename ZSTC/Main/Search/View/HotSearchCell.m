//
//  HotSearchCell.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "HotSearchCell.h"

@implementation HotSearchCell

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
    UILabel *areaLab = [[UILabel alloc] init];
    areaLab.font = [UIFont systemFontOfSize:14];
    areaLab.textAlignment = NSTextAlignmentCenter;
    self.areaLab = areaLab;
    [self.contentView addSubview:areaLab];
    
    _areaLab.sd_layout
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0);
    
}

@end
