//
//  HisDetailViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "HisDetailViewController.h"

@interface HisDetailViewController ()
{
    __weak IBOutlet UILabel *_carNoLabel;
    __weak IBOutlet UILabel *_parkLabel;
    __weak IBOutlet UILabel *_longTimeLabel;
    
    __weak IBOutlet UILabel *_inTimeLabel;
    __weak IBOutlet UIImageView *_inImageView;
    __weak IBOutlet UILabel *_outTimeLabel;
    __weak IBOutlet UIImageView *_outImageView;
    __weak IBOutlet UILabel *_shouldCostLabel;  // 应缴费用
    
    __weak IBOutlet UILabel *_payTypeLabel; // 支付方式
    __weak IBOutlet UILabel *_payTypeCostLabel; // 支付方式支付的金额
    __weak IBOutlet UILabel *_payCostLabel; // 实际缴费金额
}
@end

@implementation HisDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    _carNoLabel.text = _historyModel.traceCarno;
    
    _parkLabel.text = _historyModel.traceParkname;
    
    int time = _historyModel.traceTime.intValue;
    _longTimeLabel.text = [NSString stringWithFormat:@"%.0d小时%.0d分钟",  time/60, (int)time%60];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *beginDate = [formater dateFromString:_historyModel.traceBegin];
    NSDate *endDate = [formater dateFromString:_historyModel.traceEnd];
    NSDateFormatter *newFormater = [[NSDateFormatter alloc] init];
    [newFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *beginTime = [newFormater stringFromDate:beginDate];
    NSString *endTime = [newFormater stringFromDate:endDate];
    _inTimeLabel.text = beginTime;
    _outTimeLabel.text = endTime;
    
    if(_historyModel.traceInphoto != nil && ![_historyModel.traceInphoto isKindOfClass:[NSNull class]] && _historyModel.traceInphoto.length > 0){
        NSString *utf_8UrlString = [_historyModel.traceInphoto stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [_inImageView sd_setImageWithURL:[NSURL URLWithString:utf_8UrlString] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }
    
    if(_historyModel.traceOutphoto != nil && ![_historyModel.traceOutphoto isKindOfClass:[NSNull class]] && _historyModel.traceOutphoto.length > 0){
        NSString *utf_8UrlString = [_historyModel.traceOutphoto stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [_outImageView sd_setImageWithURL:[NSURL URLWithString:utf_8UrlString] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }
    
    _shouldCostLabel.text = [NSString stringWithFormat:@"%.2f元",(_historyModel.traceCash.floatValue + _historyModel.traceNotcash.floatValue)/100];
    
    _payCostLabel.text = [NSString stringWithFormat:@"%.2f元",_historyModel.traceParkamt.floatValue/100];
    
}

#pragma mark UITableView 协议
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 100;
            break;
            
        case 1:
            return 450;
            break;
            
        case 2:
            return 80;
            break;
            
    }
    return 0;
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
