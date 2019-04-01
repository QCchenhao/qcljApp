//
//  UIView+Extension.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/13.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyNavBar;

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
NS_ASSUME_NONNULL_BEGIN
/**
 myNavBar 左图中文
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString   *)centerTitle addTarget:(nullable id)target action:(SEL)action contentView:(UIView *)view;
/**
 myNavBar 左图中文右文
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString * __nonnull)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightTitle:(NSString * __nonnull)rightTitle addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view;
/**
 myNavBar 左图中文右图 左边是返回的
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString *)centerTitle addLeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightImageName:(NSString * __nonnull)rightImageName addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view;
/**
 myNavBar 左图中文右图 自定义图片
 */
+(void)addMyNavBarWithFrame:(CGRect)frame centerTitle:(NSString *)centerTitle addleftImage:(NSString *)leftImageName LeftTarget:(nullable id)LeftTarget leftAction:(SEL)leftAction rightImageName:(NSString *)rightImageName addrightTarget:(nullable id)rightTarget rightAction:(SEL)rightAction contentView:(UIView *)view;

/**
 分割线  x = 36  右边是有间距的
 */
+(UIView *)addHLineWithY:(CGFloat)lineY lineX:(CGFloat)lineX contentView:(UIView *)contentView;
/**
 分割线
 */
+(UIView *)addHLineWithlineX:(CGFloat)lineX lineY:(CGFloat)lineY  contentView:(UIView *)contentView;


NS_ASSUME_NONNULL_END

@end
