//
//  QCWebViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QCWebViewController.h"
#import "Comment.h"

@interface QCWebViewController ()

@property (nonatomic,strong)UIWebView *webView;
@end
@implementation QCWebViewController
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.frame = CGRectMake(0, 0, MYScreenW, self.view.height);
        _webView.delegate = self;
    }
    return _webView;
}
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)addWeb{
    
    [CHMBProgressHUD showProgress:@"加载中"];
//    // 提供webView加载登陆页面
//    UIWebView *webView = [[UIWebView alloc]init];
//    webView.frame = CGRectMake(0, 0, MYScreenW, MYScreenH - QiCaiZhifuHeight);
//    webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

/**
 页面加载成功
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [CHMBProgressHUD hide];
}
/**
 网络请求失败
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [CHMBProgressHUD hide];
    [self showNotInternetViewToAbnormalState:AbnormalStateNoNetwork message1:nil message2:nil];
    
}
/**
 网络已经开始加载 加载中
 */
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //   [CHMBProgressHUD showProgress:@"加载中"];
}
/**
 *  回调状态页面刷新按钮
 *
 *  @param btn tag == 111 是立即预约
 *             tag == 222 是刷新
 */
- (void)requestDataWithStart:(UIButton *)btn{
    
    [self hiddenNotInternetView];
    
    [self addWeb];
    
}

@end
