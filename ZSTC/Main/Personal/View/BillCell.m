//
//  BillCell.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BillCell.h"
#import "NSDate+Category.h"

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    _bgView.layer.borderWidth = 0.5;
//    _bgView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
}

- (void)setBillInfoModel:(BillInfoModel *)billInfoModel {
    _billInfoModel = billInfoModel;
    
    if(billInfoModel.assetsLogAddtime != nil && ![billInfoModel.assetsLogAddtime isKindOfClass:[NSNull class]] && billInfoModel.assetsLogAddtime.length > 4){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *billDate = [format dateFromString:billInfoModel.assetsLogAddtime];
        
        NSString *dateStr = [format stringFromDate:billDate];
        
        NSString *billDateStr = [NSString stringWithFormat:@"%@-%@", [dateStr substringWithRange:NSMakeRange(4, 2)], [dateStr substringWithRange:NSMakeRange(6, 2)]];
        _dateLabel.text = billDateStr;
        
        // 对比时间差
        NSDateComponents *_comps = [[NSDateComponents alloc] init];
        [_comps setDay:billDate.day];
        [_comps setMonth:billDate.month];
        [_comps setYear:billDate.year];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDate *_date = [gregorian dateFromComponents:_comps];
        NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
        NSInteger _weekday = [weekdayComponents weekday];
        
        _weekLabel.text = [NSString stringWithFormat:@"星期%@", [self weekStr:_weekday - 1]];
    }
    

    _numLabel.text = [NSString stringWithFormat:@"%.2f", billInfoModel.assetsAfter.floatValue - billInfoModel.assetsLast.floatValue];
    
    // 变动类型 1：充值入账 2：红包入账 3:账户停车消费 4：红包停车消费 5：其他消费 6:会员卡消费
    switch ([billInfoModel.assetsChangeType integerValue]) {
        case 1:
            _infoLabel.text = @"充值入账";
            break;
            
        case 2:
            _infoLabel.text = @"红包入账";
            break;
            
        case 3:
            _infoLabel.text = @"账户停车消费";
            break;
            
        case 4:
            _infoLabel.text = @"红包停车消费";
            break;
            
        case 5:
            _infoLabel.text = @"其他消费";
            break;
            
        case 6:
            _infoLabel.text = @"会员卡消费";
            break;

    }
    
}

- (NSString *)weekStr:(NSInteger)day {
    switch (day) {
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 7:
            return @"日";
            break;
            
        default:
            break;
    }
    return @"";
}


@end
