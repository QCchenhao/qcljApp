//
//  DetailsStatusInServiceViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "DetailsStatusInServiceViewController.h"

@interface DetailsStatusInServiceViewController ()

@property (copy, nonatomic) NSString * telStr;
@end

@implementation DetailsStatusInServiceViewController
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
    
    NSArray * imageArr = @[@"details_process_4_off",@"details_process_5_off",@"details_process_6_off"];
    NSArray * highImageArr = @[@"details_process_4_on",@"details_process_5_on",@"details_process_6_on"];
    NSArray * titleArr = @[@"已付款",@"服务中",@"已完成"];
    
    NSMutableArray * labelArr1 = [NSMutableArray array];//订单编号 、 状态---说明
    NSMutableArray * labelArr2 = [NSMutableArray array];//内容
    
    
    //筛选数组
    NSString * orderType = [self setOrderInformationArrWithModel:self.detailsModel stateStr:self.stateStr labelArr1:labelArr1 labelArr2:labelArr2];

    //订单状态
    UIView * orderTypeView ;
    if (self.detailsModel.state == 4) {//已付款
        orderTypeView  = [self addOrderTypeIndex:1 imageArr:imageArr highImageArr:highImageArr titleArr:titleArr];
    }else{
        orderTypeView  = [self addOrderTypeIndex:2 imageArr:imageArr highImageArr:highImageArr titleArr:titleArr];

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
    
    //按钮
    //创建按钮
    UIView * buttonView = [self addButtonToY:CGRectGetMaxY(orderPriceView.frame) + 1 Target:self action1:@selector(redBtnChile:) action2:@selector(whiteBtnClick:)];
    

    
    //温馨提示
    UIView * promptView = [self promptViewToY:CGRectGetMaxY(buttonView.frame) + 1 title:@"1、特殊情况（早产儿，双胞胎，患病儿等）酌情加收服务费。\n2、不住家月嫂，月嫂价格不变，上下班公交费客户不在付\n3、26工作日/月；如国家法定节假日，日服务费应按照1倍计算；如不支付加班费的月嫂应减少服务天数。" message:@"客服会在24小时内与您电话沟通，遇到假日顺延。一般会在9:00-18:00与您联系，届时请保持手机畅通！"];
    promptView.height = MYScreenH * 0.3;
    
    //确认验收
    UIButton *acceptanceBtn = [UIButton addZhuFuBtnWithTitle:@"确认验收" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(acceptanceBtnChlie:)];
    [self.view addSubview:acceptanceBtn];
    
    
    
}
- (UIView *)addButtonToY:(CGFloat)viewY Target:(id)target action1:(SEL)action1 action2:(SEL)action2{
    UIView * buttonView = [[UIView alloc]init];
    buttonView.frame = CGRectMake(0, viewY, CGRectGetWidth(self.scrollView.frame), 60);
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:buttonView];
    
    CGRect whiteRect = CGRectMake(17, 0,( CGRectGetWidth(buttonView.frame) - 2 * 17 - 13) / 2, 30);
    
    CGRect redRect = CGRectMake(CGRectGetMaxX(whiteRect) + 13, 0, CGRectGetWidth(whiteRect), CGRectGetHeight(whiteRect));
    
    
    UIButton * redButton = [UIButton addButtonWithFrame:whiteRect ButtonTitle:@"联系阿姨" titleColor:[UIColor whiteColor] titleFont:QiCaiDetailTitle12Font borderColor:QiCaiNavBackGroundColor backGroundColor:QiCaiNavBackGroundColor Target:self action:action1 btnCornerRadius:CGRectGetHeight(whiteRect) / 2];
    [buttonView addSubview:redButton];
    
    UIButton * whiteButton = [UIButton addButtonWithFrame:redRect ButtonTitle:@"联系客服" titleColor:[UIColor grayColor] titleFont:QiCaiDetailTitle12Font borderColor:QiCaiBackGroundColor backGroundColor:nil Target:target action:action2 btnCornerRadius:CGRectGetHeight(redRect) / 2];
    [buttonView addSubview:whiteButton];
    
    redButton.centerY = CGRectGetHeight(buttonView.frame) / 2;
    whiteButton.centerY = redButton.centerY;
    
    return buttonView;
//    demoTel
}
-(void)redBtnChile:(UIButton *)btn{
//    self.detailsModel.domeTel
    if (self.detailsModel.domeTel) {
        self.telStr = self.detailsModel.domeTel;
    }else{
        self.telStr = @"4000999001";
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telStr]]];
}
-(void)whiteBtnClick:(UIButton *)btn{
    self.telStr = @"4000999001";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telStr]]];
}

@end
