//
//  UILabel+extent.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/24.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extent)
#pragma mark - 最全label->
+ (instancetype)addLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment lineSpacing:(CGFloat)lineSpacing layerCornerRadius:(CGFloat)layerCornerRadius layerBorderWidth:(CGFloat)layerBorderWidth layerBorderColor:(UIColor *)layerBorderColor;
#pragma mark - 字体颜色单行无行间距无框->
/*!
 @brief 字体颜色单行无行间距无框
 @param frame 位置
 @param text  内容
 @param textColor 字体颜色
 @param backgroundColor 背景颜色
 @param size 字体大小
 @param textAlignment 居
 @return 返回label
 */
+ (instancetype)addNoLayerLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment;
#pragma mark - 字体颜色单行无行间距无框-无背景颜色无字体颜色>
/*!
 @brief 字体颜色单行无行间距无框-无背景颜色无字体颜色
 @param frame 位置
 @param text  内容
 @param size 字体大小
 @param textAlignment 居
 @return 返回label
 */
+ (instancetype)addLabelWithFrame:(CGRect)frame text:(NSString *)text size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment;
#pragma mark - label左图右文单行->
/*!
 @brief label左图右文单行
 @param image 左边显示图片
 @param interval 图片文字间隔
 @param frame 位置
 @param text  内容
 @param size 字体大小
 @param textAlignment 居

 @return 返回label
 */
+ (instancetype)addLeftImageAndLabelWithImgeName:(UIImage *)image interval:(NSInteger)interval frame:(CGRect)frame imageFrame:(CGRect)imageFrame text:(NSString *)text textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size textAlignment:(NSTextAlignment)textAlignment;
/*!
 @brief 字体颜色单行无行间距有框-无背景颜色居中
 @param layerCornerRadius 圆角
 @param layerBorderWidth  框宽度
 @param layerBorderColor 框颜色
 @return 返回label
 */
+ (instancetype)addLayerLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor size:(CGFloat)size layerCornerRadius:(CGFloat)layerCornerRadius layerBorderWidth:(CGFloat)layerBorderWidth layerBorderColor:(UIColor *)layerBorderColor;

/*!
 @brief 字体颜色多行有行间距
 @param layerCornerRadius 圆角
 @param layerBorderWidth  框宽度
 @param layerBorderColor 框颜色
 @return 返回label
 */
+ (instancetype)addLayerLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor size:(CGFloat)size lineSpacing:(CGFloat)lineSpacing;
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;
//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;
/*!
 @brief 设置Label富文本 ！！！注意开始的字符串位置和结束的位置之间要有距离
 @param label 传入的label
 @param startStr 开始的字符（为空默认从头开始）
 @param endStr   结束的字符（为空默认尾部结束）
 @param font  字体
 @param color 颜色
 */
+ (instancetype)setRichLabelText:(UILabel *)label startStr:(NSString *)startStr endStr:(NSString *)emdStr font:(UIFont *)font color:(UIColor *)color;

@end
