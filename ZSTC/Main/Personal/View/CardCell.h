//
//  CardCell.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardModel.h"

@interface CardCell : UITableViewCell
{
    __weak IBOutlet UILabel *_cardNameLabel;
    __weak IBOutlet UILabel *_scopeLabel;
    __weak IBOutlet UILabel *_attentionLabel;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_numLabel;
}

@property (nonatomic, retain) CardModel *cardModel;

@end
