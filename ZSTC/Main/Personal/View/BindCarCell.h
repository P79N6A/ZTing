//
//  BindCarCell.h
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindCarModel.h"

@interface BindCarCell : UITableViewCell
{
    __weak IBOutlet UILabel *_numLabel;
    __weak IBOutlet UILabel *_carNameLabel;
    __weak IBOutlet UISwitch *_paySwitch;

}

@property (nonatomic, retain) BindCarModel *bindCarModel;

@end
