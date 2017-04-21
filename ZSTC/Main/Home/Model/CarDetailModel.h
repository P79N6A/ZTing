//
//  CarDetailModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface CarDetailModel : BaseModel
/*
{
    "traceId": "2017042008241450000073000071111130",
    "orderId": null,
    "differStr": "2小时40分钟",
    "startTime": "2017-04-20 08:24:14",
    "endTime": "2017-04-20 11:04:37",
    "freeTime": "0",
    "fee": "0.0",
    "differ": "160",
    "parkName": "通服天园停车场",
    "traceInphoto": "http://115.29.51.72:9081/file/park/hzcl/2017420/湘C521A7-2017-04-20-08-24-14-b.jpg",
    "parkFeedesc": "暂不收费"
 }
 */

@property (nonatomic, copy) NSString *traceId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *differStr;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *freeTime;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *differ;
@property (nonatomic, copy) NSString *parkName;
@property (nonatomic, copy) NSString *traceInphoto;
@property (nonatomic, copy) NSString *parkFeedesc;
    
@end
