//
//  BillCell.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/13.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BillInfoModel.h"

@interface BillCell : UITableViewCell
{
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UILabel *_weekLabel;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UILabel *_numLabel;
    __weak IBOutlet UILabel *_infoLabel;

    __weak IBOutlet UIImageView *_billImageView;
}

@property (nonatomic, retain) BillInfoModel *billInfoModel;

@end
