//
//  UITextField+Category.h
//  七彩乐居
//
//  Created by 李大娟 on 16/10/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/*!
 @brief 设置导航栏按钮
 @param imageName 按钮图片名称
 @param higImageName 按钮图片高亮状态名称
 @param action 按钮触发的方法
 @param target 代理
 @return 新生成的 UIBarButtonItem 类型 导航栏按钮
 */
+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName higImageName:(NSString *)higIamgeName action:(SEL)action target:(id)target;

/*!
 @brief 设置导航栏按钮可设置adjustment
 @param imageName 按钮图片名称
 @param adjustment 按钮垂直位移
 @param action 按钮触发的方法
 @param target 代理
 @return 新生成 UIBarButtonItem 类型的导航栏按钮
 */
+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName ButtonAdjustment:(CGFloat)adjustment action:(SEL)action target:(id)target;
/*!
 @brief 设置导航栏按钮简化版默认adjustment为5.0
 @param imageName 按钮图片名称
 @param adjustment 按钮垂直位移
 @param action 按钮触发的方法
 @param target 代理
 @return 新生成 UIBarButtonItem 类型的导航栏按钮
 */
+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName  action:(SEL)action target:(id)target;
/*!
 @brief 传入button
 @param buttton 按钮图片名称
 @param adjustment 按钮垂直位移
 @return 新生成 UIBarButtonItem 类型的导航栏按钮
 */
+(UIBarButtonItem *)barButtonItemWithButton:(UIButton *) buttton ButtonAdjustment:(CGFloat)adjustment;
/*!
 @brief 传入button默认adjustment为10.0
 @param buttton 按钮图片名称
 @return 新生成 UIBarButtonItem 类型的导航栏按钮
 */
+(UIBarButtonItem *)barButtonItemWithButton:(UIButton *) buttton ;

/**
 @brief 文字
 @param title 文字
 @param titeColor  文字颜色
 @param action 按钮触发的方法
 @param target 代理
 @return 新生成 UIBarButtonItem 类型的导航栏按钮
 */
+(UIBarButtonItem *)addBarBtnItemWithTItle:(NSString *)title titleColor:(UIColor *)titeColor target:(id)target action:(SEL)action;

@end
