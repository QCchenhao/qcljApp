//
//  DetailsStatusEvaluateViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "DetailsStatusEvaluateViewController.h"

#import "FeedBackViewController.h"//投诉 意见反馈

@interface DetailsStatusEvaluateViewController ()

@end

@implementation DetailsStatusEvaluateViewController
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
    
    NSArray * imageArr;
    NSArray * highImageArr;
    NSArray * titleArr;
    
    if (self.detailsModel.stid == 42) {
        imageArr = @[@"details_process_1_off",@"details_process_3_off"];
        highImageArr = @[@"details_process_1_on",@"details_process_3_on"];
        titleArr = @[@"提交订单",@"确认支付"];
        self.stateStr = @"已完成";
    }else{
        imageArr = @[@"details_process_4_off",@"details_process_5_off",@"details_process_6_off"];
        highImageArr = @[@"details_process_4_on",@"details_process_5_on",@"details_process_6_on"];
        titleArr = @[@"已付款",@"服务中",@"已完成"];
    }
    
    NSMutableArray * labelArr1 = [NSMutableArray array];//订单编号 、 状态---说明
    NSMutableArray * labelArr2 = [NSMutableArray array];//内容
    
    //筛选数组
    [self setOrderInformationArrWithModel:self.detailsModel stateStr:self.stateStr labelArr1:labelArr1 labelArr2:labelArr2];
    //订单状态
//    UIView * orderTypeView ;
    UIView * orderTypeView  = [self addOrderTypeIndex:3 imageArr:imageArr highImageArr:highImageArr titleArr:titleArr];
        
    
    
    //订单信息
    UIView * informationView = [self informationViewToY:CGRectGetMaxY(orderTypeView.frame) + 5 Arr1:labelArr1 Arr2:labelArr2];
    NSArray * oneArr;
    NSString * spriceStr;
    NSString * priceStr;
    NSString * einsuStr;
    NSArray * twoArr;
    if (self.detailsModel.stid == 42) {
        oneArr = @[@"订单总价："  , @"服务佣金：", @"代收工资：", @"保险费："];
        spriceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.sprice];
        NSString * yongjinStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.yongjin];
        NSString * daishouStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.daishou];
        einsuStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.einsu];

        twoArr = @[spriceStr,yongjinStr,daishouStr,einsuStr];
    }else{
        oneArr = @[@"订单总价：" , @"服务金额：" , @"服务保险："];
        spriceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.sprice];
        priceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.price];
        einsuStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.einsu];
        
        if (self.detailsModel.count) {
            priceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.price * [self.detailsModel.count integerValue]];
            einsuStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.einsu * [self.detailsModel.count integerValue]];
        }

        twoArr = @[spriceStr,priceStr,einsuStr];
    }
    
    
    //订单价格
    UIView * orderPriceView = [self orderPriceViewToY:CGRectGetMaxY(informationView.frame) + 5 oneArr:oneArr twoArr:twoArr];

    if (self.detailsModel.state == 7) {//未评价状态
        //点评
        UIView * commentView = [[UIView alloc]init];
        commentView.frame= CGRectMake(0, CGRectGetMaxY(orderPriceView.frame) + 5, MYScreenW, 200);
        commentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:commentView];
        
        UILabel * durationLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"details_comment"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(commentView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"点评" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
        [commentView addSubview:durationLabel];
        
        UIButton *complaintButton = [UIButton addButtonWithFrame:CGRectMake(CGRectGetWidth(commentView.frame) - 65, CGRectGetMinX(durationLabel.frame), 55, 25 ) ButtonTitle:@"投诉" titleColor:QiCaiNavBackGroundColor titleFont:QiCaiDetailTitle12Font borderColor:QiCaiNavBackGroundColor backGroundColor:[UIColor whiteColor] Target:self action:@selector(complaintBtnChlie) btnCornerRadius:4];
        complaintButton.centerY = durationLabel.centerY;
        [commentView addSubview:complaintButton];
        
        //满意度
        UILabel * satisfiedLabel = [UILabel addLabelWithFrame:CGRectMake(36, CGRectGetMaxY(durationLabel.frame) + 10, 50, 20) text:@"满意度：" size:12 textAlignment:NSTextAlignmentLeft];
        [commentView addSubview:satisfiedLabel];
        
        //星级评价
        CWStarRateView * rateView = [[CWStarRateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(satisfiedLabel.frame), 0, CGRectGetWidth(commentView.frame) * 0.45, 25) numberOfStars:5];
        
        rateView.scorePercent = 1;
        rateView.allowIncompleteStar = NO;
        rateView.hasAnimation = YES;
        rateView.delegate = self;
        rateView.centerY = satisfiedLabel.centerY;
        [commentView addSubview:rateView];
        
        //星级评价初始值
        self.level = 5;
        
        //满意度
        UILabel * commentLabel = [UILabel addLabelWithFrame:CGRectMake(36, CGRectGetMaxY(satisfiedLabel.frame) + 10, 50, 20) text:@"评    论：" size:12 textAlignment:NSTextAlignmentLeft];
        [commentView addSubview:commentLabel];
        
        //textView
        MyTextView *textView = [[MyTextView alloc]init];
        textView.frame = CGRectMake(CGRectGetMaxX(commentLabel.frame), CGRectGetMinY(commentLabel.frame), MYScreenW - QiCaiMargin  - 100 , 80);
        textView.delegate = self;
        textView.layer.borderColor =  QiCaiBackGroundColor.CGColor;
        textView.layer.borderWidth =1.0;
        textView.layer.cornerRadius = 8; //给图层的边框设置为圆角
        textView.placeHoledr = @"请留下您的宝贵建议！";
        self.content = textView;
        [commentView addSubview:textView];
        
        //服务评价
        UIButton *confirAacceptanceBtn = [UIButton addZhuFuBtnWithTitle:@"服务评价" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(evaluateBtnChlie:)];
        [self.view addSubview:confirAacceptanceBtn];

        
    }
    
    
    
}
////服务评价
//-(void)evaluateBtnChlie:(UIButton *)btn{
//    
//}
//#pragma mark - 星级回调
//- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
//    NSLog(@"%f",starRateView.scorePercent * 5);
//}
#pragma mark - UITextView Delegate --隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - 投诉
/**
 *  投诉
 */
- (void)complaintBtnChlie{
    FeedBackViewController * feedBackVC = [[FeedBackViewController alloc]init];
    feedBackVC.type = @"2";
    feedBackVC.orderID = self.orderModel.orderId;
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

@end
