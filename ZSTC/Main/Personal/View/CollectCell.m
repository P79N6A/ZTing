//
//  CollectCell.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "CollectCell.h"

@implementation CollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    _routeBt.layer.borderColor = [UIColor grayColor].CGColor;
    _routeBt.layer.borderWidth = 0.5;
    _navBt.layer.borderColor = [UIColor grayColor].CGColor;
    _navBt.layer.borderWidth = 0.5;
    
    _routeBtWidth.constant = KScreenWidth/2;
    _navBtWidth.constant = KScreenWidth/2;
    
    _parkImageView.contentMode = UIViewContentModeScaleAspectFill;
    _parkImageView.clipsToBounds = YES;
}

- (void)setCollectModel:(CollectModel *)collectModel {
    _collectModel = collectModel;
    
    if(collectModel.parkPhotoid != nil && ![collectModel.parkPhotoid isKindOfClass:[NSNull class]] && collectModel.parkPhotoid.length > 0) {
        NSString *utf_8UrlString = [collectModel.parkPhotoid stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [_parkImageView sd_setImageWithURL:[NSURL URLWithString:utf_8UrlString]];
    }
    
    _parkLabel.text = collectModel.parkName;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", collectModel.parkIdle, collectModel.parkCapacity]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, collectModel.parkIdle.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(collectModel.parkIdle.length + 1, collectModel.parkCapacity.length)];
    _numLabel.attributedText = attributeStr;
    
    NSString *levelStr;
    UIColor *levelColor;
    if([collectModel.parkFeelevel isEqualToString:@"0"]){
        levelStr = @"便宜";
        levelColor = [UIColor greenColor];
    }
    else if([collectModel.parkFeelevel isEqualToString:@"1"]){
        levelStr = @"适中";
        levelColor = [UIColor orangeColor];
    }
    else if([collectModel.parkFeelevel isEqualToString:@"2"]){
        levelStr = @"偏贵";
        levelColor = [UIColor redColor];
    }
    NSMutableAttributedString *levelAtrStr = [[NSMutableAttributedString alloc] initWithString:levelStr];
    [levelAtrStr addAttribute:NSForegroundColorAttributeName value:levelColor range:NSMakeRange(0, levelStr.length)];
    _costLabel.attributedText = levelAtrStr;
}

// 路线
- (IBAction)routeAction:(id)sender {
    [_delegate routePark:_collectModel.collectParkid];
}

// 导航
- (IBAction)navAction:(id)sender {
    [_delegate navPark:_collectModel.collectParkid];
}


@end
