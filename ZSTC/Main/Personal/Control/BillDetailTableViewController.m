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
    __weak IBOutlet UILabel *vipLab;
    __weak IBOutlet UILabel *payselfLab;
    __weak IBOutlet UILabel *_payNumLabel;
    __weak IBOutlet UILabel *_payStateLabel;
    __weak IBOutlet UILabel *_payType;
    __weak IBOutlet UILabel *_vipNumLabel;
    __weak IBOutlet UILabel *_paySelfNumLabel;
    __weak IBOutlet UILabel *explainLab;
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
    
    //支付方式 000：现金 050:一卡通 200:微信 300:自助缴费 400:支付宝 800：会员卡 900：余额 100：银行卡
    NSString *type;
    if([_billInfoModel.payType isEqualToString:@"000"]) {
        type = @"现金";
    }else if([_billInfoModel.payType isEqualToString:@"050"]) {
        type = @"一卡通";
    }else if([_billInfoModel.payType isEqualToString:@"200"]) {
        type = @"微信";
    }else if([_billInfoModel.payType isEqualToString:@"300"]) {
        type = @"自助缴费";
    }else if([_billInfoModel.payType isEqualToString:@"400"]) {
        type = @"支付宝";
    }else if([_billInfoModel.payType isEqualToString:@"800"]) {
        type = @"会员卡";
    }else if([_billInfoModel.payType isEqualToString:@"900"]) {
        type = @"余额";
    }else if([_billInfoModel.payType isEqualToString:@"100"]) {
        type = @"银行卡";
    }else{
        type = @"其他";
    }
    _payType.text = type;
    // 会员ID：4028e489559725280155972528a30000 自助缴费：17.0元
//    1.充值入账 2.红包入账 3.账户停车消费 4.红包停车消费 5.其他消费 6.会员卡消费
    if ([_billInfoModel.assetsChangeType isEqualToString:@"01"]||[_billInfoModel.assetsChangeType isEqualToString:@"02"]) {
        explainLab.hidden = NO;
        vipLab.hidden = YES;
        payselfLab.hidden = YES;
        _vipNumLabel.hidden = YES;
        _paySelfNumLabel.hidden = YES;
        NSString *explainStr = [_billInfoModel.assetsRemark componentsSeparatedByString:@" "].lastObject;
        explainLab.text = [explainStr componentsSeparatedByString:@"："].lastObject;
        
    }else if([_billInfoModel.assetsChangeType isEqualToString:@"3"]||[_billInfoModel.assetsChangeType isEqualToString:@"04"]||[_billInfoModel.assetsChangeType isEqualToString:@"5"]||[_billInfoModel.assetsChangeType isEqualToString:@"06"]){
        explainLab.hidden = YES;
        vipLab.hidden = NO;
        payselfLab.hidden = NO;
        _vipNumLabel.hidden = NO;
        _paySelfNumLabel.hidden = NO;
        
        NSString *vipStr = [_billInfoModel.assetsRemark componentsSeparatedByString:@" "].firstObject;
        _vipNumLabel.text = [vipStr componentsSeparatedByString:@"："].lastObject;
        
        NSString *paySelfStr = [_billInfoModel.assetsRemark componentsSeparatedByString:@" "].lastObject;
        _paySelfNumLabel.text = [paySelfStr componentsSeparatedByString:@"："].lastObject;
    }else{
        
    }
    
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
