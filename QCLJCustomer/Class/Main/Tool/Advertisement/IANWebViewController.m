//
//  IANWebViewController.m
//  IanStartAdsView
//
//  Created by ian on 16/8/22.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANWebViewController.h"
#import "Comment.h"
#import "QiCaiTabBarController.h"

@interface IANWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation IANWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [UINavigationBar addMyNavBarWithCenterTitle:@"ddd" addTarget:self action:@selector(back) contentView:self.view];
    
//    self.navigationItem.title = @"七彩乐居";
//    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    // 设置导航栏右边的按钮
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"Main_public_left" action:@selector(back) target:self];
    

    
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, QiCaiNavHeight, self.view.frame.size.width, self.view.frame.size.height - QiCaiNavHeight)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *path = @"http://www.ianisme.com";
    NSURL *url = [NSURL URLWithString:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
//    [self.navigationController popViewControllerAnimated:YES];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    QiCaiTabBarController *tabBarVC = [[QiCaiTabBarController alloc]init];
    //    tabBarVC.delegate = (id)MYAppDelegate;
    window.rootViewController = tabBarVC;

}

@end
