//
//  UIButton+extent.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (extent)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

/**
文字按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor font:(UIFont *)font Target:(id)target action:(SEL)action ;
/**
 图片按钮
 */
+ (instancetype)addButtonWithFrame:(CGRect)frame image:(NSString *)image highImage:(NSString *)highImage backgroundColor:(UIColor *)backgroundColor Target:(id)target action:(SEL)action;
+(instancetype)addBackBtnTarget:(id)target action:(SEL)action;
/*
 @brief 弹窗按钮
 */
+ (instancetype)addPopButtonWhiteTitle:(NSString *)title frame:(CGRect)frame titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor layerBorderColor:(UIColor *)layerBorderColor Target:(id)target action:(SEL)action;
/**
 @brief 底部的提交的btn
 @param title  提交按钮的文字
 @param rect  控件的位置
 @param target  对象
 @param action  方法
 @return 定义的btn
 */
+(instancetype)addZhuFuBtnWithTitle:(NSString *)title rect:(CGRect)rect Target:(id)target action:(SEL)action;
/**
 @brief 左图右边文字
 @param frame  控件的位置
 @param btnBackGroundColor 背景颜色
 @param leftNorImageName leftHeightImageName 图片
 @param color 文字的颜色
 @param imageEdge titleEdge 图片文字的偏移量
 @return 定义的btn
 */
+(instancetype)addBtnWithFrame:(CGRect)frame btnBackGroundColor:(UIColor *)btnBackGroundColor leftImageName:(NSString *)leftNorImageName leftHeightImageName:(NSString *)leftHeightImageName btnTitle:(NSString *)title titleColor:(UIColor *)color titltFont:(UIFont *)font imageEdge:(UIEdgeInsets)imageEdge titleEdge:(UIEdgeInsets)titleEdge;
/**
 右图片button
 */
+ (instancetype)addRightArrowBtnFrame:(CGRect)frame title:(NSString *)title color:(UIColor *)color imageName:(UIImage *)imageName target:(id)target action:(SEL)action;
/**
 @brief  带框的Button(自定义边框颜色)
 @param frame  控件的位置
 @param title
 @param color 文字的颜色
 @param font
 @param borderColor 边框颜色
 @param backGroundColor btn的背景颜色
 @param target 对象
 @param action 方法
 @param cornerRadiusFloat 边框的弧度
 @return 定义的btn
 */
+ (UIButton *)addButtonWithFrame:(CGRect)buttonFrame ButtonTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font borderColor:(UIColor *)borderColor backGroundColor:(UIColor *)backGroundColor Target:(id)target action:(SEL)action btnCornerRadius:(CGFloat)cornerRadiusFloat;
/*!
 @brief 设置Button富文本 ！！！注意开始的字符串位置和结束的位置之间要有距离 重复复制需要在之前加上 
 
***********  [self.discountBtn setAttributedTitle:nil forState:UIControlStateNormal];  **********
 否则无效

 @param label 传入的label
 @param startStr 开始的字符（为空默认从头开始）
 @param endStr   结束的字符（为空默认尾部结束）
 @param font  字体
 @param color 颜色
 */
+ (instancetype)setRichButtonText:(UIButton *)label startStr:(NSString *)startStr endStr:(NSString *)emdStr font:(UIFont *)font color:(UIColor *)color;
@end
