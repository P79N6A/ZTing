//
//  MsgModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface MsgModel : BaseModel
/*
{
    "pushId": "4028e44254c69ee10154cd36bfa00070",
    "pushMember": "4028e44254c7b5a80154cc487a2f013e",
    "pushEquit": "",
    "pushType": "3",
    "pushTitle": "会员登录",
    "pushContent": "155***6835用户在2016-06-01 12:30登录2",
    "pushTime": "20160601123023",
    "pushStatus": "0",
    "pushMessageIndex": ""
}
 */

@property (nonatomic, copy) NSString *pushId;
@property (nonatomic, copy) NSString *pushMember;
@property (nonatomic, copy) NSString *pushEquit;
@property (nonatomic, copy) NSString *pushType;
@property (nonatomic, copy) NSString *pushTitle;
@property (nonatomic, copy) NSString *pushContent;
@property (nonatomic, copy) NSString *pushTime;
@property (nonatomic, copy) NSString *pushStatus;
@property (nonatomic, copy) NSString *pushMessageIndex;

@property (nonatomic, copy) NSString *agoTime;  // 几小时前

@end
