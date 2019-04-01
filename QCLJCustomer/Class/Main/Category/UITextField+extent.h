//
//  GiftCardViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"


@interface UITextField (extent)
/**
 @brief 快速创建
 @param frame 位置
 @param target 代理
 @param contentView  添加到的view
 @param font 字体大小
 @param color  字体的颜色
 @param palceTitle  站位位子
 @param palceHolderTitleColor  站位文字颜色
 @param textFieldBorderColor  边框的颜色
 @param borderWidth  边框的宽度
 @return 返回UITextField
 */
+(UITextField *)addTextFieldWithFrame:(CGRect)rect textFieldDelegate:(id)target contentView:(UIView *)contentView textFieldFont:(UIFont *)font backGroundColor:(UIColor *)color attributedPlaceholder:(NSString *)palceTitle palceHolderTitleColor:(UIColor *)palceHolderTitleColor textFieldBorderColor:(UIColor *)textFieldBorderColor borderWidth:(CGFloat)borderWidth;

@end
