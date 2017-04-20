//
//  MsgModel.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "MsgModel.h"
#import <NSDate+TimeAgo.h>

@implementation MsgModel

- (instancetype)initWithDataDic:(NSDictionary *)data {
    self = [super initWithDataDic:data];
    if(self){
        NSString *pushTime = data[@"pushTime"];
        if(pushTime != nil && ![pushTime isKindOfClass:[NSNull class]] && pushTime.length > 0){
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *pushDate = [formater dateFromString:pushTime];
            
            NSDateFormatter *newFormater = [[NSDateFormatter alloc] init];
            [newFormater setDateFormat:@"yyyy-MM-dd"];
            
            NSString *timeString = [pushDate timeAgoWithLimit:24*60*60*3 dateFormatter:newFormater];
            
            self.agoTime = timeString;
        }
    }
    return self;
}

@end
