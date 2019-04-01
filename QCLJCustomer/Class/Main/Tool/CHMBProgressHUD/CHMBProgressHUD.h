//
//  CHMBProgressHUD.h
//  gaodePOI
//
//  Created by QCJJ－iOS on 16/10/13.
//  Copyright © 2016年 QCJJ－iOS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef enum{
    /**
     文字
     */
    CHProgressModeOnlyText=10,
    /**
     加载菊花
     */
    CHProgressModeLoading,
    /**
      加载圆形
     */
    CHProgressModeCircleLoading,
    /**
     自定义加载动画（序列帧实现）
     */
    CHProgressModeCustomAnimation,
    /**
     成功
     */
    CHProgressModeSuccess,
    /**
     失败
     */
    CHProgressModeFail,
    /**
     提示
     */
    CHProgressModePrompt,
    /**
     选择
     */
    CHProgressModeChoice,
    /**
     更新
     */
    CHProgressModeUpdate
}CHProgressMode;

//typedef enum{
//    /**
//     无结果
//     */
//    CHProgresAbnormalNoResultPopView=0,
//    /**
//     显示一个按钮
//     */
//    CHProgresAbnormalOneButtonPopView
//}CHProgressAbnormalPopViewMode;

@protocol PopDelegate <NSObject>

@optional
/**
 *  加减按钮点击响应的代理回调
 */
- (void)PopButton:(UIButton *)PopButton;
@end

@interface CHMBProgressHUD : NSObject


@property (nonatomic,strong) MBProgressHUD  *hud;

/** 代理*/
@property (nonatomic, weak) id<PopDelegate> popDelegate;

+(instancetype)shareinstance;
//显示
/*!
 @brief 文字及动画
 @param msg 文字
 @param view 加载的父类
 @param myMode 动画类型
 @return 无
 */
+(void)show:(NSString *)msg inView:(UIView *)view mode:(CHProgressMode )myMode;

//隐藏
+(void)hide;


/*!
 @brief 文字及动画 显示提示（1秒后消失）
 @param msg 文字
 @param view 加载的父类
 @param myMode 动画类型
 @return 无
 */
+(void)showMessage:(NSString *)msg inView:(UIView *)view;

/*!
 @brief 文字及动画 显示提示（1秒后消失）显示在最上面
 @param msg 文字
 @param view 加载的父类
 @param myMode 动画类型
 @return 无
 */
+(void)showMessage:(NSString *)msg;

/*!
 @brief 文字及动画 显示提示（N秒后消失）显示在最上面(用于布局时)特定环境下显示时间设置无效
 @param msg 文字
 @param view 加载的父类
 @param myMode 动画类型
 @return 无
 */
+(void)showMessage:(NSString *)msg afterDelayTime:(NSInteger)delay;
//
/*!
 @brief 文字及动画 显示提示（N秒后消失）
 @param msg 文字
 @param view 加载的父类
 @param myMode 动画类型
 @return 无
 */
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;

//显示进度(转圈)
+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view;

////显示进度(菊花)
//+(void)showProgress:(NSString *)msg inView:(UIView *)view;
/**
 *  //显示进度(菊花) 显示在最上面
 *
 *  @param msg 文字
 */
+(void)showProgress:(NSString *)msg;

////显示成功提示
//+(void)showSuccess:(NSString *)msg inview:(UIView *)view;

#pragma mark --总方法
+(void)showPopView:(UIView *)view mode:(CHProgressMode )myMode title:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr;

#pragma mark - 成功失败状态可以自动消失
/**
 //显示成功提示 显示在最上面
 */
+(void)showSuccess:(NSString *)msg;
/**
 //显示失败提示 显示在最上面
 */
+(void)showFail:(NSString *)msg ;
/**
 //显示提示 显示在最上面
 */
+(void)showPrompt:(NSString *)msg ;
#pragma mark --
#pragma mark --温馨提示双按钮
/**
 //温馨提示带按钮
 */
+ (void)showPromptWithMessage:(NSString *)message buttonArr:(NSArray *)buttonArr;
#pragma mark --双按钮
/**
 //双按钮
 */
+ (void)showTowBtnWtihTiitle:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr mode:(CHProgressMode )myMode;
#pragma mark --更新上下双按钮
/**
 //-更新上下双按钮
 */
+ (void)showUpdateTiitle:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr;
#pragma mark --单按钮
/**
 //单按钮
 */
+ (void)showOneBtnWtihTiitle:(NSString *)title message:(NSString *)message btnName:(NSString *)btnName mode:(CHProgressMode )myMode ;
#pragma mark - 失败一个按钮
/**
 //失败一个按钮
 */
+ (void)showFailOneBtnWtihTiitle:(NSString *)title;
#pragma mark - 选择订单提交
/**
 //选择订单提交
 */
+ (void)showPromptWithTitle:(NSString *)title buttonArr:(NSArray *)buttonArr;

/**
 *  //在最上层显示单独显示文字
 *
 *  @param msg 文字
 */
+(void)showMsgWithoutView:(NSString *)msg;

//显示自定义动画(自定义动画序列帧  找UI做就可以了)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;
//显示自定义动画(自定义动画序列帧  找UI做就可以了)
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry;


@end
