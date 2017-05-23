//
//  NoNetWorkView.m
//  ZSTC
//
//  Created by 焦平 on 2017/5/23.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "NoNetWorkView.h"

@implementation NoNetWorkView
{
    UIImageView *_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = [UIColor whiteColor];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth - 200)/2, 60, 200, 200)];
    _imgView.image = [UIImage imageNamed:@"customvoice_networkerror"];
    
    [self addSubview:_imgView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
