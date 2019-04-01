//
//  DetailsStatusInSubmissionViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "DetailsStatusInSubmissionViewController.h"

@interface DetailsStatusInSubmissionViewController ()

//@property (nonatomic,copy) NSString * orderType ;//订单类型

@end

@implementation DetailsStatusInSubmissionViewController
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)returnOrderList:(ReturnOrderBlock)block{
    self.returnOrderBlock = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    [self setUpUI];
    
}
- (void)setUpUI{
    [self.view addSubview:self.scrollView];
    
    NSArray * imageArr;
    NSArray * highImageArr;
    NSArray * titleArr;
    if (self.detailsModel.stid == 42) {
        imageArr = @[@"details_process_1_off",@"details_process_3_off"];
        highImageArr = @[@"details_process_1_on",@"details_process_3_on"];
        titleArr = @[@"提交订单",@"确认支付"];
        self.stateStr = @"待付款";
    }else{
        imageArr = @[@"details_process_1_off",@"details_process_2_off",@"details_process_3_off"];
        highImageArr = @[@"details_process_1_on",@"details_process_2_on",@"details_process_3_on"];
        titleArr = @[@"提交订单",@"面试中",@"待付款"];
    }
    
    NSMutableArray * labelArr1 = [NSMutableArray array];//订单编号 、 状态---说明
    NSMutableArray * labelArr2 = [NSMutableArray array];//内容

    //筛选数组
    NSString * orderType = [self setOrderInformationArrWithModel:self.detailsModel stateStr:self.stateStr labelArr1:labelArr1 labelArr2:labelArr2];
     //订单状态
    NSInteger index ;
    if (self.detailsModel.state == 2) {
        index = 2;
    }else{
        index = 1;
    }
    UIView * orderTypeView  = [self addOrderTypeIndex:index imageArr:imageArr highImageArr:highImageArr titleArr:titleArr];
    
    //订单信息
    UIView * informationView = [self informationViewToY:CGRectGetMaxY(orderTypeView.frame) + 5 Arr1:labelArr1 Arr2:labelArr2];
    
    //筛选条件
    CGFloat  promptY ;
    CGFloat  promptH ;
    if (self.detailsModel.stid == OrderMaternityMatron || self.detailsModel.stid == OrderPaorental || self.detailsModel.stid == OrderNammy) {
        //筛选条件
        UIView * screenView = [self screenViewToY:CGRectGetMaxY(informationView.frame) + 5 orderType:orderType detailsModel:self.detailsModel];
        promptY = CGRectGetMaxY(screenView.frame) + 1;
        promptH = 150;
    }else{
        
        promptY = CGRectGetMaxY(informationView.frame) + 5;
        promptH = MYScreenH * 0.6;
    }
    
    
    
    //温馨提示
    UIView * promptView = [self promptViewToY:promptY title:@"1、特殊情况（早产儿，双胞胎，患病儿等）酌情加收服务费。\n2、不住家月嫂，月嫂价格不变，上下班公交费客户不在付\n3、26工作日/月；如国家法定节假日，日服务费应按照1倍计算；如不支付加班费的月嫂应减少服务天数。" message:@"客服会在24小时内与您电话沟通，遇到假日顺延。一般会在9:00-18:00与您联系，届时请保持手机畅通！"];
    promptView.height = promptH;
    
    
    
    if (self.detailsModel.stid == 42) {
        UIButton *confirAacceptanceBtn = [UIButton addZhuFuBtnWithTitle:@"确认支付" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(payBtnChlie:)];
        [self.view addSubview:confirAacceptanceBtn];
    }else{
        //取消订单
        [self cancelViewAndBtnWithView:self.view];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
