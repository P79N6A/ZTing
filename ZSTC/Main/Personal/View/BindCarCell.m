//
//  BindCarCell.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/12.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BindCarCell.h"

@implementation BindCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setBindCarModel:(BindCarModel *)bindCarModel {
    _bindCarModel = bindCarModel;
    if(bindCarModel.carNo != nil && ![bindCarModel.carNo isKindOfClass:[NSNull class]] && bindCarModel.carNo.length > 0) {
        _numLabel.text = bindCarModel.carNo;
    }
    if(bindCarModel.carNike != nil && ![bindCarModel.carNike isKindOfClass:[NSNull class]] && bindCarModel.carNike.length > 0) {
        _carNameLabel.text = bindCarModel.carNike;
    }
    if([bindCarModel.carAutoPay isEqualToString:@"0"]){
        // 关闭
        _paySwitch.on = NO;
    }else {
        // 开启
        _paySwitch.on = YES;
    }
}

- (IBAction)paySwitch:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    NSString *state = @"";
    if(sw.on){
        state = @"1";
    }else {
        state = @"0";
    }
    [[self viewController] showHudInView:[self viewController].view hint:@""];
    NSString *changePayUrl = [NSString stringWithFormat:@"%@member/updateCarAuto", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:_bindCarModel.carNo forKey:@"carNo"];
    [params setObject:state forKey:@"carAutoPay"];
    [[ZTNetworkClient sharedInstance] POST:changePayUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [[self viewController] hideHud];
        if(![responseObject[@"success"] boolValue]){
            [sw setOn:!sw.on animated:YES];
        }
//        [self.viewController showHint:responseObject[@"message"]];
    } failure:^(NSError *error) {
        [[self viewController] hideHud];
        [sw setOn:!sw.on animated:YES];
    }];
    
}


@end
