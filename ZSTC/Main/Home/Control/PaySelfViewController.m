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
#import "NoDataView.h"
#import "InputKeyBoardView.h"
#import "NumInputView.h"
#import "PaySucViewController.h"

#import "ZTAliPay.h"
#import "ZTWeChatPayTools.h"
#import "WXApi.h"

@interface PaySelfViewController ()<SelCarNoDelegate, SelPayDelegate>
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
    
    NoDataView *_noDataView;
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
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

    // 设置自定义键盘
    int verticalCount = 5;
    CGFloat kheight = KScreenWidth/10 + 8;
    InputKeyBoardView *keyBoardView = [[InputKeyBoardView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        if(_provinceTF.text.length <= 0){
            _provinceTF.text = [NSString stringWithFormat:@"%@%@", _provinceTF.text, character];
        }
        [_provinceTF resignFirstResponder];
        [_letterTF becomeFirstResponder];
    } withDelete:^{
        if(_provinceTF.text.length > 0){
            _provinceTF.text = [_provinceTF.text substringWithRange:NSMakeRange(0, _provinceTF.text.length - 1)];
        }
    }];
    _provinceTF.inputView = keyBoardView;
    
    NumInputView *letInputView = [[NumInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        if(_letterTF.text.length <= 0){
            _letterTF.text = [NSString stringWithFormat:@"%@%@", _letterTF.text, character];
        }
        [_letterTF resignFirstResponder];
        [_numTF becomeFirstResponder];
    } withDelete:^{
        if(_letterTF.text.length > 0){
            _letterTF.text = [_letterTF.text substringWithRange:NSMakeRange(0, _letterTF.text.length - 1)];
        }
    }];
    _letterTF.inputView = letInputView;
    
    NumInputView *numInputView = [[NumInputView alloc] initWithFrame:CGRectMake(0, KScreenHeight - kheight * verticalCount, KScreenWidth, kheight * verticalCount) withClickKeyBoard:^(NSString *character) {
        if(_numTF.text.length >= 5){
            [_numTF resignFirstResponder];
        }else {
            _numTF.text = [NSString stringWithFormat:@"%@%@", _numTF.text, character];
        }
    } withDelete:^{
        if(_numTF.text.length > 0){
            _numTF.text = [_numTF.text substringWithRange:NSMakeRange(0, _numTF.text.length - 1)];
        }
    }];
    _numTF.inputView = numInputView;
    
    _carImgView.contentMode = UIViewContentModeScaleAspectFill;
    _carImgView.clipsToBounds = YES;
    
    _carStateView.hidden = YES;
    
    _selBt.layer.masksToBounds = YES;
    _selBt.layer.cornerRadius = 4;
    
    _queryBt.layer.masksToBounds = YES;
    _queryBt.layer.cornerRadius = 4;
    
    _payBt.layer.masksToBounds = YES;
    _payBt.layer.cornerRadius = 4;
    
    // 无数据视图
    _noDataView = [[NoDataView alloc] initWithFrame:CGRectMake(0, _carInfoView.bottom, KScreenWidth, KScreenHeight - _carInfoView.bottom)];
    _noDataView.hidden = YES;
    [self.view addSubview:_noDataView];
    
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
    _selCarNoView.delegate = self;
    [self.view addSubview:_selCarNoView];
    
    // 缴费视图
    _payTypeView = [[PayTypeView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _payTypeView.hidden = YES;
    _payTypeView.delegate = self;
    [self.view addSubview:_payTypeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySuccess:) name:@"alipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayfa) name:@"alipayfa" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayDidntFinsh) name:@"alipayDidntFinsh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNetWor) name:@"alipayNetWor" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipaySuccess:) name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatF) name:@"wechatPayFalu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidntFinsh) name:@"wechatPaydidntFinsh" object:nil];
}

-(void)hudHud
{
    [self hideHud];
}

-(void)alipaySuccess:(id)sender
{
    [self hudHud];
    //    RechageSuccessCtrl *rechageSuccessCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RechageSuccessCtrl"];
    //    rechageSuccessCtrl.orderId = _rechageModel.orderId;
    //    [self.navigationController pushViewController:rechageSuccessCtrl animated:YES];
    PaySucViewController *paySucVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySucViewController"];
    [self.navigationController pushViewController:paySucVC animated:YES];
    
}

#pragma mark 微信支付失败
-(void)wechatF
{
    [self hudHud];
    [self showHint:@"微信支付失败"];
}

#pragma mark 微信支付用户退出支付  支付失败
-(void)wechatDidntFinsh
{
    [self hudHud];
    [self showHint:@"您取消了支付！"];
}

#pragma mark 支付宝支付失败
-(void)alipayfa
{
    [self hudHud];
    [self showHint:@"支付失败，请重新尝试！"];
}

-(void)alipayDidntFinsh
{
    [self hudHud];
    [self showHint:@"您取消了支付！"];
}

-(void)alipayNetWor
{
    [self hudHud];
    [self showHint:@"网络连接出错！"];
}

- (void)closeRule {
    _ruleView.hidden = YES;
}

#pragma mark 根据车牌查询详细信息
- (void)_loadData:(NSString *)carNo {
    _carStateView.hidden = YES;
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
            _noDataView.hidden = YES;
            _paySelfModel = [[PaySelfModel alloc] initWithDataDic:responseObject[@"data"]];
            [self uploadView:_paySelfModel];
        }else {
            _noDataView.hidden = NO;
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
    [self.view endEditing:YES];
    if(_provinceTF.text == nil && _provinceTF.text.length <= 0){
        [self showHint:@"请输入有效的车牌"];
        return;
    }
    if(_letterTF.text == nil && _letterTF.text.length <= 0){
        [self showHint:@"请输入有效的车牌"];
        return;
    }
    if(_numTF.text == nil && _provinceTF.text.length < 5){
        [self showHint:@"请输入有效的车牌"];
        return;
    }
    
    NSString *inputCarNo = [NSString stringWithFormat:@"%@%@%@", _provinceTF.text, _letterTF.text, _numTF.text];
    [self _loadData:inputCarNo];
    
}

#pragma mark 缴费按钮
- (IBAction)payMoney:(id)sender {
//    if(_paySelfModel.fee.floatValue == 0) {
//        [self showHint:@"当前不需要缴费"];
//    }else {
        _payTypeView.hidden = NO;
//    }
}

#pragma mark 选择车牌协议
- (void)selCarNoCompelete:(NSString *)carNo {
    [self _loadData:carNo];
    
    _provinceTF.text = [carNo substringWithRange:NSMakeRange(0, 1)];
    _letterTF.text = [carNo substringWithRange:NSMakeRange(1, 1)];
    _numTF.text = [carNo substringWithRange:NSMakeRange(2, carNo.length - 2)];
}

#pragma mark 选择支付协议
- (void)selPay:(PayType)payType {
    
    switch (payType) {
        case AccountPay:
            [self acountPay];
            break;
            
        case AliPay:
            [self showHudInView:self.view hint:@""];
            if(_paySelfModel.orderId != nil && ![_paySelfModel.orderId isKindOfClass:[NSNull class]] && _paySelfModel.orderId.length > 0){
                
                NSLog(@"%@",_paySelfModel.orderId);
                [ZTAliPay aliPayWithOrderId:_paySelfModel.orderId withComplete:^(NSString *stateCode) {
                    [self hideHud];
                    if ([stateCode isEqualToString:@"6001"]) {
                        [self showHint:@"您取消了支付"];
                    }
                    
                }];
            }
            break;
        case WeChatPay:
            [self showHudInView:self.view hint:@""];
            if(_paySelfModel.orderId != nil && ![_paySelfModel.orderId isKindOfClass:[NSNull class]] && _paySelfModel.orderId.length > 0){
                if([WXApi isWXAppInstalled]){
                    NSLog(@"%@",_paySelfModel.orderId);
                    [ZTWeChatPayTools weChatPayWithOrderId:_paySelfModel.orderId];
                }else {
                    [self hideHud];
                    [self showHint:@"未安装微信应用"];
                }
            }
            
            break;
            
    }
}

#pragma mark 余额支付
- (void)acountPay {
    NSString *payUrl = [NSString stringWithFormat:@"%@pay/payByMemberAccount", KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:_paySelfModel.orderId forKey:@"orderId"];
    
    [self showHudInView:self.view hint:@"支付中.."];
    
    [[ZTNetworkClient sharedInstance] POST:payUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            PaySucViewController *paySucVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySucViewController"];
            [self.navigationController pushViewController:paySucVC animated:YES];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alipaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPayFalu" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatPaydidntFinsh" object:nil];
    
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
