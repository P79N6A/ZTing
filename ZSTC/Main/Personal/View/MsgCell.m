//
//  MsgCell.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMsgModel:(MsgModel *)msgModel {
    _msgModel = msgModel;
    
    _titleLabel.text = msgModel.pushTitle;
    _contentLabel.text = msgModel.pushContent;
    _timeLabel.text = msgModel.agoTime;
}

@end
