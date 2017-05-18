//
//  SearchViewCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "SearchViewCtrl.h"
#import "HotSearchCell.h"
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/iflyMSC.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZTVoiceSearchCtrl.h"

@interface SearchViewCtrl ()<UICollectionViewDelegate,UICollectionViewDataSource,IFlyRecognizerViewDelegate,AMapSearchDelegate,UITextFieldDelegate>
{
    IFlyRecognizerView      *_iflyRecognizerView;
}

@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) UIButton *xfBtn;

@property (nonatomic,strong) UILabel *signLab;

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) UICollectionView *areaCollection;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic, strong)AMapSearchAPI *POISearchManager;     //POI检索引擎

@end

@implementation SearchViewCtrl

static NSString * const ID = @"CollectionViewCellId";

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
    self.title = @"搜索停车场";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _initData];
    
    [self _initSubView];
    
    [self _initIFlyRecognizerView];
    
}

#pragma mark 讯飞语音
-(void)_initIFlyRecognizerView
{
    _iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;

    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    if (isLast == YES) {
        NSMutableString *result = [NSMutableString new];
        NSDictionary *dic = [resultArray objectAtIndex:0];
        
        for (NSString *key in dic) {
            [result appendFormat:@"%@",key];
        }
        
        NSLog(@"result   :    %@",result);
        
        _searchTextField.text = result;
        
        //创建POI检索引擎
        _POISearchManager = [[AMapSearchAPI alloc] init];
        _POISearchManager.delegate = self;
        
        //创建地理编码请求
        AMapGeocodeSearchRequest *geoSearchRequest = [[AMapGeocodeSearchRequest alloc] init];
        geoSearchRequest.address = result;
        
        //发起请求,开始POI的地理编码检索
        [_POISearchManager AMapGeocodeSearch:geoSearchRequest];

    }
    
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"%@",error);
}

#pragma mark 检索失败
-(void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


#pragma mark 收集地理编码检索到的目标
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if (response.geocodes.count == 0)  return;
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode * _Nonnull geo, NSUInteger idx, BOOL * _Nonnull stop) {
        [self showGeocodeInformation:geo];
    }];
}

#pragma mark 显示编码信息
-(void)showGeocodeInformation:(AMapGeocode * _Nonnull) geo{
    
    NSString *location = [NSString stringWithFormat:@"%@",geo.location];
    
    NSArray *locationArr = [location componentsSeparatedByString:@","];
    
    double lat = [[locationArr[0] stringByReplacingOccurrencesOfString:@"<" withString:@""] doubleValue];
    
    double lng = [[locationArr[1] stringByReplacingOccurrencesOfString:@">" withString:@""] doubleValue];
    
    CLLocationCoordinate2D Origlecoor = CLLocationCoordinate2DMake(lat, lng);
    
    ZTVoiceSearchCtrl *voiceSearchCtrl = [[ZTVoiceSearchCtrl alloc] init];
    voiceSearchCtrl.origleCoor = Origlecoor;
    [self.navigationController pushViewController:voiceSearchCtrl animated:YES];
}


#pragma mark 数据源
-(void)_initData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"areaParms" ofType:@"plist"];
    NSArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    [self.dataArr addObjectsFromArray:arr];
    
    [_areaCollection reloadData];
}

#pragma mark 创建子视图
-(void)_initSubView
{
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UITextField *searchTextField = [[UITextField alloc] init];
    self.searchTextField = searchTextField;
    searchTextField.placeholder = @"请输入需要查找停车场的地点";
    searchTextField.layer.borderColor = color(153, 153, 153, 1).CGColor;
    searchTextField.layer.borderWidth = 0.5;
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.layer.cornerRadius = 5;
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:searchTextField];
    
    self.searchTextField.sd_layout
    .topSpaceToView(self.view, 16)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(40);
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.image = [UIImage imageNamed:@"icon_search_park_icon"];
    self.searchTextField.leftView = leftView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.searchTextField.rightView = rightView;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *xfBtn = [[UIButton alloc] init];
    self.xfBtn = xfBtn;
    [xfBtn addTarget:self action:@selector(xfBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    xfBtn.frame = CGRectMake(0, 0, 60, 35);
    xfBtn.layer.cornerRadius = 3;
    xfBtn.backgroundColor = MainColor;
    [xfBtn setTitle:@"语音" forState:UIControlStateNormal];
    [xfBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [xfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightView addSubview:xfBtn];
    
    xfBtn.sd_layout
    .topSpaceToView(rightView, 5)
    .leftSpaceToView(rightView, 5)
    .rightSpaceToView(rightView, 5)
    .bottomSpaceToView(rightView, 5);
    
    
    UILabel *signLab = [[UILabel alloc] init];
    self.signLab = signLab;
    signLab.font = [UIFont systemFontOfSize:14];
    signLab.textColor = [UIColor blackColor];
    signLab.text = @"热门商圈";
    signLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:signLab];
    
    self.signLab.sd_layout
    .topSpaceToView(self.searchTextField, 30)
    .leftSpaceToView(self.view, 10)
    .widthIs(100)
    .heightIs(30);
    
    UIView *sepView = [[UIView alloc] init];
    self.sepView = sepView;
    sepView.backgroundColor = color(153, 153, 153, 1);
    [self.view addSubview:sepView];
    
    self.sepView.sd_layout
    .topSpaceToView(self.signLab, 5)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(0.5);
    
    
    [self.view addSubview:self.areaCollection];
    self.areaCollection.sd_layout
    .topSpaceToView(self.sepView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(40);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField.returnKeyType==UIReturnKeySearch)
    {
        if ([_searchTextField.text length] > 0)
        {
            NSLog(@"123");
        }
    }
    return YES;
}

-(UICollectionView *)areaCollection
{
    if (_areaCollection == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((KScreenWidth-50)/4, 40);
        
        //2.初始化collectionView
        _areaCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.view addSubview:_areaCollection];
        
        _areaCollection.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _areaCollection.backgroundColor = [UIColor whiteColor];
        //3.注册collectionViewCell
        //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
        [_areaCollection registerClass:[HotSearchCell class] forCellWithReuseIdentifier:ID];
        
        //4.设置代理
        _areaCollection.delegate = self;
        _areaCollection.dataSource = self;
        
    }
    return _areaCollection;
}

#pragma mark 讯飞语音
-(void)xfBtnAction:(UIButton *)sender
{
    [_searchTextField resignFirstResponder];
    //启动识别服务
    [_iflyRecognizerView start];

}

#pragma mark collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@   %@   %@",_dataArr[indexPath.row][@"areaName"],_dataArr[indexPath.row][@"areaLat"],_dataArr[indexPath.row][@"areaLng"]);
    
    ZTVoiceSearchCtrl *searchViewCtrl = [[ZTVoiceSearchCtrl alloc] init];
    
    NSString *lat = _dataArr[indexPath.row][@"areaLat"];
    NSString *lng = _dataArr[indexPath.row][@"areaLng"];
    searchViewCtrl.origleCoor = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
    [self.navigationController pushViewController:searchViewCtrl animated:YES];
    
}

#pragma mark collection dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    
    cell.areaLab.layer.borderColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1].CGColor;
    cell.areaLab.layer.borderWidth = 1;
    cell.areaLab.textColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
    cell.areaLab.text = _dataArr[indexPath.row][@"areaName"];
    
    return cell;
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
