//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyBaseCell.h"
#import "Comment.h"

@interface MyBaseCell()

@property (strong, nonatomic) UIImageView *rightArrow;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) UILabel *detailLabel;

@end
@implementation MyBaseCell
// 创建辅助视图并一次性初始化
-(UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
        self.rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_icon_arrow"]];
    }
    return _rightArrow;
}

+(instancetype)CellWithTableView:(UITableView *)tableView
{
    static NSString *str = @"meCell";
    MyBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[MyBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.textLabel.font = QiCai12PFFont;
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = QiCai12PFFont;
        self.textLabel.textColor = QiCaiDeepColor;
        self.detailTextLabel.font = QiCai10PFFont;
        self.detailTextLabel.textColor = QiCaiShallowColor;
        
    }
    return self;
}

-(void)setCellMode:(MyBaseCellMode *)cellMode
{
    _cellMode = cellMode;
    
    if (cellMode.icon) {
        
        self.imageView.image = [UIImage imageNamed:cellMode.icon];
       
    }
    if (cellMode.subTitle) {
        
        self.detailTextLabel.text = cellMode.subTitle;
    }

    self.textLabel.text = cellMode.title;
    
    if ([cellMode isKindOfClass:[MyBaseCellArrowMode class]]) {
        self.accessoryView = self.rightArrow;
    }
    else
    {
        self.accessoryView = nil;
        
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.cellMode.icon) {
        
        CGFloat maxX = CGRectGetMaxX(self.imageView.frame);
        self.textLabel.x = maxX + 10;
    }
    else{
        self.textLabel.x = 20;
    }
    
}

@end
