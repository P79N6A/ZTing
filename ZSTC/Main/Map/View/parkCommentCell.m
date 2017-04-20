//
//  parkCommentCell.m
//  ZSTC
//
//  Created by 焦平 on 2017/4/19.
//  Copyright © 2017年 HNZT. All rights reserved.
//

#import "parkCommentCell.h"
#import "CWStarRateView.h"

@interface parkCommentCell ()

@property (nonatomic,strong) UILabel *commentUserNameLab;

@property (nonatomic,strong) UILabel *commentTimeLab;

@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) UILabel *scoreLab;

@property (nonatomic,strong) CWStarRateView *starView;

@property (nonatomic,strong) UIView *sepView;

@end

@implementation parkCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)configSubViews
{
    UILabel *commentUserNameLab = [[UILabel alloc] init];
    self.commentUserNameLab = commentUserNameLab;
    commentUserNameLab.font = [UIFont systemFontOfSize:11];
    commentUserNameLab.textColor = MainColor;
    commentUserNameLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:commentUserNameLab];
    
    UILabel *commentTimeLab = [[UILabel alloc] init];
    self.commentTimeLab = commentTimeLab;
    commentTimeLab.font = [UIFont systemFontOfSize:11];
    commentTimeLab.textColor = color(176, 176, 176, 1);
    commentTimeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:commentTimeLab];
    
    UILabel *contentLab = [[UILabel alloc] init];
    self.contentLab = contentLab;
    contentLab.font = [UIFont systemFontOfSize:11];
    contentLab.textColor = color(176, 176, 176, 1);
    contentLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:contentLab];
    
    UILabel *scoreLab = [[UILabel alloc] init];
    self.scoreLab = scoreLab;
    scoreLab.font = [UIFont systemFontOfSize:11];
    scoreLab.textColor = color(176, 176, 176, 1);
    scoreLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:scoreLab];
    
    _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 10) numberOfStars:5];
    _starView.scorePercent = 0.2;
    _starView.allowIncompleteStar = NO;
    _starView.hasAnimation = NO;
    _starView.userInteractionEnabled = NO;
    [self.contentView addSubview:_starView];
    
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = color(237, 237, 237, 1);
    [self.contentView addSubview:sepView];
    
    
    commentUserNameLab.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10);
    
    commentTimeLab.sd_layout
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    contentLab.sd_layout
    .topSpaceToView(commentUserNameLab, 15)
    .leftSpaceToView(self.contentView, 60);
    
    scoreLab.sd_layout
    .topSpaceToView(contentLab, 15)
    .leftSpaceToView(self.contentView, 10);
    
    _starView.sd_layout
    .topSpaceToView(contentLab, 16)
    .leftSpaceToView(scoreLab, 10)
    .widthIs(80)
    .heightIs(10);
    
    sepView.sd_layout
    .topSpaceToView(scoreLab, 5)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(0.5);
    
}

-(void)setModel:(parkCommentModel *)model
{
    _model = model;
    
    _commentUserNameLab.text = model.memberName;
    CGSize commentNameSize = [_commentUserNameLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    
    _commentUserNameLab.sd_layout
    .widthIs(commentNameSize.width)
    .heightIs(commentNameSize.height);
    
    //需要转换的字符串
    NSString *dateString = model.commentCommentTime;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    _commentTimeLab.text = [NSString created_at:date];;
    CGSize commentTimeSize = [_commentTimeLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    
    _commentTimeLab.sd_layout
    .widthIs(commentTimeSize.width)
    .heightIs(commentTimeSize.height);
    
    
    _contentLab.text = model.commentContent;
    CGSize contentSize = [_contentLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    _contentLab.sd_layout
    .widthIs(contentSize.width)
    .heightIs(contentSize.height);
    
    _scoreLab.text = @"评分";
    CGSize scoreSize = [_scoreLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    _scoreLab.sd_layout
    .widthIs(scoreSize.width)
    .heightIs(scoreSize.height);

    float score = ([model.commentScore1 integerValue] + [model.commentScore2 integerValue] + [model.commentScore3 integerValue])/15.0;
    _starView.scorePercent = score;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
