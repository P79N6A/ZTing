//
//  MsgDetailViewController.m
//  ZSTC
//
//  Created by 魏唯隆 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "MsgDetailViewController.h"

@interface MsgDetailViewController ()
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_contentLabel;
    __weak IBOutlet UILabel *_timeLabel;

}
@end

@implementation MsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initView];
}

- (void)_initView {
    self.title = @"消息详情";
    
    _titleLabel.text = _msgModel.pushTitle;
    
    _contentLabel.text = _msgModel.pushContent;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *pushDate = [formater dateFromString:_msgModel.pushTime];
    NSDateFormatter *newFormater = [[NSDateFormatter alloc] init];
    [newFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLabel.text = [newFormater stringFromDate:pushDate];
    
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
