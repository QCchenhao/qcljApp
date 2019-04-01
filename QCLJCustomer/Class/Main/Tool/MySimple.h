//
//  MySimple.h
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface MyChView : UIView

@end
typedef enum : NSUInteger {
    MySimpleImageTypeNo,
    MySimpleImageTypeOrderSearch,
} MySimpleImageType;

@interface MySimple : NSObject

//@property (nonatomic,strong) MyChView * myView;

+(UIView *)simpleInterests;
///** alertView的回调block */
//
//typedef void (^ReturnBtnBlock)();
//
//@property (nonatomic, copy) ReturnBtnBlock btnBlock;
//- (void)returnText:(ReturnBtnBlock)block;
/**
 @brief CHTextFile 给textfield添加右边的取消图片
 @param textField  需要改变的控件
 @param  rightImageName 右边的图片名字
 @param rightWidth  右边的图片的宽度
 @param rightHeight  右边的图片的高度
 */
+(void)addRightViewWithTextField:(UITextField *)textField imageName:(NSString *)rightImageName rightWidth:(CGFloat)rightWidth  rightHeight:(CGFloat)rightHeight;


/**
 @brief 提交的btn
 @param  frame btn的位置
 @param title
 @param titleFont
 @param norImageName  highImageName
 @param target  action
 @param return view
 */
+(UIButton *)addSummitBtnWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)titleFont norImageName:(NSString *)norImageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;



/**
@brief 占位view 没有查询到你想要的结果
 @param  frame view的位置
 @param mySimplyImageTpye view内部的图片，使用枚举区分
 @param topTitle  图片下面的第一行的提示文字
 @param bottomTitle  下面的第二行的提示文字
 @param return view
 */
+(UIView *)addViewWithFrame:(CGRect)frame imageType:(MySimpleImageType)mySimplyImageTpye topTitle:(NSString *)topTitle topFont:(CGFloat)topFont topTitleColor:(UIColor *)topTitleColor bottomTitle:(NSString *)bottomTitle bottomFont:(CGFloat)bottomFont bottomColor:(UIColor *)bottomColor View:(UIView *)view;


/**
 @brief 占位view  下面带按钮的
 @param  frame view的位置
 @param mySimplyImageTpye view内部的图片，使用枚举区分
 @param topTitle  图片下面的第一行的提示文字
 @param bottomTitle  下面的第二行的提示文字
 @param btn 下面的点击按钮 例如重新加载等
 @param return view
 */
+(UIView *)addViewWithFrame:(CGRect)frame imageType:(MySimpleImageType)mySimplyImageTpye topTitle:(NSString *)topTitle topFont:(CGFloat)topFont topTitleColor:(UIColor *)topTitleColor bottomTitle:(NSString *)bottomTitle bottomFont:(CGFloat)bottomFont bottomColor:(UIColor *)bottomColor bottonBtnTitle:(NSString *)btnTitle btnWidth:(CGFloat)btnWidth btnHeight:(CGFloat)btnHigh target:(id)target action:(SEL)action View:(UIView *)view;

+(NSString *)changeCountWithNsstring:(NSString *)str;

@end

