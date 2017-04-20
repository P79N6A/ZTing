//
//  UIBarButtonItem+JExtension.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
