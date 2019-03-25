//
//  MyCarViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "MyCarViewController.h"
#import "BindCarCell.h"

#import "BindCarModel.h"
#import "BIndCarViewController.h"
#import "CYLTableViewPlaceHolder.h"
#import "NoDataView.h"

@interface MyCarViewController ()<CYLTableViewPlaceHolderDelegate>
{
    NSMutableArray *_bindCarData;
}
@end

@implementation MyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
    
    [self _loadData];
    
}

- (void)_initView {
    self.title = @"车辆绑定";
    
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    _bindCarData = @[].mutableCopy;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCarAction)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BindCarCell" bundle:nil] forCellReuseIdentifier:@"BindCarCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];

    // 添加新增车辆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindCarComplete) name:KAddCarNotification object:nil];
}

- (void)_loadData {
    NSString *bindUrl = [NSString stringWithFormat:@"%@member/getMemberCards", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:bindUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if(responseObject[@"success"]){
            NSArray *datas = responseObject[@"data"][@"carList"];
            [_bindCarData removeAllObjects];
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BindCarModel *bindCarModel = [[BindCarModel alloc] initWithDataDic:obj];
                [_bindCarData addObject:bindCarModel];
            }];
            [self.tableView cyl_reloadData];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"网络不给力,请稍后重试!"];
    }];
}

#pragma mark 添加车辆
- (void)addCarAction {
    BIndCarViewController *bindCarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BIndCarViewController"];
    [self.navigationController pushViewController:bindCarVC animated:YES];
}

#pragma mark 添加车辆完成通知方法
- (void)bindCarComplete {
    [self _loadData];
}

#pragma mark tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bindCarData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BindCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BindCarCell"];
    cell.bindCarModel = _bindCarData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteBindCar:indexPath];
    }];
    return @[rowAction];
}

- (void)deleteBindCar:(NSIndexPath *)indexPath {
    BindCarModel *bindCarModel = _bindCarData[indexPath.row];
    
    NSString *deleteUrl = [NSString stringWithFormat:@"%@member/deleteCar", KDomain];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:KToken forKey:@"token"];
    [params setObject:KMemberId forKey:@"memberId"];
    [params setObject:bindCarModel.carNo forKey:@"carNo"];
    [self showHudInView:self.view hint:@""];
    [[ZTNetworkClient sharedInstance] POST:deleteUrl dict:params progressFloat:nil succeed:^(id responseObject) {
        [self hideHud];
        if([responseObject[@"success"] boolValue]){
            [_bindCarData removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            // 发送删除车辆通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KDeleteCarNotification object:nil];
            [self _loadData];
        }else {
            [self showHint:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KAddCarNotification object:nil];
}

#pragma mark 无数据协议
- (UIView *)makePlaceHolderView {
    NoDataView *noDateView = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    return noDateView;
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
