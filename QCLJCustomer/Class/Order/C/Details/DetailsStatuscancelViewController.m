//
//  DetailsStatuscancelViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "DetailsStatuscancelViewController.h"
#import "Comment.h"

#import "MyMessageViewController.h"

@interface DetailsStatuscancelViewController ()

@end

@implementation DetailsStatuscancelViewController
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
    NSString * orderType = [self setOrderInformationArrWithModel:self.detailsModel stateStr:self.stateStr labelArr1:labelArr1 labelArr2:labelArr2];
    
    //订单信息
    UIView * informationView = [self informationViewToY: 5 Arr1:labelArr1 Arr2:labelArr2];
    
    //优惠信息
    UIView * discountView = [[UIView alloc]init];
    discountView.frame = CGRectMake(0, CGRectGetMaxY(informationView.frame) + 5, CGRectGetWidth(self.scrollView.frame), 45);
    discountView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:discountView];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"details_discount"];
    imageView.frame = CGRectMake(10, 0, CGRectGetHeight(discountView.frame) / 2,  CGRectGetHeight(discountView.frame) / 2);
    [discountView addSubview:imageView];
    imageView.centerY = CGRectGetHeight(discountView.frame) / 2;
    
    UIButton * button = [[UIButton alloc]init];
    button.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, CGRectGetWidth(discountView.frame) - 2* 25 - CGRectGetWidth(imageView.frame), CGRectGetHeight(discountView.frame));
    [discountView addSubview:button];
    [button.titleLabel setFont:QiCai12PFFont];
    [button setTitle:@"最新优惠活动" forState:UIControlStateNormal];
    [button setTitleColor:QiCaiShallowColor forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"main_icon_arrow"] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    //设置button图右文左
    //    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
//    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(buttonChile) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btnImage = [[UIButton alloc]init];
    btnImage.frame = CGRectMake(CGRectGetMaxX(button.frame), 0, 20, CGRectGetHeight(discountView.frame));
    [btnImage setImage:[UIImage imageNamed:@"main_icon_arrow"] forState:UIControlStateNormal];
    btnImage.centerY = CGRectGetHeight(discountView.frame) / 2;
    [discountView addSubview:btnImage];
    
    
}
#pragma mark -button触发方法
- (void)buttonChile{
    MyMessageViewController * myMessageVC = [[MyMessageViewController alloc]init];
    [self.navigationController pushViewController:myMessageVC animated:YES];
}
@end
