//
//  MsgCell.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface MsgCell : UITableViewCell
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_contentLabel;
}
@property (nonatomic, retain) MsgModel *msgModel;
@end
