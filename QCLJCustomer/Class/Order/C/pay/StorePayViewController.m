//
//  StorePayViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/22.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "StorePayViewController.h"



@interface StorePayViewController ()

@end

@implementation StorePayViewController
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    self.navigationItem.title = @"门店缴费";
    [self setUpUI];
    
    self.payModel.payType = paymentOrder;
}
- (void)setUpUI{
    [self.view addSubview:self.scrollView];
    //支付方式
    UILabel * payModeLabel = [UILabel addLabelWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.frame), 30) text:@"   选择支付方式" size:12 textAlignment:NSTextAlignmentLeft];
    payModeLabel.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:payModeLabel];
    
    //weixin
    CGRect weixinRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), 50);
        UIButton * weixinButton =
    [self addImageAndLabe:self.scrollView Frame:weixinRect ImageName:@"order_pay_weixin" TitleText1:@"微信支付" TitleText2:@"亿万用户的选择，更快更安全" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:1];
         self.lastBtn = weixinButton;
    
    //zhifubao
    CGRect zhufubaoRect = CGRectMake(0, CGRectGetMaxY(weixinRect), CGRectGetWidth(self.scrollView.frame), 50);
    //    UIButton * zhifubaoButton =
    [self addImageAndLabe:self.scrollView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
    
    //    [UIImage imageNamed:@"details_rate_on"]
    
    
    //订单支付
    
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ self.scrollView.subviews objectAtIndex:self.scrollView.subviews.count - 1].frame) + 64 + 33);
    
    VDLog(@"%@",self.payModel.amount);
    //立即支付
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即支付" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(payBtnChile)];
    maternityMatronsummitBtn.acceptEventInterval = 5;
    [self.view addSubview:maternityMatronsummitBtn];

}

@end
