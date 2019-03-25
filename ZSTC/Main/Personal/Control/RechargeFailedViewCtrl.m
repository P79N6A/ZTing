//
//  RechargeFailedViewCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/6/29.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "RechargeFailedViewCtrl.h"

@interface RechargeFailedViewCtrl ()
{
    
    __weak IBOutlet UILabel *_reasonLab;
}

@end

@implementation RechargeFailedViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"充值";
    
    _reasonLab.text = _reasonStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
