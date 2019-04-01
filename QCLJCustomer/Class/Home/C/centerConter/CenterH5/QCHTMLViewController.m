//
//  QCHTMLViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QCHTMLViewController.h"
#import "NannyViewController.h"//保姆
#import "ParentalViewController.h"//育儿嫂
#import "MaternityMatronViewController.h"//月嫂
#import "HomePackageViewController.h"//家政套餐
#import "EnterpriseServiceViewController.h"//企业服务



#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "Comment.h"

@interface QCHTMLViewController ()

@end

@implementation QCHTMLViewController
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
-(void)setUpUI
{
   
    
//    // 提供webView加载登陆页面
//    UIWebView *webView = [[UIWebView alloc]init];
//    webView.frame = CGRectMake(0, 0, MYScreenW, MYScreenH - QiCaiZhifuHeight);
//    webView.delegate = self;
    
    NSString *urlStr;
    NSString *titleStr;
     //根据不同的类型判断
    switch (self.qcthmlType) {
        case QCHTMLTypeMaternityMatron://月嫂
            titleStr = @"月嫂";
            urlStr = @"http://115.47.58.225/h5/app/ys.html";
            break;
        case QCHTMLTypeParental://育儿嫂
            titleStr = @"育儿嫂";
            urlStr = @"http://115.47.58.225/h5/app/yes.html";
            break;
        case QCHTMLTypeNanny://保姆
            titleStr = @"保姆";
            urlStr = @"http://115.47.58.225/h5/app/bm.html";
            break;
        case QCHTMLTypeHomePackage://保洁套餐
            titleStr = @"保洁套餐";
            urlStr = @"http://115.47.58.225/h5/app/bjtc.html";
            break;
        case QCHTMLTypeEnterpriseSerview://企业服务
            titleStr = @"企业服务";
            urlStr = @"http://115.47.58.225/h5/app/lwpq.html";
            break;
        case QCHTMLTypeHomeEconmicsTraining://家政培训
            titleStr = @"家政培训";
            urlStr = @"http://115.47.58.225/h5/app/jzpx.html";
            break;
        case QCHTMLTypePensionService://养老服务
            titleStr = @"养老服务";
            urlStr = @"http://115.47.58.225/h5/app/jgyl.html";
            break;
        case QCHTMLTypeMembershipPrivileges://会员特权
            titleStr = @"会员特权";
            urlStr = @"http://115.47.58.225/h5/app/vip.html";
            break;
        case QCHTMLTypeConponInstructions://优惠券使用说明
            titleStr = @"优惠券使用说明";
            urlStr = @"http://115.47.58.225/h5/app/yhq.html";
            break;
        case QCHTMLTypeGiftInstruction://礼品卡兑换的使用说明
            titleStr = @"礼品卡兑换的使用说明";
            urlStr = @"http://115.47.58.225/h5/app/vip.html";
            break;
        case QCHTMLTypeUserProtocol://用户协议
            titleStr = @"用户协议";
            urlStr = @"http://115.47.58.225/h5/app/yhxy.html";
            break;
        case QCHTMLTypeRechargeProtocol://充值协议
            titleStr = @"充值协议";
            urlStr = @"http://115.47.58.225/h5/app/yhxy.html";
            break;
        default:
            break;
    }
    
    // 设置导航栏标题
    self.navigationItem.title = titleStr;
    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [self.view addSubview:webVC];
    
    QCWebViewController * webVC = [[QCWebViewController alloc]init];

    
    //根据类型判断是否出现按钮
    if (self.qcthmlType == QCHTMLTypeMaternityMatron//月嫂
        || self.qcthmlType == QCHTMLTypeParental//育儿嫂
        || self.qcthmlType == QCHTMLTypeNanny// 保姆
        || self.qcthmlType == QCHTMLTypeHomePackage//保洁套餐
        || self.qcthmlType == QCHTMLTypeEnterpriseSerview//企业服务
        ) {
        
        UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即预订" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - QiCaiNavHeight, MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickMaternityMatronSummit)];
        [self.view addSubview:maternityMatronsummitBtn];
        webVC.view.height = MYScreenH - QiCaiZhifuHeight - QiCaiNavHeight;

    }else if (self.qcthmlType == QCHTMLTypePensionService//养老
              ||self.qcthmlType == QCHTMLTypeHomeEconmicsTraining//家政服务
              )
    {
        UIButton *photoBtn = [UIButton addZhuFuBtnWithTitle:@"电话预订" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - QiCaiNavHeight, MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickPhotoBtn)];
        [self.view addSubview:photoBtn];
        webVC.view.height = MYScreenH - QiCaiZhifuHeight - QiCaiNavHeight;
    }
    else
    {
        webVC.view.height = MYScreenH - QiCaiNavHeight;

    }

    webVC.view.frame = CGRectMake(0, 0, MYScreenW, webVC.view.height);
    webVC.qcthmlType = self.qcthmlType;
    webVC.urlStr = urlStr;
    [webVC addWeb];

    [self.view addSubview:webVC.view];
    [self addChildViewController:webVC];
}
/**
 photo
 */
-(void)clickPhotoBtn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}
/**
 提交页面
 */
-(void)clickMaternityMatronSummit
{
    //根据不同的类型判断
    if (self.qcthmlType == QCHTMLTypeMaternityMatron)//月嫂
    {
        MaternityMatronViewController *maternityMatronVC = [[MaternityMatronViewController alloc]init];
        [self.navigationController pushViewController:maternityMatronVC animated:YES];
        
    }else if (self.qcthmlType == QCHTMLTypeParental)//育儿嫂
    {
        ParentalViewController *parentalVC = [[ParentalViewController alloc]init];
        [self.navigationController pushViewController:parentalVC animated:YES];
        
    }else if (self.qcthmlType == QCHTMLTypeNanny)//保姆
    {
        NannyViewController *nannyVC = [[NannyViewController alloc]init];
        [self.navigationController pushViewController:nannyVC animated:YES];
        
    }else if (self.qcthmlType == QCHTMLTypeHomePackage)//保洁套餐
    {
        HomePackageViewController *homePackageVC = [[HomePackageViewController alloc]init];
        [self.navigationController pushViewController:homePackageVC animated:YES];
        
    }else if (self.qcthmlType == QCHTMLTypeEnterpriseSerview)//企业服务
    {
        EnterpriseServiceViewController *enterpriseServiewVC = [[EnterpriseServiceViewController alloc]init];
        [self.navigationController pushViewController:enterpriseServiewVC animated:YES];
        
    }
}
///**
// 页面加载成功
// */
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    [CHMBProgressHUD hide];
//}
///**
// 网络请求失败
// */
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    [CHMBProgressHUD hide];
//    [self showNotInternetViewToAbnormalState:AbnormalStateNoNetwork message1:nil message2:nil];
//
//}
///**
// 网络已经开始加载 加载中
// */
//- (void)webViewDidStartLoad:(UIWebView *)webView{
////   [CHMBProgressHUD showProgress:@"加载中"];
//}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        NSLog(@"%@", change);
//        self.progresslayer.opacity = 1;
//        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
//        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progresslayer.opacity = 0;
//            });
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
//            });
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        NSLog(@"%@", change);
//        self.progresslayer.opacity = 1;
//        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
//        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progresslayer.opacity = 0;
//            });
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
//            });
//        }
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}


@end
