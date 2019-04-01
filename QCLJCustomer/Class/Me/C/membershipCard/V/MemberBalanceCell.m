//
//  MemberBalanceCell.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/2.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MemberBalanceCell.h"
#import "MemberBalanceMode.h"
#import "Comment.h"

@interface MemberBalanceCell()
@property (weak,nonatomic)  UILabel *timeOneLabel;
@property (weak,nonatomic)  UILabel *timeTwoLabel;
@property (weak,nonatomic)  UIButton *consumptionBtn;

@property (weak,nonatomic)  UIView *topLineView;
@property (weak,nonatomic)  UIView *circularView;
@property (weak,nonatomic)  UIView *bottomLineView;

@property (weak,nonatomic)  UIImageView *cellImageView;
@property (weak,nonatomic)  UILabel *orderNumberLable;
@property (weak,nonatomic)  UILabel *memberIDLabel;
@property (weak,nonatomic)  UILabel *accountOfManeyLabel;

@end
@implementation MemberBalanceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
   static NSString *MemberBalanceCellID = @"MemberBalanceCell";
    
    MemberBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberBalanceCellID];
    if (cell == nil) {
        cell = [[MemberBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MemberBalanceCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加自己可能显示的所有子控件
        //2016-10-21
        UILabel *timeOneLabel = [[UILabel alloc]init];
        timeOneLabel.font = QiCaiDetailTitle10Font;
        timeOneLabel.textColor = QiCaiDeepColor;
        timeOneLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeOneLabel];
        self.timeOneLabel = timeOneLabel;
        
        //15:18
        UILabel *timeTwoLabel = [[UILabel alloc]init];
        timeTwoLabel.font = QiCaiDetailTitle10Font;
        timeTwoLabel.textColor = QiCaiDeepColor;
        timeTwoLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:timeTwoLabel];
        self.timeTwoLabel = timeTwoLabel;
        
        //消费成功
        UIButton *consumptionBtn = [[UIButton alloc]init];
        [consumptionBtn setTitle:@"消费成功" forState:UIControlStateNormal];
        [consumptionBtn setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateNormal];
        consumptionBtn.titleLabel.font = QiCaiDetailTitle10Font;
        consumptionBtn.layer.borderColor = QiCaiNavBackGroundColor.CGColor;
        consumptionBtn.layer.borderWidth = 0.5;
        [self.contentView addSubview:consumptionBtn];
        self.consumptionBtn = consumptionBtn;
        
        //顶部的线
        UIView *topLineView = [[UIView alloc]init];
        topLineView.backgroundColor = QiCaiNavBackGroundColor;
        [self.contentView addSubview:topLineView];
        self.topLineView = topLineView;
        
        //中间的圆
        UIView *circularView = [[UIView alloc]init];
        circularView.backgroundColor = QiCaiNavBackGroundColor;
        [self.contentView addSubview:circularView];
        self.circularView = circularView;
        
        //底部的线
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = QiCaiNavBackGroundColor;
        [self.contentView addSubview:bottomLineView];
        self.bottomLineView = bottomLineView;
        
        //cell的框
        UIImageView *cellImageView = [[UIImageView alloc]init];
//        cellImageView.userInteractionEnabled = YES;
        cellImageView.image = [UIImage imageNamed:@"me_member_cell"];
        [self.contentView addSubview:cellImageView];
        self.cellImageView = cellImageView;
        
        //订单号
        UILabel *orderNumberLable = [[UILabel alloc]init];
        orderNumberLable.font = QiCaiDetailTitle10Font;
        orderNumberLable.textColor = QiCaiShallowColor;
        orderNumberLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:orderNumberLable];
        self.orderNumberLable = orderNumberLable;
        
        //订单号
        UILabel *memberIDLabel = [[UILabel alloc]init];
        memberIDLabel.font = QiCaiDetailTitle10Font;
        memberIDLabel.textColor = QiCaiShallowColor;
        memberIDLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:memberIDLabel];
        self.memberIDLabel = memberIDLabel;
        
        //金额
        UILabel *accountOfManeyLabel = [[UILabel alloc]init];
        accountOfManeyLabel.font = QiCaiDetailTitle10Font;
        accountOfManeyLabel.textColor = QiCaiShallowColor;
        accountOfManeyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:accountOfManeyLabel];
        self.accountOfManeyLabel = accountOfManeyLabel;
        
        }
    return self;
}

-(void)setMemberBalanceMode:(MemberBalanceMode *)memberBalanceMode
{
    // 给子控件赋值
    [self setSubViewsData:memberBalanceMode];
    
    // 设置子控件的frame
    [self setSubViewsFrame:memberBalanceMode];
}

-(void)setSubViewsData:(MemberBalanceMode *)memberBalanceMode
{
    _memberBalanceMode = memberBalanceMode;
    

    NSString* string = memberBalanceMode.time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSLog(@"date = %@", inputDate);
    

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    NSDateFormatter *outputFormatter2 = [[NSDateFormatter alloc] init];
    [outputFormatter2 setLocale:[NSLocale currentLocale]];
    [outputFormatter2 setDateFormat:@"HH:mm"];
    NSString *str2 = [outputFormatter2 stringFromDate:inputDate];

    
    self.timeOneLabel.text = [NSString stringWithFormat:@"%@",str];
    self.timeTwoLabel.text = [NSString stringWithFormat:@"%@",str2];
    
    if (memberBalanceMode.isTopShow) {
        self.topLineView.hidden = NO;
    }else
    {
        self.topLineView.hidden = YES;
    }
    if (memberBalanceMode.isBottomShow) {
        self.bottomLineView.hidden = NO;
    }
    else
    {
        self.bottomLineView.hidden = YES;
    }
    
    self.orderNumberLable.text = [NSString stringWithFormat:@"订单号：%@",memberBalanceMode.cnum];
    self.memberIDLabel.text = [NSString stringWithFormat:@"会员卡：%@",self.memcardNum];
    
    if ([memberBalanceMode.type isEqualToString:@"68"]) {//68 消费 99充值
        
        [self.consumptionBtn setTitle:@"消费成功" forState:UIControlStateNormal];
        self.accountOfManeyLabel.text = [NSString stringWithFormat:@"金   额：-%.2f元",[memberBalanceMode.money floatValue]];
    
    }else if ([memberBalanceMode.type isEqualToString:@"99"])
    {
        [self.consumptionBtn setTitle:@"充值成功" forState:UIControlStateNormal];
        self.accountOfManeyLabel.text = [NSString stringWithFormat:@"金   额：+%.2f元",[memberBalanceMode.money floatValue]];
    }
    

}
-(void)setSubViewsFrame:(MemberBalanceMode *)memberBalanceMode
{
    self.timeOneLabel.frame = CGRectMake(35, 20, 60, 15);
    self.timeTwoLabel.frame = CGRectMake(35, CGRectGetMaxY(self.timeOneLabel.frame) + 2, 60, 15);
    self.consumptionBtn.frame = CGRectMake(35,CGRectGetMaxY(self.timeTwoLabel.frame) + 2, 60, 15);
    self.consumptionBtn.layer.cornerRadius = 8.5;
    
    self.topLineView.frame = CGRectMake(CGRectGetMaxX(self.consumptionBtn.frame) + 22, 0, 1, 38);
    
    self.circularView.frame = CGRectMake(CGRectGetMaxX(self.consumptionBtn.frame) + 21, 37, 8, 8);
    self.circularView.layer.cornerRadius = 4;
    
    self.bottomLineView.frame = CGRectMake(CGRectGetMaxX(self.consumptionBtn.frame) + 23, CGRectGetMaxY(self.circularView.frame), 1, 25);
    self.topLineView.centerX = self.circularView.centerX;
    self.bottomLineView.centerX = self.circularView.centerX;
    
    self.cellImageView.frame = CGRectMake(CGRectGetMaxX(self.circularView.frame) + 21, 10, MYScreenW - CGRectGetMaxX(self.circularView.frame)  - 31 , 60);
    self.orderNumberLable.frame = CGRectMake(CGRectGetMaxX(self.circularView.frame) + 50, 21, MYScreenW - CGRectGetMaxX(self.circularView.frame) - 60, 15);
    self.memberIDLabel.frame = CGRectMake(CGRectGetMaxX(self.circularView.frame) + 50, CGRectGetMaxY(self.orderNumberLable.frame) , MYScreenW - CGRectGetMaxX(self.circularView.frame) - 60, 15);
    self.accountOfManeyLabel.frame = CGRectMake(CGRectGetMaxX(self.circularView.frame) + 50, CGRectGetMaxY(self.memberIDLabel.frame), MYScreenW - CGRectGetMaxX(self.circularView.frame) - 60, 15);
}
@end
