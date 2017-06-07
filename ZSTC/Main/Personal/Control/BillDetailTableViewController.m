//
//  BillDetailTableViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/21.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "BillDetailTableViewController.h"

@interface BillDetailTableViewController ()
{
    __weak IBOutlet UILabel *_payNumLabel;
    __weak IBOutlet UILabel *_payStateLabel;
    __weak IBOutlet UILabel *_payType;
    __weak IBOutlet UILabel *_vipNumLabel;
    __weak IBOutlet UILabel *_paySelfNumLabel;

    __weak IBOutlet UILabel *_payTimeLabel;
}
@end

@implementation BillDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
    self.title = @"账单详情";
    
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [UIView new];
    
    _payNumLabel.text = [NSString stringWithFormat:@"%.2f", _billInfoModel.assetsAfter.floatValue - _billInfoModel.assetsLast.floatValue];
    _payStateLabel.text = @"交易成功";
    
    //支付方式 00：支付宝 01：微信 02：App Pay 04 ： 现金
    NSString *type;
    if([_billInfoModel.payType isEqualToString:@"00"]) {
        type = @"支付宝";
    }else if([_billInfoModel.payType isEqualToString:@"01"]) {
        type = @"微信";
    }else if([_billInfoModel.payType isEqualToString:@"04"]) {
        type = @"现金";
    }else{
        type = @"余额";
    }
    _payType.text = type;
    // 会员ID：4028e489559725280155972528a30000 自助缴费：17.0元
    
    NSString *vipStr = [_billInfoModel.assetsRemark componentsSeparatedByString:@" "].firstObject;
    _vipNumLabel.text = [vipStr componentsSeparatedByString:@"："].lastObject;
    
    NSString *paySelfStr = [_billInfoModel.assetsRemark componentsSeparatedByString:@" "].lastObject;
    _paySelfNumLabel.text = [paySelfStr componentsSeparatedByString:@"："].lastObject;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *payDate = [formater dateFromString:_billInfoModel.assetsLogAddtime];
    NSDateFormatter *newFormater = [[NSDateFormatter alloc] init];
    [newFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *payTime = [newFormater stringFromDate:payDate];
    _payTimeLabel.text = payTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
