//
//  UITabBar+XSDExt.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/16.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XSDExt)

/*!
 @brief 显示小红点
 @param index 表示第几个tabber
 @return 无
 */
- (void)showBadgeOnItemIndex:(NSInteger)index;
/*!
 @brief 隐藏小红点
 @param index 表示第几个tabber
 @return 无
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;
@end
