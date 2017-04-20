//
//  CardCell.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CardCell.h"

@implementation CardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCardModel:(CardModel *)cardModel {
    _cardModel = cardModel;
    
    _cardNameLabel.text = cardModel.couponName;
    
//    _scopeLabel.text =
    
    _attentionLabel.text = cardModel.couponRemarks;
    
    _numLabel.text = [NSString stringWithFormat:@"%@元", cardModel.couponCashbal];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *beginDate = [formater dateFromString:cardModel.couponStart];
    NSDate *endDate = [formater dateFromString:cardModel.couponEnd];
    
    NSDateFormatter *newFormater = [[NSDateFormatter alloc] init];
    [newFormater setDateFormat:@"yyyy-MM-dd"];
    
    NSString *beginTime = [newFormater stringFromDate:beginDate];
    NSString *endTime = [newFormater stringFromDate:endDate];
    
    _timeLabel.text = [NSString stringWithFormat:@"使用时间段: %@至%@", beginTime, endTime];
}

@end
