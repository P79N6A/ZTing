//
//  NSString+Date.h
//  ZSTC
//
//  Created by 焦平 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

+ (NSString *)created_at:(NSDate *)createDate;

- (NSString *)stringByTrim;

@end
