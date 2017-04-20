//
//  BillCell.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@interface HistoryCell : UITableViewCell
{
    __weak IBOutlet UIView *_bgView;

    __weak IBOutlet UILabel *_parkNameLabel;
    __weak IBOutlet UILabel *_inTimeLabel;
    __weak IBOutlet UILabel *_outTimeLabel;
    __weak IBOutlet UILabel *_lognTimeLabel;
    __weak IBOutlet UILabel *_costLabel;
}

@property (nonatomic, retain) HistoryModel *historyModel;
@end
