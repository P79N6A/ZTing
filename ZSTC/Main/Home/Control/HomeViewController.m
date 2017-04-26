//
//  HomeViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/10.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "HomeViewController.h"
#import "TopScrollView.h"
#import "CarStateView.h"

#import "AdvModel.h"
#import "BindCarModel.h"

#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "MoneyViewController.h"
#import "CardViewController.h"
#import "HistoryViewController.h"
#import "CollectViewController.h"
#import "PaySelfViewController.h"

#import "ZTMapViewCtrl.h"

#import "RoadsideParkingCtrl.h"

@interface HomeViewController ()
{
    __weak IBOutlet TopScrollView *_topView;
    __weak IBOutlet UIView *_parkSpaceView;
    __weak IBOutlet UIView *_stopCarView;
    __weak IBOutlet CarStateView *_carStateView;
    __weak IBOutlet UIView *_menuView;

    // 广告图数据
    NSMutableArray *_advData;
    // 绑定车辆信息数据
    NSMutableArray *_bindCarData;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _advData = @[].mutableCopy;
    _bindCarData = @[].mutableCopy;
    
    [self _initView];
    
    [self _loadData];
    
    // 添加登录、登出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBindCars) name:KLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBindCars) name:KLoginOutNotification object:nil];
    
    // 添加新增车辆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBindCars) name:KAddCarNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadBindCars) name:KDeleteCarNotification object:nil];
    
}

#pragma mark 创建视图
- (void)_initView {
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    UITapGestureRecognizer *serchNearByPark = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serchNearByParkAction:)];
    [_parkSpaceView addGestureRecognizer:serchNearByPark];
    _parkSpaceView.layer.borderWidth = 0.5;
    _parkSpaceView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _topView.layer.borderWidth = 0.5;
    _topView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // 路边停车
    UIView *roadsideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth/2, _stopCarView.height)];
    UITapGestureRecognizer *roadsideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roadsideAction)];
    roadsideView.userInteractionEnabled = YES;
    [roadsideView addGestureRecognizer:roadsideTap];
    [_stopCarView addSubview:roadsideView];
    roadsideView.layer.borderWidth = 0.5;
    roadsideView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UIImageView *roadsideImgView = [[UIImageView alloc] initWithFrame:CGRectMake(roadsideView.width/2 - 55, (roadsideView.height - 45)/2, 45, 45)];
    roadsideImgView.image = [UIImage imageNamed:@"icon_function_road_park"];
    [roadsideView addSubview:roadsideImgView];
    
    UILabel *roadsideLabel = [[UILabel alloc] initWithFrame:CGRectMake(roadsideView.width/2, (roadsideView.height - 22)/2, roadsideView.width/2, 22)];
    roadsideLabel.text = @"路边停车";
    roadsideLabel.font = [UIFont systemFontOfSize:16];
    roadsideLabel.textAlignment = NSTextAlignmentLeft;
    [roadsideView addSubview:roadsideLabel];

    
    // 自助缴费
    UIView *payExpenseView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2, _stopCarView.height)];
    UITapGestureRecognizer *payExpenseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payExpenseAction)];
    payExpenseView.userInteractionEnabled = YES;
    [payExpenseView addGestureRecognizer:payExpenseTap];
    [_stopCarView addSubview:payExpenseView];
    payExpenseView.layer.borderWidth = 0.5;
    payExpenseView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    UIImageView *payExpenseImgView = [[UIImageView alloc] initWithFrame:CGRectMake(payExpenseView.width/2 - 55, (payExpenseView.height - 45)/2, 45, 45)];
    payExpenseImgView.image = [UIImage imageNamed:@"simple_function_auto_pay_icon"];
    [payExpenseView addSubview:payExpenseImgView];
    
    UILabel *payExpenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(roadsideView.width/2, (roadsideView.height - 22)/2, roadsideView.width/2, 22)];
    payExpenseLabel.text = @"自助缴费";
    payExpenseLabel.font = [UIFont systemFontOfSize:16];
    payExpenseLabel.textAlignment = NSTextAlignmentLeft;
    [payExpenseView addSubview:payExpenseLabel];
    
    // 绑定车辆信息
    _carStateView.layer.borderWidth = 0.5;
    _carStateView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // 底部菜单
    NSArray *menuTitles = @[@"钱包", @"卡包", @"停车历史", @"收藏"];
    NSArray *menuImages = @[@"simple_function_wallet_icon", @"simple_function_coupons_icon", @"simple_function_park_history_icon", @"simple_function_collection_icon"];
    [menuTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/4 * idx, 0, KScreenWidth/4, _menuView.height)];
        itemView.tag = 100 + idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuAction:)];
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer:tap];
        [_menuView addSubview:itemView];
        itemView.layer.borderWidth = 0.5;
        itemView.layer.borderColor = [[UIColor grayColor] CGColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((itemView.width - itemView.width/2)/2, 10, itemView.width/2, itemView.width/2)];
        imageView.image = [UIImage imageNamed:menuImages[idx]];
        [itemView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 2, itemView.width, 20)];
        label.text = menuTitles[idx];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:label];

        
    }];
    
}

#pragma mark 数据请求
- (void)_loadData {
    // 顶部广告数据
    NSString *advUrl = [NSString stringWithFormat:@"%@park/getParkTopicList?topicSpecial=%@", KDomain, @"0"];
    [[ZTNetworkClient sharedInstance] GET:advUrl dict:nil progressFloat:nil succeed:^(id responseObject) {
        if([responseObject[@"success"] boolValue]){
            NSArray *data = responseObject[@"data"];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AdvModel *model = [[AdvModel alloc] initWithDataDic:obj];
                [_advData addObject:model];
            }];
            _topView.imgData = _advData;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    [self loadBindCars];
}
// 查询绑定车辆信息
- (void)loadBindCars {
    if([[NSUserDefaults standardUserDefaults]boolForKey:KLoginState]){
        // 绑定的车辆信息
        NSString *carInfoUrl = [NSString stringWithFormat:@"%@member/getMemberCards", KDomain];
        NSMutableDictionary *params = @{}.mutableCopy;
        [params setObject:KMemberId forKey:@"memberId"];
        [params setObject:KToken forKey:@"token"];
        
        [[ZTNetworkClient sharedInstance] POST:carInfoUrl dict:params progressFloat:nil succeed:^(id responseObject) {
            NSDictionary *data = responseObject[@"data"];
            if([responseObject[@"success"] boolValue]){
                [_bindCarData removeAllObjects];
                NSArray *carList = data[@"carList"];
                [carList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BindCarModel *model = [[BindCarModel alloc] initWithDataDic:obj];
                    [_bindCarData addObject:model];
                }];
                _carStateView.carData = _bindCarData;
                
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
    }else {
        _carStateView.carData = @[];
    }

}

#pragma mark 寻找附近停车位
-(void)serchNearByParkAction:(UITapGestureRecognizer *)searchNearTapGesture
{
    ZTMapViewCtrl *mapViewCtrl = [[ZTMapViewCtrl alloc] init];
    [self.navigationController pushViewController:mapViewCtrl animated:YES];
}

#pragma mark 路边停车
- (void)roadsideAction {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        RoadsideParkingCtrl *roadParkingCtrl = [[RoadsideParkingCtrl alloc] init];
        [self.navigationController pushViewController:roadParkingCtrl animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark 自助缴费
- (void)payExpenseAction {
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        PaySelfViewController *payVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySelfViewController"];
        [self.navigationController pushViewController:payVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark 菜单按钮
- (void)menuAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIView *itemView = tapGestureRecognizer.view;
    switch (itemView.tag - 100) {
        case 0:
            [self moneyAction];
            break;
            
        case 1:
            [self cardAction];
            break;
            
        case 2:
            [self historyAction];
            break;
            
        case 3:
            [self collectAction];
            break;
    }
}


#pragma mark 钱包
- (void)moneyAction {
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        MoneyViewController *moneyVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MoneyViewController"];
        [self.navigationController pushViewController:moneyVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
#pragma mark 卡包
- (void)cardAction {
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        CardViewController *cardVC = [[CardViewController alloc] init];
        [self.navigationController pushViewController:cardVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
#pragma mark 停车历史
- (void)historyAction {
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        HistoryViewController *historyVC = [[HistoryViewController alloc] init];
        [self.navigationController pushViewController:historyVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
#pragma mark 收藏
- (void)collectAction {
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        CollectViewController *collectVC = [[CollectViewController alloc] init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark 个人中心
- (IBAction)perAction:(id)sender {
    if([[NSUserDefaults standardUserDefaults] boolForKey:KLoginState]){
        PersonalViewController *perVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalTableViewController"];
        [self.navigationController pushViewController:perVC animated:YES];
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KLoginOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KAddCarNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDeleteCarNotification object:nil];
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
