//
//  HomeQuickBtnBaseClassViewController.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/1.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QCBaseViewController.h"

#import "Comment.h"
#import "JLDoubleSlider.h"//滑竿

#import "SDCycleScrollView.h"//滚动图
#import "SDCycleScrollView+extent.h"//滚动图分类

#import "HMDatePickView.h"//时间选择器
#import "SQMenuShowView.h"//服务时长弹窗
#import "ServiceAddressViewController.h"//服务地址

#import "ThirdPartyLoginViewController.h"//登录

#import "PPNumberButton.h"//加减

#import <IQKeyboardReturnKeyHandler.h>//键盘第三方


//@class NannyViewController;
//@class ParentalViewController;
//@class MaternityMatronViewController;
//@class HomePackageViewController;
//@class EnterpriseServiceViewController;
//@class StorePaymentViewController;

//#import "NannyViewController.h"//
//#import "ParentalViewController.h"//
//#import "MaternityMatronViewController.h"//
//#import "HomePackageViewController.h"//
//#import "EnterpriseServiceViewController.h"//
//#import "StorePaymentViewController.h"//

typedef void (^ReturnHomeBlock)();


@interface HomeQuickBtnBaseClassViewController : QCBaseViewController<UIScrollViewDelegate,SDCycleScrollViewDelegate,PopDelegate>
/**
 *  键盘设置
 */
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
/**
 *  操作回调
 */
#pragma mark - block回调
@property (nonatomic, copy) ReturnHomeBlock returnHomeBlock;
- (void)returnHomeBlock:(ReturnHomeBlock)block;
#pragma mark - 子类属性
//订单提交需要的数据
@property (nonatomic,strong)  UIButton * homeDurationBtn;//服务时长所在button--显示的内容
@property (nonatomic,copy)  NSString * homeDurationStr;//服务时长所在button--接口传送的内容*
@property (nonatomic, copy) NSString *homeDateStr;//选择的日期*
@property (weak, nonatomic)UIButton * homeBtn;//设置默认住家*
@property (nonatomic, copy) NSString * homeAddressId;//默认地址ID*
@property (nonatomic, copy) NSString * homeOrderType;//订单类型
//@property (nonatomic, copy) NSString * home

@property (strong, nonatomic)NSString * homeOtherEducationStr;//选择的学历
@property (strong, nonatomic)NSString * homeOtherAgeStr;//选择的年龄
@property (strong, nonatomic)NSString * homeOtherCertificatesStr;//选择的证书
@property (nonatomic,strong) CHTextField * nameChTextFile;//联系人
@property (nonatomic,strong)CHTextField * telephoneChTextFile;//手机号
@property (nonatomic,strong)NSMutableArray * nannyPetArr;//选择的宠物
/**
 保姆 属性
 */
@property (nonatomic,strong)UILabel * homeSliderHouseLabel;// 设置房屋面积label*
@property (nonatomic,strong)UILabel * homeSliderPriceLabel;// 设置心理价位label*
@property (weak, nonatomic)UIButton * homeFlavorBtn1;//单选口味*

/**
  育儿嫂 属性
 */
@property (weak, nonatomic) UIButton * babyAgeBtn;//宝宝年龄
@property (weak, nonatomic)UIButton * menAndWomenBtn;//男宝宝女宝宝
/**
 月嫂 属性
 */
@property (weak, nonatomic)UIButton *starBtn;//星级按钮
/**
 家政套餐 属性
 */
@property (nonatomic, copy) NSString * cleaningServiceNuber;//保洁服务套餐数量
/**
 企业服务 属性
 */
@property (nonatomic,strong) CHTextField * enterpriseTextField;




@property (nonatomic,strong)UIView *addressTEmpView;
//@property (weak, nonatomic)UIButton * petBtn;
//@property (weak, nonatomic)UIButton * otherBtn1;
//@property (strong, nonatomic) CHTextField * addressCHTextFile;
@property (nonatomic,strong) UILabel * addressLabel;
//@property (nonatomic,strong) CHTextField * addressTextField;//未登录状态下地址*
@property (strong, nonatomic) UIButton *  dateBtn;//选择的日期

//@property (nonatomic,strong)NSMutableArray * petArr;//选择的宠物
//@property (nonatomic,weak) UIButton * otherBtn;
@property (nonatomic,strong) NSArray * otherArr;//其他按钮文字数组
@property (nonatomic) NSInteger otherInder;//当前弹窗的下标
@property (strong, nonatomic)NSArray * otherEducationArr;//点击学历弹窗按钮数组
@property (strong, nonatomic)NSArray * otherAgeArr;//点击年龄弹窗按钮数组
@property (strong, nonatomic)NSArray * otherCertificatesArr;//点击证书弹窗按钮数组

@property (strong, nonatomic)UIView * otherView;//其他需求View

@property (strong, nonatomic)  SQMenuShowView *showView;//服务时长 弹窗view
@property (assign, nonatomic)  BOOL  isShow;//服务时长弹窗显示

@property (nonatomic,strong) UIView * durationView; //服务时长所在view
@property (nonatomic,strong)NSArray * popArr;//服务时长弹窗数据
@property (weak, nonatomic)UIScrollView *scrollView;

//@property (nonatomic,strong)UIButton * reservButton;//预定按钮

#pragma mark - 子类方法
/*
 住家
 */
- (void)homeButtonChlie:(UIButton *)btn;
//- (void)PopButton:( NSInteger)PopButtonIndex;
/*
 其他
 */
- (void)otherButtonChlie:(UIButton *)btn;
/*
 服务地址
 */
- (void)addressBtnChlie:(UIButton *)btn;
/*
 服务时间
 */
- (void)dateBtnChlie:(UIButton *)btn;
/*
 服务时长
 */
- (void)homeDurationBtnChlie:(UIButton *)btn;

/**
 设置房屋面积最小值
 */
@property (nonatomic,copy)NSString * minHouseNum;
/**
 设置房屋面积最大值
 */
@property (nonatomic,copy)NSString * maxHouseNum;

/**
 设置心理价位最小值
 */
@property (nonatomic,copy)NSString * minPriceNum;
/**
 设置心理价位最大值
 */
@property (nonatomic,copy)NSString * maxPriceNum;
/**
 提交接口
 */
- (void)AFNPlaceOrderWith:(NSString *)orderType btn:(UIButton *)btn;
/**
 滑竿方法
 */
- ( UILabel *)addSlider:(UIView *)sliderVeiw labelImage:(NSString *)labelImage titleLabelText:(NSString *)titleLabelText showLabel:(NSString *)showLabel endStrRichLabel:(NSString * )endStrRichLabel sliderArr:(NSArray *)sliderArr unit:(NSString *)unit;
/**
 单选方法
 */
- (UIButton * )demandToView:(UIView *)bacView titleArrty:(NSArray *)titleArrty startY:(CGFloat)startY col:(NSInteger)col defaultBtn:(UIButton *)defaultBtn startX:(CGFloat)startX margin:(CGFloat)margin target:(id)target action:(SEL)action;

/*!
 @brief 滑块
 */
- ( void)addSlider:(UIView *)sliderVeiw labelImage:(NSString *)labelImage titleLabelText:(NSString *)titleLabelText showLabel:(NSString *)showLabel endStrRichLabel:(NSString * )endStrRichLabel sliderArr:(NSArray *)sliderArr;
@end
