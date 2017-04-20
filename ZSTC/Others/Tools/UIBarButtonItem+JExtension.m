//
//  UIBarButtonItem+JExtension.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "UIBarButtonItem+JExtension.h"

@implementation UIBarButtonItem (JExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}

@end
