//
//  PaySelfViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/20.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "PaySelfViewController.h"
#import "PaySelfModel.h"
#import "SelCarNoView.h"
#import "PayTypeView.h"

@interface PaySelfViewController ()
{
    __weak IBOutlet UIView *_carInfoView;

    __weak IBOutlet UITextField *_provinceTF;
    __weak IBOutlet UITextField *_letterTF;
    __weak IBOutlet UITextField *_numTF;
    __weak IBOutlet UIButton *_selBt;
    __weak IBOutlet UIButton *_queryBt;
    
    __weak IBOutlet UIView *_carStateView;
    __weak IBOutlet UIImageView *_carImgView;
    __weak IBOutlet UILabel *_parkNameLabel;
    __weak IBOutlet UILabel *_inTimeLabel;
    __weak IBOutlet UILabel *_longTimeLabel;
    __weak IBOutlet UILabel *_costLabel;
    __weak IBOutlet UILabel *_cardLabel;
    __weak IBOutlet UILabel *_payMoneyLabel;
    __weak IBOutlet UIButton *_payBt;
    
    UIView *_ruleView;  // 缴费规则
    
    PaySelfModel *_paySelfModel;
    
    SelCarNoView *_selCarNoView;  // 选择车牌
    
    PayTypeView *_payTypeView;   // 支付
}
@end

@implementation PaySelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    if(_carNo != nil && _carNo.length > 0){
        [self _loadData:_carNo];
    }
}

- (void)_initView {
    self.title = @"自助缴费";
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    _carImgView.contentMode = UIViewContentModeScaleAspectFill;
    _carImgView.clipsToBounds = YES;
    
    _carStateView.hidden = YES;
    
    _selBt.layer.masksToBounds = YES;
    _selBt.layer.cornerRadius = 4;
    
    _queryBt.layer.masksToBounds = YES;
    _queryBt.layer.cornerRadius = 4;
    
    _payBt.layer.masksToBounds = YES;
    _payBt.layer.cornerRadius = 4;
    
    // 计费规则
    _ruleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _ruleView.hidden = YES;
    _ruleView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    [self.view addSubview:_ruleView];
    
    UIView *ruleBgView = [[UIView alloc] initWithFrame:CGRectMake(20, (KScreenHeight - 80)/2, KScreenWidth - 40, 130)];
    ruleBgView.backgroundColor = [UIColor whiteColor];
    [_ruleView addSubview:ruleBgView];
    
    UILabel *ruleTielLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 120, 22)];
    ruleTielLabel.text = @"计费规则";
    ruleTielLabel.textColor = [UIColor blackColor];
    ruleTielLabel.font = [UIFont systemFontOfSize:19];
    ruleTielLabel.textAlignment = NSTextAlignmentLeft;
    [ruleBgView addSubview:ruleTielLabel];

    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, ruleTielLabel.bottom + 10, ruleBgView.width - 16, 20)];
    ruleLabel.tag = 201;
    ruleLabel.textColor = [UIColor grayColor];
    ruleLabel.font = [UIFont systemFontOfSize:15];
    ruleLabel.textAlignment = NSTextAlignmentLeft;
    [ruleBgView addSubview:ruleLabel];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, ruleBgView.height - 45, ruleBgView.width, 45);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.backgroundColor = MainColor;
    [closeButton addTarget:self action:@selector(closeRule) forControlEvents:UIControlEventTouchUpInside];
    [ruleBgView addSubview:closeButton];
    
    // 选择车牌
    _selCarNoView = [[SelCarNoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _selCarNoView.hidden = YES;
    [self.view addSubview:_selCarNoView];
    
}

- (void)closeRule {
    _ruleView.hidden = YES;
}

#pragma mark 根据车牌查询详细信息
- (void)_loadData:(NSString *)carNo {
    NSString *findCarUrl = [NSString stringWithFormat:@"%@pay/findFeeByCarNo", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:carNo forKey:@"carNo"];
    [params setObject:@"0" forKey:@"carType"];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:findCarUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            _paySelfModel = [[PaySelfModel alloc] initWithDataDic:responseObject[@"data"]];
            [self uploadView:_paySelfModel];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
    
}

- (void)uploadView:(PaySelfModel *)paySelfModel {
    _carStateView.hidden = NO;
    
    UILabel *ruleLabel = [_ruleView viewWithTag:201];
    ruleLabel.text = paySelfModel.parkFeedesc;
    
    if(paySelfModel.traceInphoto != nil && ![paySelfModel.traceInphoto isKindOfClass:[NSNull class]] && paySelfModel.traceInphoto.length > 0){
        NSString *utf_8UrlString = [paySelfModel.traceInphoto stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [_carImgView sd_setImageWithURL:[NSURL URLWithString:utf_8UrlString] placeholderImage:[UIImage imageNamed:@"icon_no_picture"]];
    }
    
    _parkNameLabel.text = paySelfModel.parkName;
    _inTimeLabel.text = paySelfModel.startTime;
    _longTimeLabel.text = paySelfModel.differStr;
    _costLabel.text = [NSString stringWithFormat:@"%.2f元", paySelfModel.fee.floatValue/100.2f];
    _cardLabel.text = @"未使用";
    
    _payMoneyLabel.text = [NSString stringWithFormat:@"%.2f元", paySelfModel.fee.floatValue/100.2f];
    
}

#pragma mark 规则
- (IBAction)payRule:(id)sender {
    _ruleView.hidden = NO;
}

#pragma mark 选取按钮
- (IBAction)selCarNo:(id)sender {
    _selCarNoView.hidden = NO;
}

#pragma mark 查询按钮
- (IBAction)queryCar:(id)sender {
}

#pragma mark 缴费按钮
- (IBAction)payMoney:(id)sender {
    if(_paySelfModel.fee.floatValue == 0) {
        [self showHint:@"当前不需要缴费"];
    }else {
        
    }
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
