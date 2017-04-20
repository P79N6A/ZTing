//
//  HistoryModel.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BaseModel.h"

@interface HistoryModel : BaseModel
/*
 {
 "traceIndex2": "2015072700000215000213013681",
 "traceAgentid": "000000000000",
 "traceAgentname": "平台运营商",
 "traceParkid": "4028e44254f1072b0154f1072b7a0000",
 "traceParkname": "时代总部停车场",
 "traceArea": "4028e44254f1072b0154f1072b7a0002",
 "traceInoperno": 50000016,
 "traceOutoperno": 50000016,
 "traceSeatcode1": "000001",
 "traceSeatno1": "0001",
 "traceBegin": "20160527082442",
 "traceEnd": "",
 "traceTime": null,
 "tracePreamt": 0,
 "traceParkamt": 0,
 "traceCash": 0,
 "traceNotcash": 0,
 "traceCartype": "0",
 "traceCarno": "HD5368",
 "traceCarnocolor": "蓝",
 "traceWarning": "",
 "traceMemberId": "4028e44254c69ee10154cd0bd4e6006d",
 "traceCardId": "4028e44254c7b5a80154cd0ce9080140",
 "traceSysbatch": "",
 "traceSystrace": "",
 "tracePaydate": "20160624155746",
 "traceSettledate": "1",
 "traceIngateid": "",
 "traceInphoto": "",
 "traceInsmallPhoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/park/hzcl/2016429/鄂A1F817-2016-04-29-08-27-05-s.jpg",
 "traceOutgateid": "",
 "traceOutphoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/park/hzcl/2016429/鄂A1F817-2016-04-29-09-06-56-b.jpg",
 "traceOutsmallPhoto": "http://tcb-yunpark.oss-cn-hangzhou.aliyuncs.com/park/hzcl/2016429/鄂A1F817-2016-04-29-08-27-05-s.jpg",
 "traceOuttype": "",
 "traceResult": "66",
 "traceInoperate": "",
 "traceOutoperate": "",
 "traceUpdatetime": "",
 "cardPhone": null,
 "cardExpdate": null
 }
 */

@property (nonatomic, copy) NSString *traceIndex2;
@property (nonatomic, copy) NSString *traceAgentid;
@property (nonatomic, copy) NSString *traceAgentname;
@property (nonatomic, copy) NSString *traceParkid;
@property (nonatomic, copy) NSString *traceParkname;
@property (nonatomic, copy) NSString *traceArea;
@property (nonatomic, copy) NSString *traceInoperno;
@property (nonatomic, copy) NSString *traceOutoperno;
@property (nonatomic, copy) NSString *traceSeatcode1;
@property (nonatomic, copy) NSString *traceSeatno1;
@property (nonatomic, copy) NSString *traceBegin;
@property (nonatomic, copy) NSString *traceEnd;
@property (nonatomic, strong) NSNumber *traceTime;
@property (nonatomic, strong) NSNumber *tracePreamt;
@property (nonatomic, strong) NSNumber *traceParkamt;
@property (nonatomic, strong) NSNumber *traceCash;
@property (nonatomic, strong) NSNumber *traceNotcash;
@property (nonatomic, copy) NSString *traceCartype;
@property (nonatomic, copy) NSString *traceCarno;
@property (nonatomic, strong) NSNumber *traceCarnocolor;
@property (nonatomic, copy) NSString *traceWarning;
@property (nonatomic, copy) NSString *traceMemberId;
@property (nonatomic, copy) NSString *traceCardId;
@property (nonatomic, copy) NSString *traceSysbatch;
@property (nonatomic, copy) NSString *traceSystrace;
@property (nonatomic, copy) NSString *tracePaydate;
@property (nonatomic, copy) NSString *traceSettledate;
@property (nonatomic, copy) NSString *traceIngateid;
@property (nonatomic, copy) NSString *traceInphoto;
@property (nonatomic, copy) NSString *traceInsmallPhoto;
@property (nonatomic, copy) NSString *traceOutgateid;
@property (nonatomic, copy) NSString *traceOutphoto;
@property (nonatomic, copy) NSString *traceOutsmallPhoto;
@property (nonatomic, copy) NSString *traceOuttype;
@property (nonatomic, copy) NSString *traceResult;
@property (nonatomic, copy) NSString *traceInoperate;
@property (nonatomic, copy) NSString *traceOutoperate;
@property (nonatomic, copy) NSString *traceUpdatetime;
@property (nonatomic, copy) NSString *cardPhone;
@property (nonatomic, copy) NSString *cardExpdate;


@end
