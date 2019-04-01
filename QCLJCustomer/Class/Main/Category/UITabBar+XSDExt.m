//
//  UITabBar+XSDExt.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/16.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UITabBar+XSDExt.h"

#import "QiCaiNavigationController.h"

//#define TabbarItemNums  self.items.count    //tabbar的数量 如果是5个设置为5

@implementation UITabBar (XSDExt)

//显示小红点
- (void)showBadgeOnItemIndex:(NSInteger)index{


    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
//    badgeView.layer.cornerRadius = 5.0;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 7.0, 7.0);//圆形大小为10
    badgeView.layer.cornerRadius = CGRectGetHeight(badgeView.frame) / 2;//圆形
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(NSInteger)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
