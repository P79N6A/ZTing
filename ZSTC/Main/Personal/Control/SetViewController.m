//
//  SetViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/11.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "SetViewController.h"
#import "AboutOurViewController.h"

@interface SetViewController ()
{
    __weak IBOutlet UILabel *_cancelLabel;  // 缓存
    
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self _initView];
}

- (void)_initView {
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
    
    float allCache = [self caculateCache];
    NSString *clearCacheName = allCache >= 1 ? [NSString stringWithFormat:@"%.2fM",allCache] : [NSString stringWithFormat:@"%.2fK",allCache * 1024];
    _cancelLabel.text = clearCacheName;
}

#pragma mark tableview协议
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self clearCache];
                    break;
                    
                case 1:
                    [self updateApp];
                    break;
                    
                case 2:
                    [self aboutOur];
                    break;
                    
            }
            break;
            
        case 1:
            [self loginOut];
            break;
            
    }
}

#pragma mark 清楚缓存
- (void)clearCache {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认清除缓存" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *celarAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self showHint:[NSString stringWithFormat:@"清除缓存%@", _cancelLabel.text]];
            _cancelLabel.text = @"0.00K";
        }];
    }];
    
    [alertCon addAction:cancelAction];
    [alertCon addAction:celarAction];
    [self presentViewController:alertCon animated:YES completion:nil];
    
}
// 计算缓存
- (float)caculateCache {
    float SDTmpCache = [[SDImageCache sharedImageCache] getSize]/(1024*1024.2f);
    float allCache = SDTmpCache;
    
    return allCache;
}

#pragma mark 检查更新
- (void)updateApp {
//    [self showHint:@"最新版本"];
}

#pragma mark 关于我们
- (void)aboutOur {
    AboutOurViewController *aboutVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutOurViewController"];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

#pragma mark 退出
- (void)loginOut {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *celarAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KLoginState];
        [self.navigationController popToRootViewControllerAnimated:YES];
        // 发送登出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KLoginOutNotification object:nil];
        
    }];
    
    [alertCon addAction:cancelAction];
    [alertCon addAction:celarAction];
    [self presentViewController:alertCon animated:YES completion:nil];
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
