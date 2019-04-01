//
//  CHTextField.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/10/17.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Comment.h"

typedef NS_ENUM(NSInteger, CHTextFieldType) {
    /**无限制**/
    CHTextFieldTypeUnlimitedCH = 0,
    /**姓名，限制输入为汉字英文**/
    CHTextFieldTypeName  = 1,
    /**电话，手机**/
    CHTextFieldTypeTelephone = 2,
    /**金额加小数点**/
    CHTextFieldTypeAmountOfMoney   = 3,
    /**银行卡 **/
    CHTextFieldTypeUserIdCard   = 4,
    /**密码 **/
    CHTextFieldTypePassword   = 5,
};

//typedef  struct{  //自定义一个结构体
//    CGFloat width;
//    CGFloat height;
//}CHSize;


@protocol CHTextFieldDelegate <NSObject>

@optional
/**
 *  监听text输入长度
 */
- (void)CHTextFieldDidChange:(UITextField *)textField;

@end


@interface CHTextField : UITextField <UITextFieldDelegate>

/** 代理*/
@property (nonatomic, strong) id<CHTextFieldDelegate> cHTextFieldDidChangeDelegate;

/*!
 @brief bock回调格式是否正确
 @param 参数说明
 @return 返回说明
 */
@property (nonatomic, copy) void(^formatBlock)(BOOL isFormat);
/*!
 @brief bock回调匹配的银行名称
 @param bankName  银行名称
 @param cardTypeName  银行卡类型名称
 @return 返回说明
 */
@property (nonatomic, copy) void(^backBankenameBlock)(NSString * bankName, NSString * cardTypeName);
/*!
 @brief bock回调金额
 @return 返回说明
 */
@property (nonatomic, copy) void(^payMoneyBlock)(NSString * payMoneyStr);
/*!
 @brief 代理设置为自己（使用代理方法为必须设定属性）
 */
@property (nonatomic,strong) id CHDelegate;

/** 
 TextField的类型,默认为无类型
 */
@property (nonatomic)CHTextFieldType  cHTextFieldType;


/** 是否开启抖动动画,默认NO*/
@property (nonatomic, assign, getter=isChShakeAnimation) IBInspectable BOOL chShakeAnimation;
//#pragma 根据输入银行卡号判断银行
//+ (NSString *)backbankenameWithBanknumber:(NSString *)banknumber;
/**
 placeholderLabel字体颜色
 */
@property (nonatomic,strong) UIColor * placeholderTextColor;
/**
 placeholderLabel字体大小
 */
@property (nonatomic,strong) UIFont * placeholderLabelFont;

#pragma mark - 方法-------->
/*!
 @brief CHTextFile左对齐头 有左图片 有边框（灰）
 @param leftImageName  左图名称
 @param frame  位置
 @param placeholder  占位文字
 @param placeholderLabelFont  占位文字大小
 @param placeholderTextColor  占位文字颜色
 @return CHTextFile
 */
+ (instancetype)addCHTextFileWithLeftImage:(NSString *)leftImageName frame:(CGRect)frame placeholder:(NSString *)placeholder placeholderLabelFont:(CGFloat)placeholderLabelFont placeholderTextColor:(UIColor *)placeholderTextColor;
@end
