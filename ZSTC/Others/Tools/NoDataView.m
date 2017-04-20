//
//  NoDataView.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 60)/2, 80, 60, 90)];
    imgView.image = [UIImage imageNamed:@"icon_no_data"];
    [self addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom + 20, KScreenWidth, 30)];
    label.text = @"暂无数据";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];

}

@end
