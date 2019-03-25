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
    
    if (![collectModel.parkName isKindOfClass:[NSNull class]]) {
        _parkLabel.text = collectModel.parkName;
    }
    
    if (![collectModel.parkIdle isKindOfClass:[NSNull class]]) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", collectModel.parkIdle, collectModel.parkCapacity]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, collectModel.parkIdle.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(collectModel.parkIdle.length + 1, collectModel.parkCapacity.length)];
        _numLabel.attributedText = attributeStr;
    }
    
    NSString *levelStr;
    UIColor *levelColor;
    if(![collectModel.parkFeelevel isKindOfClass:[NSNull class]]&&[collectModel.parkFeelevel isEqualToString:@"0"]){
        levelStr = @"便宜";
        levelColor = [UIColor greenColor];
    }else if(![collectModel.parkFeelevel isKindOfClass:[NSNull class]]&&[collectModel.parkFeelevel isEqualToString:@"1"]){
        levelStr = @"适中";
        levelColor = [UIColor orangeColor];
    }else if(![collectModel.parkFeelevel isKindOfClass:[NSNull class]]&&[collectModel.parkFeelevel isEqualToString:@"2"]){
        levelStr = @"偏贵";
        levelColor = [UIColor redColor];
    }else{
        levelStr = @"未知";
        levelColor = [UIColor greenColor];
    }
    NSMutableAttributedString *levelAtrStr = [[NSMutableAttributedString alloc] initWithString:levelStr];
    [levelAtrStr addAttribute:NSForegroundColorAttributeName value:levelColor range:NSMakeRange(0, levelStr.length)];
    _costLabel.attributedText = levelAtrStr;
}

-(void)setModel:(AnnotationModel *)model
{
    _model = model;
    if(model.parkPhotoid != nil && ![model.parkPhotoid isKindOfClass:[NSNull class]] && model.parkPhotoid.length > 0) {
        NSString *utf_8UrlString = [model.parkPhotoid stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [_parkImageView sd_setImageWithURL:[NSURL URLWithString:utf_8UrlString]];
    }
    
    if (![model.parkName isKindOfClass:[NSNull class]]) {
        _parkLabel.text = model.parkName;
    }
    
    if (![model.parkIdle isKindOfClass:[NSNull class]]) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", model.parkIdle, model.parkCapacity]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [model.parkIdle stringValue].length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([model.parkIdle stringValue].length + 1, [model.parkCapacity stringValue].length)];
        _numLabel.attributedText = attributeStr;
    }
    
    NSString *levelStr;
    UIColor *levelColor;
    if(![model.parkFeelevel isKindOfClass:[NSNull class]]&&[model.parkFeelevel isEqualToString:@"0"]){
        levelStr = @"便宜";
        levelColor = [UIColor greenColor];
    }
    else if(![model.parkFeelevel isKindOfClass:[NSNull class]]&&[model.parkFeelevel isEqualToString:@"1"]){
        levelStr = @"适中";
        levelColor = [UIColor orangeColor];
    }
    else if(![model.parkFeelevel isKindOfClass:[NSNull class]]&&[model.parkFeelevel isEqualToString:@"2"]){
        levelStr = @"偏贵";
        levelColor = [UIColor redColor];
    }else{
        levelStr = @"未知";
        levelColor = [UIColor greenColor];
    }
    NSMutableAttributedString *levelAtrStr = [[NSMutableAttributedString alloc] initWithString:levelStr];
    [levelAtrStr addAttribute:NSForegroundColorAttributeName value:levelColor range:NSMakeRange(0, levelStr.length)];
    _costLabel.attributedText = levelAtrStr;
}


// 路线
- (IBAction)routeAction:(id)sender {
    if (_collectModel) {
        [_delegate routePark:_collectModel.collectParkid];
    }
    
    if (_model) {
        [_delegate routePark:_model.parkId];
    }
}

// 导航
- (IBAction)navAction:(id)sender {
    
    if (_collectModel) {
        [_delegate navPark:_collectModel.collectParkid];
    }
    
    if (_model) {
        [_delegate navPark:_model.parkId];
    }
}


@end
