//
//  ConponViewCell.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "ConponViewCell.h"
#import "ConponMode.h"
#import "Comment.h"

@interface ConponViewCell()
@property (weak,nonatomic)  UIView *topView;
@property (weak,nonatomic)  UILabel *maneyLabel;
@property (weak,nonatomic)  UIView *lineView;

@property (weak,nonatomic)  UILabel *generalLabel;
@property (weak,nonatomic)  UILabel *userTimeLabel;
@property (weak,nonatomic)  UIButton *isEffectiveBtn;
@property (weak,nonatomic)  UIImageView *bottomImageView;

@end
@implementation ConponViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
   static NSString *ConponViewCellID = @"ConponViewCell";
    
    ConponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConponViewCellID];
    if (cell == nil) {
        cell = [[ConponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConponViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加自己可能显示的所有子控件
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = QiCaiBackGroundColor;
        [self.contentView addSubview:topView];
        self.topView = topView;
        
        //cell的背景的图片
        UIImageView *bottomImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:bottomImageView];
        self.bottomImageView = bottomImageView;
        
        //有效
        UIButton *isEffectiveBtn = [[UIButton alloc]init];
        [isEffectiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        isEffectiveBtn.titleLabel.font = QiCaiDetailTitle12Font;
        [self.contentView addSubview:isEffectiveBtn];
        self.isEffectiveBtn = isEffectiveBtn;
        
        //10元
        UILabel *maneyLabel = [[UILabel alloc]init];
        maneyLabel.font = [UIFont systemFontOfSize:32];
        maneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:maneyLabel];
        self.maneyLabel = maneyLabel;
        
        //line
        UIView *lineView = [[UIView alloc]init];
        [self.contentView addSubview:lineView];
        self.lineView = lineView;
        
        //通用券 0
        UILabel *generalLabel = [[UILabel alloc]init];
        generalLabel.font = QiCaiDetailTitle12Font;
        generalLabel.textColor = QiCaiDeepColor;
        generalLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:generalLabel];
        self.generalLabel = generalLabel;
        
        //有效期
        UILabel *userTimeLabel = [[UILabel alloc]init];
        userTimeLabel.font = QiCaiDetailTitle10Font;
        userTimeLabel.textColor = QiCaiShallowColor;
        userTimeLabel.textAlignment = NSTextAlignmentLeft;
        userTimeLabel.numberOfLines = 0;
        [self.contentView addSubview:userTimeLabel];
        self.userTimeLabel = userTimeLabel;
    }
    return self;
}
-(void)setConponMode:(ConponMode *)conponMode
{
    // 给子控件赋值
    [self setSubViewsData:conponMode];
    
    // 设置子控件的frame
    [self setSubViewsFrame:conponMode];
 
}


-(void)setSubViewsData:(ConponMode *)conponMode
{
    _conponMode = conponMode;
    
    self.maneyLabel.text = [NSString stringWithFormat:@"%.2f元",[conponMode.money floatValue]];
    self.generalLabel.text = [NSString stringWithFormat:@"%.2f元以上可用",[conponMode.moneyLimit floatValue]];
    self.userTimeLabel.text = [NSString stringWithFormat:@"有效期至%@",conponMode.endTime];
    
    if ([conponMode.isOverdue isEqualToString:@"0"] || conponMode.isOverdue == nil) {//没有过期
        
        self.bottomImageView.image = [UIImage imageNamed:@"me_conpon_light"];
        [self.isEffectiveBtn setTitle:@"有效" forState:UIControlStateNormal];
        self.maneyLabel.textColor = QiCaiNavBackGroundColor;
        self.lineView.backgroundColor = QiCaiNavBackGroundColor;
        self.isEffectiveBtn.backgroundColor = QiCaiNavBackGroundColor;
        
    }else
    {
        self.bottomImageView.image = [UIImage imageNamed:@"me_conpon_normal"];
        [self.isEffectiveBtn setTitle:@"无效" forState:UIControlStateNormal];
        self.maneyLabel.textColor = QiCaiBZTitleColor;
        self.lineView.backgroundColor = QiCaiBZTitleColor;
        self.isEffectiveBtn.backgroundColor = QiCaiEmbellishmentColor;

    }
    
}
-(void)setSubViewsFrame:(ConponMode *)conponMode
{
    self.topView.frame = CGRectMake(0, 0, MYScreenW, 5);
    self.bottomImageView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), MYScreenW, 103);
    self.isEffectiveBtn.frame = CGRectMake(MYScreenW - 45, 13, 35, 17);
    self.isEffectiveBtn.layer.cornerRadius = 3;
    
    // 指定我要以这个大小的字体显示
    NSDictionary *attributeDict = @{NSFontAttributeName : [UIFont systemFontOfSize:32]};
    // 最大范围
    CGSize maxSize = CGSizeMake(MYScreenW, 30);
    // 就是totalMoneyLabel的size
    NSString *str = [NSString stringWithFormat:@"%.2f元",[conponMode.money floatValue]];
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    self.maneyLabel.frame = CGRectMake(17, CGRectGetMaxY(self.isEffectiveBtn.frame) , size.width,30);
    
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.maneyLabel.frame) + 20, 25, 0.8, 50);
    self.generalLabel.frame = CGRectMake(CGRectGetMaxX(self.lineView.frame) + 22, CGRectGetMaxY(self.isEffectiveBtn.frame) + QiCaiMargin, MYScreenW - CGRectGetMaxX(self.lineView.frame) - 22, 20);
    self.userTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.lineView.frame) + 22, CGRectGetMaxY(self.generalLabel.frame), MYScreenW - CGRectGetMaxX(self.lineView.frame) - 22, 30);
    
}

@end
