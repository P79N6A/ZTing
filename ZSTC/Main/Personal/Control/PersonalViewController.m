//
//  PersonalViewController.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "PersonalViewController.h"
#import "BillViewController.h"
#import "EditViewController.h"
#import "MoneyViewController.h"
#import "CardViewController.h"
#import "MyCarViewController.h"
#import "HistoryViewController.h"
#import "CollectViewController.h"

#import "MessageViewController.h"

#import "SetViewController.h"
#import "LoginViewController.h"

#import "UserInfoModel.h"
#import "UserExtModel.h"

@interface PersonalViewController ()<EditInfoCompleteDelegate>
{
    __weak IBOutlet UIImageView *_headImgView;  // 头像
    __weak IBOutlet UILabel *_nickLabel;    // 昵称
    __weak IBOutlet UILabel *_numLabel; // 电话号码
    __weak IBOutlet UILabel *_balanceLabel; // 余额
    __weak IBOutlet UILabel *_cardLabel; // 余额
    __weak IBOutlet UILabel *_myCarLabel; // 余额
    
    UserInfoModel *_userInfoModel;
}
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _loadData];
    
    // 接收登录完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData) name:KLoginNotification object:nil];
}

- (void)_initView {
    // 设置返回按钮
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    UIButton *billBt = [UIButton buttonWithType:UIButtonTypeCustom];
    billBt.frame = CGRectMake(0, 0, 65, 60);
    [billBt setBackgroundImage:[UIImage imageNamed:@"icon_bill_click"] forState:UIControlStateNormal];
    [billBt addTarget:self action:@selector(billAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:billBt];
    
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = _headImgView.height/2;
}

#pragma mark 请求数据
- (void)_loadData {
    // 个人信息
    [self showHudInView:self.view hint:@""];
    NSString *infoUrl = [NSString stringWithFormat:@"%@member/getMemberExtInfo", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [[ZTNetworkClient sharedInstance] POST:infoUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            _userInfoModel = [[UserInfoModel alloc] initWithDataDic:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_userInfoModel.memberPhotoUrl != nil && ![_userInfoModel.memberPhotoUrl isKindOfClass:[NSNull class]] && _userInfoModel.memberPhotoUrl.length > 0){
                    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.memberPhotoUrl]];
                }
                _nickLabel.text = _userInfoModel.memberNikename;
                _numLabel.text = _userInfoModel.memberPhone;
            });
        }else {
            [self showHint:responseObject[@"message"]];
            if([responseObject[@"statusCode"] integerValue] == 202){
                [self reLogin];
            }
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
    
    // 车辆、卡卷等信息
    NSString *extUrl = [NSString stringWithFormat:@"%@member/getMemberInfos", KDomain];
    NSMutableDictionary *extParams = @{}.mutableCopy;
    [extParams setObject:KMemberId forKey:@"memberId"];
    [extParams setObject:KToken forKey:@"token"];
    [[ZTNetworkClient sharedInstance] POST:extUrl dict:extParams progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            UserExtModel *userExtModel = [[UserExtModel alloc] initWithDataDic:responseObject[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _balanceLabel.text = [NSString stringWithFormat:@"%@元", userExtModel.accountAmt];
                _cardLabel.text = [NSString stringWithFormat:@"%@张", userExtModel.cardCount];
                _myCarLabel.text = [NSString stringWithFormat:@"%@辆", userExtModel.carCount];
            });
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma makr tableView协议
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [self editAction];
            break;

        case 1:
            switch (indexPath.row) {
                case 0:
                    [self moneyAction];
                    break;
                    
                case 1:
                    [self cardAction];
                    break;
            }
            break;

        case 2:
            switch (indexPath.row) {
                case 0:
                    [self myCarAction];
                    break;
                    
                case 1:
                    [self historyAction];
                    break;
                    
                case 2:
                    [self collectAction];
                    break;
            }
            break;

        case 3:
            switch (indexPath.row) {
                case 0:
                    [self messageAction];
                    break;
                    
                case 1:
                    [self setAction];
                    break;
            }
            break;

    }
}

#pragma mark 账单
- (void)billAction {
    BillViewController *billVC = [[BillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

#pragma mark 编辑信息
- (void)editAction {
    EditViewController *editVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditViewController"];
    editVC.userInfoModel = _userInfoModel;
    editVC.delegate = self;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark 钱包
- (void)moneyAction {
    MoneyViewController *moneyVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyViewController"];
    [self.navigationController pushViewController:moneyVC animated:YES];
}

#pragma mark 卡包
- (void)cardAction {
    CardViewController *cardVC = [[CardViewController alloc] init];
    [self.navigationController pushViewController:cardVC animated:YES];
}

#pragma mark 我的车辆
- (void)myCarAction {
    MyCarViewController *myCarVC = [[MyCarViewController alloc] init];
    [self.navigationController pushViewController:myCarVC animated:YES];
}

#pragma mark 停车历史
- (void)historyAction {
    HistoryViewController *historyVC = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark 收藏
- (void)collectAction {
    CollectViewController *collectVC = [[CollectViewController alloc] init];
    [self.navigationController pushViewController:collectVC animated:YES];
}

#pragma mark 消息中心
- (void)messageAction {
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

#pragma mark 设置
- (void)setAction {
    SetViewController *setVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetViewController"];
    [self.navigationController pushViewController:setVC animated:YES];
}


#pragma mark 重新登录
- (void)reLogin {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginState];
    
    // 发送登出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KLoginOutNotification object:nil];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark 编辑信息完成协议
- (void)editInfoComplete {
    [self _loadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KLoginNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
