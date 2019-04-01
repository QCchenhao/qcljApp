//
//  DetailsStatusPayYesAndNoViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "DetailsStatusPayYesAndNoViewController.h"

@interface DetailsStatusPayYesAndNoViewController ()

@end

@implementation DetailsStatusPayYesAndNoViewController
- (void)returnOrderList:(ReturnOrderBlock)block{
    self.returnOrderBlock = block;
}
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
    [self setUpUI];
    
}
- (void)setUpUI{
    [self.view addSubview:self.scrollView];
    
    NSMutableArray * labelArr1 = [NSMutableArray array];//订单编号 、 状态---说明
    NSMutableArray * labelArr2 = [NSMutableArray array];//内容
    
    //筛选数组
    [self setOrderInformationArrWithModel:self.detailsModel stateStr:self.stateStr labelArr1:labelArr1 labelArr2:labelArr2];
    //订单状态
    NSArray * imageArr ;
    NSArray * highImageArr;
    NSArray * titleArr;
    UIView * orderTypeView ;
    if (self.detailsModel.state == 3){//待付款
        imageArr = @[@"details_process_1_off",@"details_process_2_off",@"details_process_3_off"];
        highImageArr = @[@"details_process_1_on",@"details_process_2_on",@"details_process_3_on"];
        titleArr = @[@"提交订单",@"面试中",@"待付款"];
        orderTypeView  = [self addOrderTypeIndex:3 imageArr:imageArr highImageArr:highImageArr titleArr:titleArr];
    }

    
    //订单信息
    UIView * informationView = [self informationViewToY:CGRectGetMaxY(orderTypeView.frame) + 5 Arr1:labelArr1 Arr2:labelArr2];
    
    NSArray * oneArr = @[@"订单总价：" , @"服务金额：" , @"服务保险："];
    NSString * spriceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.sprice];
    NSString * priceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.price];
    NSString * einsuStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.einsu];
    if (self.detailsModel.count) {
        priceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.price * [self.detailsModel.count integerValue]];
        einsuStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.einsu * [self.detailsModel.count integerValue]];
    }
    NSArray * twoArr = @[spriceStr,priceStr,einsuStr];
    //订单价格
    UIView * orderPriceView = [self orderPriceViewToY:CGRectGetMaxY(informationView.frame) + 5 oneArr:oneArr twoArr:twoArr];
    
    //温馨提示
    UIView * promptView = [self promptViewToY:CGRectGetMaxY(orderPriceView.frame) + 2 title:@"1、特殊情况（早产儿，双胞胎，患病儿等）酌情加收服务费。\n2、不住家月嫂，月嫂价格不变，上下班公交费客户不在付\n3、26工作日/月；如国家法定节假日，日服务费应按照1倍计算；如不支付加班费的月嫂应减少服务天数。" message:@"客服会在24小时内与您电话沟通，遇到假日顺延。一般会在9:00-18:00与您联系，届时请保持手机畅通！"];
    promptView.height = MYScreenH * 0.3;
    
    //确认支付  付款成功
    if (self.detailsModel.state == 3){//待付款
        UIButton *confirAacceptanceBtn = [UIButton addZhuFuBtnWithTitle:@"确认支付" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(payBtnChlie:)];
        [self.view addSubview:confirAacceptanceBtn];
    }


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
