//
//  AdvModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface AdvModel : BaseModel
/*
 {
     "topicId": 1,
     "topicTitle": "红包",
     "topicStatus": "2",
     "topicPhoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/yunpark/common/20160523/??????????.png",
     "topicSpecial": "0",
     "topicType": "0",
     "topicUrl": "",
     "addUserId": "0000000000000000000000000000001",
     "addDatetime": "20160523173909",
     "topicContent": ""
     }
 */

@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *topicStatus;
@property (nonatomic, copy) NSString *topicPhoto;
@property (nonatomic, copy) NSString *topicSpecial;
@property (nonatomic, copy) NSString *topicType;
@property (nonatomic, copy) NSString *topicUrl;
@property (nonatomic, copy) NSString *addUserId;
@property (nonatomic, copy) NSString *addDatetime;
@property (nonatomic, copy) NSString *topicContent;

@end
