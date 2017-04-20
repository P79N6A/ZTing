//
//  SearchViewCtrl.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/18.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "SearchViewCtrl.h"
#import "HotSearchCell.h"

@interface SearchViewCtrl ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,strong) UIButton *xfBtn;

@property (nonatomic,strong) UILabel *signLab;

@property (nonatomic,strong) UIView *sepView;

@property (nonatomic,strong) UICollectionView *areaCollection;

@property (nonatomic,strong) NSMutableArray *dataArr;

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
    UITextField *searchTextField = [[UITextField alloc] init];
    self.searchTextField = searchTextField;
    searchTextField.placeholder = @"请输入需要查找停车场的地点";
    searchTextField.layer.borderColor = color(153, 153, 153, 1).CGColor;
    searchTextField.layer.borderWidth = 0.5;
    searchTextField.font = [UIFont systemFontOfSize:15];
    searchTextField.layer.cornerRadius = 5;
    searchTextField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:searchTextField];
    
    self.searchTextField.sd_layout
    .topSpaceToView(self.view, 80)
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
    NSLog(@"%@",NSStringFromClass([sender class]));
    
    
}

#pragma mark collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@   %@   %@",_dataArr[indexPath.row][@"areaName"],_dataArr[indexPath.row][@"areaLat"],_dataArr[indexPath.row][@"areaLng"]);
    
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
