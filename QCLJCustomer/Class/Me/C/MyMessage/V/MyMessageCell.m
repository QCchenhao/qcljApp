//
//  MyMessageCell.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyMessageCell.h"
#import "Comment.h"
#import "MyMessageMode.h"

@interface MyMessageCell()
@property (weak,nonatomic)  UIImageView *iconImageView;
@property (weak,nonatomic)  UILabel *topLabel;
@property (weak,nonatomic)  UILabel *detailLabel;
@property (weak,nonatomic)  UILabel *timeLabel;

@end
@implementation MyMessageCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *MyMessageID = @"MyMessageCell";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MyMessageID];
    if (cell == nil) {
        cell = [[MyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyMessageID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加自己可能显示的所有子控件
        self.backgroundColor = [UIColor whiteColor];
        //cell的左边的图片
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        self.iconImageView = imageView;
        
        //最新优惠活动
        UILabel *topLabel = [[UILabel alloc]init];
        topLabel.font = QiCaiDetailTitle12Font;
        topLabel.textColor = QiCaiDeepColor;
        topLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:topLabel];
        self.topLabel = topLabel;
        
        //欢迎
        UILabel *detailLabel = [[UILabel alloc]init];
        detailLabel.font = QiCaiDetailTitle10Font;
        detailLabel.textColor = QiCaiShallowColor;
        detailLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        
        //时间
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = QiCaiDetailTitle10Font;
        timeLabel.textColor = QiCaiDeepColor;
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
    }
    return self;
}
-(void)setMyMessageMode:(MyMessageMode *)myMessageMode
{
    // 给子控件赋值
    [self setSubViewsData:myMessageMode];
    
    // 设置子控件的frame
    [self setSubViewsFrame:myMessageMode];
    
}
-(void)setSubViewsData:(MyMessageMode *)myMessageMode
{
    self.iconImageView.image = [UIImage imageNamed:@"details_discount"];
    self.topLabel.text = [NSString stringWithFormat:@"%@",myMessageMode.newsname];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",myMessageMode.newsname];
//    self.timeLabel.text = [NSString stringWithFormat:@"%@",myMessageMode.time];
    
}
-(void)setSubViewsFrame:(MyMessageMode *)myMessageMode
{
    self.iconImageView.frame = CGRectMake(15, 15, 20, 20);
    self.topLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + QiCaiMargin, 15, MYScreenW - CGRectGetMaxX(self.iconImageView.frame) - QiCaiMargin, 15);
    self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + QiCaiMargin, CGRectGetMaxY(self.topLabel.frame), MYScreenW - CGRectGetMaxX(self.iconImageView.frame) - 110, 15);
    self.timeLabel.frame = CGRectMake(MYScreenW - 100, CGRectGetMaxY(self.topLabel.frame), 90, 15);
    
}
@end
