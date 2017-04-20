//
//  UIImage+ScaleImage.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/17.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleImage)

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end
