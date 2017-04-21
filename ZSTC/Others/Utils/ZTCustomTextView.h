//
//  ZTCustomTextView.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTCustomTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
