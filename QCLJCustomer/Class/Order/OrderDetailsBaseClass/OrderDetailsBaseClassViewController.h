//
//  OrderDetailsBaseClassViewController.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Comment.h"
#import "OrderModel.h"//订单列表模型
#import "DetailsModel.h"//订单详情模型
#import "PayModel.h"//支付模型

#import "CWStarRateView.h"//星级评价
#import "MyTextView.h"//自定义textView

#import "ThirdPartyLoginViewController.h"//登录页面


//支付宝
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"



typedef void (^ReturnOrderBlock)();


@interface OrderDetailsBaseClassViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate,CWStarRateViewDelegate,WXApiDelegate>

/**
 *  操作回调
 */
@property (nonatomic, copy) ReturnOrderBlock returnOrderBlock;
- (void)returnOrderList:(ReturnOrderBlock)block;

@property (nonatomic,strong) UIScrollView * scrollView;

@property (nonatomic,strong) OrderModel * orderModel;//订单模型
@property (nonatomic,strong) DetailsModel * detailsModel;
@property (nonatomic, copy) NSString *stateStr;//订单状态

//温馨提示
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * messageLabel;

#pragma mark - *****支付使用的
@property (nonatomic,strong) PayModel * payModel;//支付模型
@property (strong,nonatomic)  UIButton *lastBtn;

#pragma mark - *****订单评价
@property (nonatomic, strong) MyTextView * content ;//评价内容
@property (nonatomic, assign) NSInteger level;//评价内容
//@property (assign, nonatomic) BOOL isrenter;//是否刷新
//- (void)Isrenter;
//取消订单
//@property (nonatomic, copy) NSString *orderID;

/**
 *  添加订单详情显示订单进行状态
 *
 *  @param index        高亮个数
 *  @param imageArr     不亮图片
 *  @param highImageArr 高亮图片
 *  @param titleArr     文字
 *
 *  @return view
 */
- (UIView *)addOrderTypeIndex:(NSInteger )index imageArr:(NSArray *)imageArr highImageArr:(NSArray *)highImageArr titleArr:(NSArray *)titleArr;
/**
 *  订单信息
 *
 *  @param viewY     View的Y
 *  @param labelArr1 订单编号 订单状态 数组
 *  @param labelArr2 后面内容数组
 *
 *  @return 基础的View
 */
- (UIView *)informationViewToY:(CGFloat)viewY Arr1:(NSArray *)labelArr1 Arr2:(NSArray *)labelArr2;
/**
 *  筛选条件
 *
 *  @param viewY        View的Y
 *  @param orderType    orderType  保姆 育儿嫂
 *  @param detailsModel 传输的订单详情模型
 *
 *  @return 基础的View
 */
- (UIView *)screenViewToY:(CGFloat)viewY orderType:(NSString *)orderType detailsModel:(DetailsModel*)detailsModel;
/**
 *  温馨提示
 *
 *  @param viewY   View的Y
 *  @param title   可以控制现隐的文字
 *  @param message 不可以控制现隐的文字
 *
 *  @return  基础的View
 */
- (UIView *)promptViewToY:(CGFloat)viewY title:(NSString *)title message:(NSString*)message;
/**
 *  订单价格
 *
 *  @param viewY  View的Y
 *  @param oneArr 数组 订单总价~~~
 *  @param twoArr 数组 金额
 *
 *  @return 基础的View
 */
- (UIView *)orderPriceViewToY:(CGFloat)viewY oneArr:(NSArray *)oneArr twoArr:(NSArray *)twoArr;
/*!
 @brief 取消订单
 @param title  可以控制现隐的文字
 @param message 不可以控制现隐的文字
 @param viewY View的Y
 @return view
 */
- (UIView *)cancelViewAndBtnWithView:(UIView *)view;
//付款成功
- (void)successBtnChlie:(UIButton *)btn;
//确认支付
- (void)payBtnChlie:(UIButton *)btn;
//确认验收
- (void)acceptanceBtnChlie:(UIButton *)btn;
//服务评价
-(void)evaluateBtnChlie:(UIButton *)btn;

#pragma mark - 筛选订单信息数组
/*!
 @brief 筛选订单信息数组
 @param model  模型
 @param stateStr 订单状态文字
 @param labelArr1 数组订单资料名称
 @param labelArr2 数组订单资料内容
 @return 表示订单服务类型字符串
 */
- (NSString *)setOrderInformationArrWithModel:(DetailsModel *)model stateStr:(NSString *)stateStr labelArr1:(NSMutableArray *)labelArr11 labelArr2:(NSMutableArray *)labelArr22 ;
#pragma mark - *******支付-界面UI创建
/**
 *  支付界面UI创建
 *
 *  @param view             add的view
 *  @param frame            位置
 *  @param imageName        图片名字
 *  @param titleText1       标题
 *  @param titleText2       副标题
 *  @param btnImageName     按钮暗状态图片名字
 *  @param btnImageHigeName 按钮亮状态图片名字
 *  @param target           self
 *  @param action           按钮方法
 *  @param lastBtn          默认按钮Btn
 *  @param btnTag           设置 tag （根据这个区分是那种支付方式）1微信  2支付宝  3会员卡
 *
 *  @return 勾的按钮
 */
- (UIButton *)addImageAndLabe:(UIView*)view Frame:(CGRect)frame ImageName:(NSString *)imageName TitleText1:(NSString *)titleText1 TitleText2:(NSString *)titleText2 ButtonImageName:(NSString *)btnImageName ButtonImageHigeName:(NSString *)btnImageHigeName Target:(id)target action:(SEL)action lastBtn:(UIButton *)lastBtn ButtonTag:(NSInteger)btnTag;
/**
 *  支付界面触发按钮
 *
 *  @param btn btn
 */
- (void)btnChile:(UIButton *)btn;
/**
 *  支付界面-立即支付
 */
- (void)payBtnChile;
/**
 *  把字符串根据","分割成数组
 *
 *  @param arrStr 将分割的字符串
 *
 *  @return 可变数组
 */
- (NSMutableArray *)setArrStr:(NSString *)arrStr;
/**
 *  温馨提示文字现隐触发方法
 *
 *  @param btn 
 */
- (void)promptBtnChlie:(UIButton *)btn;
/**
 *  支付宝URl回调
 */
#pragma mark - 支付宝URl回调
- (BOOL)addAlipayOpenURL:(NSURL *)url;
@end
