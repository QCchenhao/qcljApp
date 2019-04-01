//
//  MyNavBar.m
//  七彩乐居
//
//  Created by 李大娟 on 16/3/16.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyNavBar.h"
#import "Comment.h"

#define HomeNavTopY 13

@implementation MyNavBar
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //添加nav的子控件
        UIButton *leftBtn = [[UIButton alloc]init];
        leftBtn.imageView.contentMode = UIViewContentModeCenter;
        leftBtn.backgroundColor = [UIColor clearColor];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = QiCaiDetailTitle12Font;
        self.leftBtn = leftBtn;
        [self addSubview:leftBtn];
               
        //添加nav的子控件
        UIButton *rightBtn = [[UIButton alloc]init];
        rightBtn.imageView.contentMode = UIViewContentModeCenter;
        rightBtn.backgroundColor = [UIColor clearColor];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightBtn.titleLabel.font = QiCaiDetailTitle12Font;
        self.rightBtn = rightBtn;
        [self addSubview:rightBtn];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = QiCaiNavTitle14Font;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftBtn.frame = CGRectMake(10, HomeNavTopY + 15, 12, 19);
    self.rightBtn.frame = CGRectMake(MYScreenW - 75, HomeNavTopY + 10 , 60, 30);
    self.titleLabel.frame = CGRectMake(70, HomeNavTopY + 8,MYScreenW - 140 , 30);
    self.rightBtn.centerY = self.titleLabel.centerY;
    self.leftBtn.centerY = self.titleLabel.centerY;
}

@end
