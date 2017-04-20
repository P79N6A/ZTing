//
//  BillModel.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BillModel.h"

#import "BillInfoModel.h"

@implementation BillModel

- (instancetype)initWithDataDic:(NSDictionary *)data {
    self = [super initWithDataDic:data];
    if(self){
        NSArray *billData = data[@"data"];
        if(billData != nil && billData.count > 0){
            NSMutableArray *infoModels = @[].mutableCopy;
            [billData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BillInfoModel *billInfoModel = [[BillInfoModel alloc] initWithDataDic:obj];
                [infoModels addObject:billInfoModel];
            }];
            self.data = infoModels;
        }else {
            self.data = @[];
        }
        
    }
    return self;
}

@end
