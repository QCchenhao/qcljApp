//
//  MembershipCardCell.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/9.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MembershipCardCell.h"
#import "Comment.h"
#import "MembershipCardMode.h"

@interface MembershipCardCell()
@property (weak,nonatomic)  UIImageView *bjImageView;
@property (weak,nonatomic)  UIImageView *maneyImageView;
@property (weak,nonatomic)  UILabel *rechargeLabel;
@property (weak,nonatomic)  UILabel *rechargeDetailLabel;
@property (weak,nonatomic)  UIButton *instanceRechargeBtn;

@end
@implementation MembershipCardCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *MembershipCardCellID = @"MembershipCardCell";
    MembershipCardCell *cell = [tableView dequeueReusableCellWithIdentifier:MembershipCardCellID];
    if (cell == nil) {
        cell = [[MembershipCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MembershipCardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加自己可能显示的所有子控件
        //背景图片
        UIImageView *bjImageView = [[UIImageView alloc]init];
        bjImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:bjImageView];
        self.bjImageView = bjImageView;
        
        //左边的金钱图片
        UIImageView *maneyImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:maneyImageView];
        self.maneyImageView = maneyImageView;

        //充值钱数
        UILabel *rechargeLabel = [[UILabel alloc]init];
        rechargeLabel.font = QiCai12PFFont;
        rechargeLabel.textColor = QiCaiDeepColor;
        rechargeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:rechargeLabel];
        self.rechargeLabel = rechargeLabel;
        
        //赠送优惠
        UILabel *rechargeDetailLabel = [[UILabel alloc]init];
        rechargeDetailLabel.font = QiCaiDetailTitle10Font;
        rechargeDetailLabel.textColor = QiCaiShallowColor;
        rechargeDetailLabel.textAlignment = NSTextAlignmentLeft;
        rechargeDetailLabel.numberOfLines = 0;
        [self.contentView addSubview:rechargeDetailLabel];
        self.rechargeDetailLabel = rechargeDetailLabel;

        
        //立即充值
        UIButton *instanceRechargeBtn = [[UIButton alloc]init];
        [instanceRechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        [instanceRechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [instanceRechargeBtn setBackgroundImage:[UIImage imageNamed:@"memberShipCard_cellNormal"] forState:UIControlStateNormal];
        [instanceRechargeBtn setBackgroundImage:[UIImage imageNamed:@"memberShipCard_cellSelect"] forState:UIControlStateHighlighted];
        instanceRechargeBtn.titleLabel.font = QiCai12PFFont;
        [instanceRechargeBtn addTarget:self action:@selector(clickInstantRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:instanceRechargeBtn];
        self.instanceRechargeBtn = instanceRechargeBtn;
        
    }
    return self;
}
-(void)setMembershipCardMode:(MembershipCardMode *)membershipCardMode
{
    _membershipCardMode = membershipCardMode;
    
    // 给子控件赋值
    [self setSubViewsData:membershipCardMode];
    
    // 设置子控件的frame
    [self setSubViewsFrame:membershipCardMode];
}
-(void)setSubViewsData:(MembershipCardMode *)membershipCardMode
{
    self.bjImageView.image = [UIImage imageNamed:@"memberShipCard_cell_backGround"];
    self.maneyImageView.image = [UIImage imageNamed:@"member_maneyAccount"];
    
    double sum = membershipCardMode.money.doubleValue + membershipCardMode.givemoney.doubleValue;

    self.rechargeLabel.text = [NSString stringWithFormat:@"充值%.2f元",sum];
    [UILabel setRichLabelText:self.rechargeLabel startStr:@"值" endStr:@"元" font:self.rechargeLabel.font color:QiCaiNavBackGroundColor];
    NSString *detailText;
    detailText = [NSString stringWithFormat:@"实付%.2f元,赠送%.2f元优惠券",[membershipCardMode.money floatValue],[membershipCardMode.Coupon floatValue]];
    self.rechargeDetailLabel.text = detailText;
    
}
-(void)setSubViewsFrame:(MembershipCardMode *)membershipCardMode
{
    self.bjImageView.frame = CGRectMake(QiCaiMargin, QiCaiMargin, MYScreenW - QiCaiMargin * 2, 90);
    self.maneyImageView.frame = CGRectMake(26, 26, 15, 15);
    self.rechargeLabel.frame = CGRectMake(CGRectGetMaxX(self.maneyImageView.frame) + QiCaiMargin, 26, 150, 15);
    
    // 指定我要以这个大小的字体显示
    NSDictionary *attributeDict = @{NSFontAttributeName : [UIFont systemFontOfSize:10]};
    // 最大范围
    CGSize maxSize = CGSizeMake(165, 60);
    // 就是totalMoneyLabel的size
    NSString *str = [NSString stringWithFormat:@"实付%.2f元,赠送%.2f元优惠券",[membershipCardMode.money floatValue],[membershipCardMode.Coupon floatValue]];
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    self.rechargeDetailLabel.frame = CGRectMake(CGRectGetMaxX(self.maneyImageView.frame) + QiCaiMargin, CGRectGetMaxY(self.rechargeLabel.frame) + 2, 165, size.height);
//    self.rechargeDetailLabel.backgroundColor = [UIColor orangeColor];
    self.instanceRechargeBtn.frame = CGRectMake(MYScreenW - 105, 26, 85, 30);
    
}


-(void)clickInstantRechargeButton:(UIButton *)btn
{
    if ([self.membershipCardDelegate respondsToSelector:@selector(clickInstantRechargeBtn:)]) {
        [self.membershipCardDelegate clickInstantRechargeBtn:btn];
    }
}
@end
