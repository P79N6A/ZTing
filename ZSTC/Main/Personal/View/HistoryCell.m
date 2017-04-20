//
//  BillCell.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
}

- (void)setHistoryModel:(HistoryModel *)historyModel {
    _historyModel = historyModel;
    
    _parkNameLabel.text = historyModel.traceParkname;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *beginDate = [formater dateFromString:historyModel.traceBegin];
    NSDate *endDate = [formater dateFromString:historyModel.traceEnd];
    
    NSDateFormatter *newFormater = [[NSDateFormatter alloc] init];
    [newFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *beginTime = [newFormater stringFromDate:beginDate];
    NSString *endTime = [newFormater stringFromDate:endDate];
    
    _inTimeLabel.text = [NSString stringWithFormat:@"进场时间: %@", beginTime];
    
    _outTimeLabel.text = [NSString stringWithFormat:@"离场时间: %@", endTime];
    
    int time = historyModel.traceTime.intValue;
    _lognTimeLabel.text = [NSString stringWithFormat:@"%@%.0d小时%.0d分钟", @"停车时长: ",  time/60, (int)time%60];
    
    _costLabel.text = [NSString stringWithFormat:@"%@%.2f元", @"停车缴费: ",  historyModel.traceParkamt.floatValue/100];
}

@end
