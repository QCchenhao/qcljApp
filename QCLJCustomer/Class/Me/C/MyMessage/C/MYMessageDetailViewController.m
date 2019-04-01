//
//  MYMessageDetailViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/25.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MYMessageDetailViewController.h"
#import "Comment.h"
#import <WebKit/WebKit.h>

@interface MYMessageDetailViewController()<UIWebViewDelegate>

@end

@implementation MYMessageDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [CHMBProgressHUD showProgress:@"加载中"];
    
    self.view.backgroundColor = QiCaiBackGroundColor;
    // 设置导航栏标题
    self.navigationItem.title = self.newsTitle;
    
    [self setUpUI];
    
}
-(void)setUpUI
{
    // 提供webView加载登陆页面
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = CGRectMake(0, 0, MYScreenW, MYScreenH);
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.newsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [CHMBProgressHUD hide];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //   [CHMBProgressHUD showProgress:@"加载中"];
}
@end
