//
//  parkCommentModel.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "parkCommentModel.h"

@implementation parkCommentModel


- (instancetype)initWithDataDic:(NSDictionary *)data {
    self = [super initWithDataDic:data];
    if(self){
        // 开始记录时间
        NSString *carCtime = data[@"commentCommentTime"];
        if(carCtime != nil && ![carCtime isKindOfClass:[NSNull class]] && carCtime.length > 0){
            self.commentCommentTime = [self timeWithTimeIntervalString:carCtime];
        }else {
            self.commentCommentTime = @"";
        }
        
    }
    return self;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSString *year = [timeString substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [timeString substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [timeString substringWithRange:NSMakeRange(6, 2)];
    NSString *hour = [timeString substringWithRange:NSMakeRange(8, 2)];
    NSString *minute = [timeString substringWithRange:NSMakeRange(10, 2)];
    NSString *second = [timeString substringWithRange:NSMakeRange(12, 2)];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", year, month, day, hour, minute, second];
    return timeStr;
}

@end
