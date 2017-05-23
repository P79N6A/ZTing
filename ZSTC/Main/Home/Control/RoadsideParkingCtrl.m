//
//  RoadsideParkingCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/24.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "RoadsideParkingCtrl.h"
#import "ScannerViewCtrl.h"
#import "NoDataView.h"
#import "SelCarNoView.h"
#import "RoadParkModel.h"
#import "StartRoadParkView.h"
#import "PaySelfViewController.h"
#import "BillingModel.h"

@interface RoadsideParkingCtrl ()<ZTScannerViewCtrlDelegate,SelCarNoDelegate>
{
    //无数据视图
    NoDataView *_noDataView;
    // 选择车牌
    SelCarNoView *_selCarNoView;
    
    //查询结果视图
    UIView *_bottomResultView;
    UILabel *_roadParkNameLab;
    UILabel *_rulerLab;
    UITextField *_provinceTF;
    UITextField *_letterTF;
    UITextField *_numTF;
    UIButton *_selBt;
    UIButton *_startParkBtn;
    
    //开始停车之后的视图
    StartRoadParkView *_startRoadParkView;
    
    RoadParkModel *model;
    //选择路边停车的车牌号
    NSString *_carNo;
    
    NSTimer *_timer;
}
//顶部查询视图
@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIButton *scanBtn;

@property (nonatomic,strong) UIButton *inquireBtn;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation RoadsideParkingCtrl

-(NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destoryTimer) name:@"closeTimer" object:nil];
    
    //判断是否已经开始路边停车
    if ([TheUserDefaults boolForKey:KRoadParkState]) {
        _startRoadParkView.hidden = NO;
        _headerView.hidden = YES;
        _bottomResultView.hidden = YES;
        
        _timer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(_roadParkQueryDetails) userInfo:nil repeats:YES];
        
    }else
    {
        _startRoadParkView.hidden = YES;
        _headerView.hidden = NO;
        _bottomResultView.hidden = YES;
    }
    
}

#pragma mark 销毁定时器
-(void)destoryTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark 创建视图
-(void)_initView
{
    self.title = @"路边停车";
    self.view.backgroundColor = color(237, 237, 237, 1);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"补缴" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonItemAction:)];
    //创建顶部查询视图
    [self _initHeaderView];
    
    //创建底部查询结果视图
    [self _initBottomResultView];
    
    // 无数据视图
    _noDataView = [[NoDataView alloc] init];
    _noDataView.hidden = YES;
    [self.view addSubview:_noDataView];
    
    _noDataView.sd_layout
    .topSpaceToView(self.headerView, 0)
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    // 选择车牌
    _selCarNoView = [[SelCarNoView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _selCarNoView.hidden = YES;
    _selCarNoView.delegate = self;
    [self.view addSubview:_selCarNoView];
    [self.view bringSubviewToFront:_selCarNoView];
    
    //开始路边停车
    _startRoadParkView = [[StartRoadParkView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _startRoadParkView.hidden = YES;
    [self.view addSubview:_startRoadParkView];
    
    
}

#pragma mark 补缴
-(void)rightBarbuttonItemAction:(id)sender
{
    PaySelfViewController *payVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaySelfViewController"];
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark 创建顶部查询视图
-(void)_initHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    [self.view addSubview:headerView];
    //车位编号
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.placeholder = @"请输入车位编号";
    textField.textColor = [UIColor blackColor];
    textField.layer.cornerRadius = 4;
    textField.clipsToBounds = YES;
    textField.layer.borderColor = color(237, 237, 237, 1).CGColor;
    textField.layer.borderWidth = 1;
    self.textField = textField;
    [self.headerView addSubview:textField];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    //扫一扫按钮
    UIButton *scanBtn = [[UIButton alloc] init];
    self.scanBtn = scanBtn;
    [scanBtn addTarget:self action:@selector(scanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [scanBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    scanBtn.backgroundColor = MainColor;
    scanBtn.layer.cornerRadius = 4;
    scanBtn.clipsToBounds = YES;
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"icon_index_card_scan"] forState:UIControlStateNormal];
    [self.headerView addSubview:scanBtn];
    //查询按钮
    UIButton *inquireBtn = [[UIButton alloc] init];
    self.inquireBtn = inquireBtn;
    inquireBtn.layer.cornerRadius = 4;
    inquireBtn.clipsToBounds = YES;
    [inquireBtn addTarget:self action:@selector(inquireBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [inquireBtn setTitle:@"查询" forState:UIControlStateNormal];
    [inquireBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    inquireBtn.backgroundColor = MainColor;
    [inquireBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.headerView addSubview:inquireBtn];
    
    self.headerView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(120);
    
    self.scanBtn.sd_layout
    .topSpaceToView(self.headerView, 8)
    .rightSpaceToView(self.headerView, 8)
    .widthIs(100)
    .heightIs(45);
    
    self.textField.sd_layout
    .topSpaceToView(self.headerView, 8)
    .leftSpaceToView(self.headerView, 8)
    .rightSpaceToView(self.scanBtn, 8)
    .heightIs(45);
    
    self.inquireBtn.sd_layout
    .leftSpaceToView(self.headerView, 8)
    .topSpaceToView(self.textField, 10)
    .rightSpaceToView(self.headerView, 8)
    .heightIs(45);

}

#pragma mark 创建底部查询结果视图
-(void)_initBottomResultView
{

    UIView *bottomResultView = [[UIView alloc] init];
    bottomResultView.backgroundColor = [UIColor whiteColor];
    _bottomResultView = bottomResultView;
    bottomResultView.hidden = YES;
    [self.view addSubview:bottomResultView];
    
    UILabel *roadParkNameLab = [[UILabel alloc] init];
    roadParkNameLab.font = [UIFont systemFontOfSize:16];
    roadParkNameLab.textAlignment = NSTextAlignmentLeft;
    roadParkNameLab.textColor = [UIColor blackColor];
    _roadParkNameLab = roadParkNameLab;
    roadParkNameLab.text = @"光谷大道路边A段-14号车位";
    [_bottomResultView addSubview:roadParkNameLab];
    
    UILabel *rulerLab = [[UILabel alloc] init];
    rulerLab.font = [UIFont systemFontOfSize:16];
    rulerLab.textAlignment = NSTextAlignmentLeft;
    rulerLab.textColor = [UIColor blackColor];
    _rulerLab = rulerLab;
    rulerLab.numberOfLines = 0;
    rulerLab.text = @"收费规则：xxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    [_bottomResultView addSubview:rulerLab];
    
    UITextField *provinceTF = [[UITextField alloc] init];
    provinceTF.font = [UIFont systemFontOfSize:16];
    provinceTF.layer.cornerRadius = 4;
    provinceTF.layer.borderColor = color(237, 237, 237, 1).CGColor;
    provinceTF.layer.borderWidth = 1;
    provinceTF.clipsToBounds = YES;
    provinceTF.placeholder = @"湘";
    provinceTF.textAlignment = NSTextAlignmentCenter;
    _provinceTF = provinceTF;
    [_bottomResultView addSubview:provinceTF];
    
    UITextField *letterTF = [[UITextField alloc] init];
    letterTF.font = [UIFont systemFontOfSize:17];
    letterTF.layer.cornerRadius = 4;
    letterTF.layer.borderColor = color(237, 237, 237, 1).CGColor;
    letterTF.layer.borderWidth = 1;
    letterTF.clipsToBounds = YES;
    letterTF.placeholder = @"A";
    letterTF.textAlignment = NSTextAlignmentCenter;
    _letterTF = letterTF;
    [_bottomResultView addSubview:letterTF];
    
    UITextField *numTF = [[UITextField alloc] init];
    numTF.font = [UIFont systemFontOfSize:17];
    numTF.layer.cornerRadius = 4;
    numTF.layer.borderColor = color(237, 237, 237, 1).CGColor;
    numTF.layer.borderWidth = 1;
    numTF.clipsToBounds = YES;
    numTF.textAlignment = NSTextAlignmentCenter;
    _numTF = numTF;
    [_bottomResultView addSubview:numTF];
    
    UIButton *selBt = [[UIButton alloc] init];
    _selBt = selBt;
    selBt.layer.cornerRadius = 4;
    selBt.clipsToBounds = YES;
    [selBt addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selBt setTitle:@"选取" forState:UIControlStateNormal];
    [selBt setImage:[UIImage imageNamed:@"icon_pay_select"] forState:UIControlStateNormal];
    [selBt.titleLabel setFont:[UIFont systemFontOfSize:17]];
    selBt.backgroundColor = MainColor;
    [selBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomResultView addSubview:selBt];
    
    UIButton *startParkBtn = [[UIButton alloc] init];
    _startParkBtn = startParkBtn;
    startParkBtn.layer.cornerRadius = 4;
    startParkBtn.clipsToBounds = YES;
    [startParkBtn addTarget:self action:@selector(startParkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [startParkBtn setTitle:@"开始停车" forState:UIControlStateNormal];
    [startParkBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    startParkBtn.backgroundColor = MainColor;
    [startParkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomResultView addSubview:startParkBtn];

    _bottomResultView.sd_layout
    .topSpaceToView(_headerView, 10)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _roadParkNameLab.sd_layout
    .topSpaceToView(_bottomResultView, 10)
    .leftSpaceToView(_bottomResultView, 8)
    .widthIs(KScreenWidth-20)
    .heightIs(20);
    
    _rulerLab.sd_layout
    .topSpaceToView(_roadParkNameLab, 10)
    .leftSpaceToView(_bottomResultView, 8)
    .rightSpaceToView(_bottomResultView, 8);
    
    _provinceTF.sd_layout
    .topSpaceToView(_rulerLab, 20)
    .leftSpaceToView(_bottomResultView, 8)
    .widthIs(40)
    .heightIs(40);
    
    _letterTF.sd_layout
    .topSpaceToView(_rulerLab, 20)
    .leftSpaceToView(_provinceTF, 8)
    .widthIs(40)
    .heightIs(40);
    
    _selBt.sd_layout
    .rightSpaceToView(_bottomResultView, 8)
    .topSpaceToView(_rulerLab, 20)
    .widthIs(90)
    .heightIs(40);
    
    _numTF.sd_layout
    .topSpaceToView(_rulerLab, 20)
    .leftSpaceToView(_letterTF, 8)
    .rightSpaceToView(_selBt, 8)
    .heightIs(40);
    
    _startParkBtn.sd_layout
    .bottomSpaceToView(_bottomResultView, 20)
    .leftSpaceToView(_bottomResultView, 8)
    .rightSpaceToView(_bottomResultView, 8)
    .heightIs(40);
    
}

#pragma mark 选择车牌协议
- (void)selCarNoCompelete:(NSString *)carNo {
    _provinceTF.text = [carNo substringWithRange:NSMakeRange(0, 1)];
    _letterTF.text = [carNo substringWithRange:NSMakeRange(1, 1)];
    _numTF.text = [carNo substringWithRange:NSMakeRange(2, carNo.length - 2)];
    _carNo = carNo;
}

#pragma mark 选取车牌
-(void)selBtnAction:(id)sender
{
    _selCarNoView.hidden = NO;
}

#pragma mark 开始停车
-(void)startParkBtnAction:(id)sender
{
    _headerView.hidden = YES;
    _bottomResultView.hidden = YES;
    _startRoadParkView.hidden = NO;
    
    [self showHudInView:self.view hint:@""];
    NSString *urlStr = [NSString stringWithFormat:@"%@trace/makeRoadTrace",KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:KToken forKey:@"token"];
    [params setValue:KMemberId forKey:@"memberId"];
    [params setValue:model.seatParkid forKey:@"parkId"];
    [params setValue:model.seatNo forKey:@"seatNo"];
    [params setValue:@"0" forKey:@"carType"];
    [params setValue:_carNo forKey:@"carno"];
    
    __weak typeof(self) weakSelf = self;
    
    [[ZTNetworkClient sharedInstance] POST:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        [weakSelf hideHud];
        if([responseObject[@"success"] boolValue]){
            
            [TheUserDefaults setBool:YES forKey:KRoadParkState];
            [TheUserDefaults synchronize];
            
            [self _roadParkQueryDetails];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 路边停车查询详情
-(void)_roadParkQueryDetails
{
    NSString *urlStr = [NSString stringWithFormat:@"%@roadTrace/currentParkingInfo",KDomain];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:KToken forKey:@"token"];
    [params setValue:KMemberId forKey:@"memberId"];
    
    [[ZTNetworkClient sharedInstance] GET:urlStr dict:params progressFloat:nil succeed:^(id responseObject) {
        
        if([responseObject[@"success"] boolValue]){
            _startRoadParkView.hidden = NO;
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark 扫描二维码
-(void)scanBtnAction:(id)sender
{
    ScannerViewCtrl *scanViewCtrl = [[ScannerViewCtrl alloc] init];
    scanViewCtrl.delegate = self;
    [self.navigationController pushViewController:scanViewCtrl animated:YES];
}

#pragma mark 扫描二维码delegate
- (void)didFinshedScanning:(NSString *)result
{
    self.textField.text = result;
}

#pragma mark 根据车位编号查询
-(void)inquireBtnAction:(id)sender
{
    if(_textField.text == nil && _textField.text.length <= 0){
        [self showHint:@"请输入车位编号"];
        return;
    }
    
    [self.textField resignFirstResponder];
    [self showHudInView:self.view hint:@""];

    AppDelegate *delegate = [[AppDelegate alloc] init];
    [delegate startLocation];
    
    __weak typeof(self) weakSelf = self;
    
    [delegate receiveLocationBlock:^(CLLocation *currentLocation, AMapLocationReGeocode *regeocode, BOOL isLocationSuccess) {
        if (isLocationSuccess) {
            
            NSString *infoUrl = [NSString stringWithFormat:@"%@roadTrace/getParkSeatInfo", KDomain];
            NSMutableDictionary *params = @{}.mutableCopy;
            [params setObject:KToken forKey:@"token"];
            [params setObject:KMemberId forKey:@"memberId"];
            [params setObject:_textField.text forKey:@"seatNo"];
            [params setObject:[NSString stringWithFormat:@"%lf",currentLocation.coordinate.latitude] forKey:@"lat"];
            [params setObject:[NSString stringWithFormat:@"%lf",currentLocation.coordinate.longitude] forKey:@"lng"];
            
            [[ZTNetworkClient sharedInstance] POST:infoUrl dict:params progressFloat:nil succeed:^(id responseObject) {
                [weakSelf hideHud];
                if([responseObject[@"success"] boolValue]){
                    
                    NSLog(@"%@",responseObject);
                    NSDictionary *dic = responseObject[@"data"];
                    NSArray *feeArr = dic[@"fee"];
                    if (feeArr.count == 0 || [feeArr isKindOfClass:[NSNull class]]) {
                        _noDataView.hidden = NO;
                    }else
                    {
                        _noDataView.hidden = YES;
                        model = [[RoadParkModel alloc] initWithDataDic:responseObject[@"data"][@"parkSeat"]];
                        
                        for (int i = 0; i < feeArr.count; i++) {
                            BillingModel *billModel = [[BillingModel alloc] initWithDataDic:feeArr[i]];
                            [weakSelf.dataArr addObject:billModel];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self updateResultView:_dataArr:model];
                            
                        });
                    }
                    
                }else {
                    _noDataView.hidden = NO;
                    [self showHint:responseObject[@"message"]];
                    if([responseObject[@"statusCode"] integerValue] == 202){
                        
                    }
                }
            } failure:^(NSError *error) {
                _noDataView.hidden = NO;
                [weakSelf hideHud];
            }];

        }else
        {
            
        }
    }];
    
}

-(void)updateResultView:(NSMutableArray *)arr :(RoadParkModel *)roadParkModel
{
    _bottomResultView.hidden = NO;
    
    NSString *billRuler = @"";
    for (int i = 0; i < arr.count; i++) {
        BillingModel *billModel = arr[i];
        if (billModel.billingCartype == 0) {
            
            [billRuler stringByAppendingFormat:@"小型车: %@  ",billModel.billingRemark];
            
        }else if (billModel.billingCartype == 1){
            
            [billRuler stringByAppendingFormat:@"中型车: %@  ",billModel.billingRemark];
            
        }else if (billModel.billingCartype == 2)
        {
            
            [billRuler stringByAppendingFormat:@"大型车: %@  ",billModel.billingRemark];
            
        }
    }
    
    _rulerLab.text = billRuler;
    CGSize rulerSize = [_rulerLab.text boundingRectWithSize:CGSizeMake(KScreenWidth-16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    _rulerLab.sd_layout
    .heightIs(rulerSize.height);
    
    _roadParkNameLab.text = [NSString stringWithFormat:@"%@-%@号车位",roadParkModel.parkAdress,roadParkModel.seatNo];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeTimer" object:nil];
}

@end
