//
//  AppDelegate.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "AppDelegate.h"
#import "QiCaiTabBarController.h"
#import "QiCaiNewViewController.h"
#import "Comment.h"
#import "QiCaiNavigationController.h"

#import "IANWebViewController.h"//广告页
#import "IanAdsStartView.h"//广告页



#import "WXApi.h"//微信登录

#import "ThirdPartyLoginViewController.h"//登录
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "MeViewController.h"//刷新 优惠券，会员卡金额 数据
#import "OrderViewController.h" //刷新 订单 数据
#import "MemberShipCardViewController.h"//会员列表
#import "MemberRechargeViewController.h"//会员充值

#import <TencentOpenAPI/TencentOAuth.h>//qq分享

#import <AlipaySDK/AlipaySDK.h>//支付宝支付

#import "OrderDetailsBaseClassViewController.h"//订单积累
//#import "OrderPayViewController.h"//订单支付

#import "RealReachability.h"//判断网络情况

@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate>

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    
    MYAppDelegate.timeLogin = 60;
    
    [AMapServices sharedServices].apiKey = @"d4e29c2ba936dc6276fe62099d8a5aa7";
    
    //设置键盘现隐
    [self IQKeyboard];
    
    //微信注册
    [WXApi registerApp:QCAuthOpenID withDescription:@"Wechat"];
    
    // 0 还原状态栏，以及更改tabbar的颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    
   //1.创建window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //2.跟控制器
    QiCaiTabBarController *tabBarVC = [[QiCaiTabBarController alloc]init];
    tabBarVC.delegate = self;
    
    //当前版本号
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = infoDict[versionKey];
    
    //lastVersion
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [ud objectForKey:versionKey];
    
    if (![currentVersion isEqualToString:lastVersion]) {
        QiCaiNewViewController * QCnewVC = [[QiCaiNewViewController alloc]init];
        self.window.rootViewController = QCnewVC;
        
        //存版本号
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:currentVersion forKey:versionKey];
        [ud synchronize];
    }else
    {
        self.window.rootViewController = tabBarVC;

    }
    
    //3.显示
    [self.window makeKeyAndVisible];
    
    
//    NSString *picUrl = @"http://785j3g.com1.z0.glb.clouddn.com/d659db60-f.jpg";
//    NSString *userDefaultKey = @"download_key";
//    
//    if ([[[NSUserDefaults standardUserDefaults] stringForKey:userDefaultKey] isEqualToString:@"1"]) {
//        IanAdsStartView *startView = [IanAdsStartView startAdsViewWithBgImageUrl:picUrl withClickImageAction:^{
//            IANWebViewController *VC = [IANWebViewController new];
//            VC.title = @"这可能是一个广告页面";
//
//            self.window.rootViewController = VC;
////            [self.window.rootViewController dis]
////            [(QiCaiNavigationController *)self.window.rootViewController pushViewController:VC animated:YES];
//        }];
//        
//        [startView startAnimationTime:3 WithCompletionBlock:^(IanAdsStartView *startView){
//            NSLog(@"广告结束后，执行事件");
//        }];
//    } else { // 第一次先下载广告
//        [IanAdsStartView downloadStartImage:picUrl];
//        
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:userDefaultKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//
//    //应用角标
//    [UIApplication sharedApplication].applicationIconBadgeNumber=33;
    
    // 获取当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    
    // iOS 8 系统要求设置通知的时候必须经过用户许可。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [app registerUserNotificationSettings:settings];
    
    // 设置应用程序右上角的"通知图标"Badge
    app.applicationIconBadgeNumber = 0;  // 根据逻辑设置

    /**
     *  微信注册
     */
    [WXApi registerApp:WXPatient_App_ID];
    
    //网络状态监听
    [GLobalRealReachability startNotifier];
    //创建通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    //主动查询网络状态
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        if (status == RealStatusNotReachable)
        {
            //        self.flagLabel.text = @"Network unreachable!";
            //        [SVProgressHUD showInfoWithStatus:@"无网络链接"];
            MYAppDelegate.isNetworkState = YES;
        }else{
            MYAppDelegate.isNetworkState = NO;
        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/**
 *  当app进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - application delegate 这个方法是用于从微信返回第三方App 以及分享的回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    // 打开指定的URL
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];

    
    if( [url.absoluteString hasPrefix:@"tencent1105383137"] )
    {
        return [TencentOAuth HandleOpenURL:url];
        
    }
    else if ( [url.absoluteString hasPrefix:@"wxc36ced2ebd7092d5"] )
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else
    {
        return YES;
    }
    
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if( [url.absoluteString hasPrefix:@"tencent1105383137"] )
    {
        return [TencentOAuth HandleOpenURL:url];
       
    }
    else if ( [url.absoluteString hasPrefix:@"wxc36ced2ebd7092d5"] )
    {
        return [WXApi handleOpenURL:url delegate:self];
        
    }else
    {
        return YES;
    }

    
}
#pragma mark 跳转处理
//新的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    //设置代理

    OrderDetailsBaseClassViewController * orderVC = [[OrderDetailsBaseClassViewController alloc]init];
    
    if ( [url.absoluteString hasPrefix:@"wxc36ced2ebd7092d5"] )
    {
        return  [WXApi handleOpenURL:url delegate:orderVC] ;
    }else if ([url.absoluteString hasPrefix:@"qcljToZhifubaoSchemes"])
    {
        return [orderVC addAlipayOpenURL:url];
    }else{
        return YES;
    }
   
}
#pragma mark - 微信登录授权后回调
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]){
        //        PayResp*response = (PayResp*)resp;
        switch(resp.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            case WXErrCodeUserCancel:
            {
//                [SVProgressHUD showErrorWithStatus:@"您已经取消支付"];
                NSLog(@"用户取消支付: %d",resp.errCode);
                break;
            }
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
        
    }
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    //    SendAuthResp *aresp = (SendAuthResp *)resp;
    //    if (aresp.errCode== 0) {
    //        NSString *code = aresp.code;
    //        NSDictionary *dic = @{@"code":code};
    //    }

    
    // 向微信请求授权后,得到响应结果
    
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        
        ThirdPartyLoginViewController * VC = [[ThirdPartyLoginViewController alloc]init];
        
        [VC getWeiXinOpenId:aresp];
    }
    
}
-(void)IQKeyboard
{
    //自动化键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//设置点击背景收回键盘。
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    //设置为文字
//    manager.toolbarDoneBarButtonItemText = @"完成";

    manager.toolbarManageBehaviour = IQAutoToolbarByTag;
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] init];
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
//     self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
}
- (void)dealloc
{
    self.returnKeyHandler = nil;
}
#pragma mark -- 点击下面的tabbar按钮出发的方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:3] || viewController == [tabBarController.viewControllers objectAtIndex:1])//我的 订单
    {
        NSString *userIdString = [MYUserDefaults objectForKey:@"userId"];
        
        if (userIdString) {
            
            //禁止tab多次点击
            UIViewController *tbselect=tabBarController.selectedViewController;
            if([tbselect isEqual:viewController]){
                return NO;
            }
            return YES;
        }else
        {
            ThirdPartyLoginViewController *loginVC = [[ThirdPartyLoginViewController alloc]init];
            [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
            
            return NO;
        }
        
    }
    
    return YES;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
//    if ([MySimple simpleInterests]) {
//        [MySimple removeView];
//    }
    
////    //禁止tab多次点击
//    UIViewController *tbselect=tabBarController.selectedViewController;
//    if([tbselect isEqual:viewController]){
//        return ;
//    }
    NSString *userIdString = [MYUserDefaults objectForKey:@"userId"];
    
    if (userIdString)
    {
        if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {//订单数据刷新
            QiCaiNavigationController *navigation =(QiCaiNavigationController *)viewController;
            OrderViewController *notice=(OrderViewController *)navigation.topViewController;
            [notice ClickBtnTitleMenuBtn:0];
            //        [notice refreshData];
            
        }else if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {//会员卡 及 优惠券 数据刷新
            QiCaiNavigationController *navigation =(QiCaiNavigationController *)viewController;
            MemberShipCardViewController *notice=(MemberShipCardViewController *)navigation.topViewController;
            [notice refressh];
            
        }else if (viewController == [tabBarController.viewControllers objectAtIndex:3]) {//会员卡 及 优惠券 数据刷新
            QiCaiNavigationController *navigation =(QiCaiNavigationController *)viewController;
            MeViewController *notice=(MeViewController *)navigation.topViewController;
            [notice requestMeCount];

        }
    }

}
////禁止tab多次点击
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    UIViewController *tbselect=tabBarController.selectedViewController;
//    if([tbselect isEqual:viewController]){
//        return NO;
//    }
//    return YES;
//}
#pragma mark 网络状态变化方法
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
        //        self.flagLabel.text = @"Network unreachable!";
        //        [SVProgressHUD showInfoWithStatus:@"无网络链接"];
        VDLog(@"无网络链接");
        MYAppDelegate.isNetworkState = YES;
    }else{
        MYAppDelegate.isNetworkState = NO;
    }
    
    if (status == RealStatusViaWiFi)
    {
        //        self.flagLabel.text = @"Network wifi! Free!";
        //        [SVProgressHUD showInfoWithStatus:@"成功链接WiFi"];
    }
    
    if (status == RealStatusViaWWAN)
    {
        //        self.flagLabel.text = @"Network WWAN! In charge!";
        //        [SVProgressHUD showInfoWithStatus:@"本地流量链接"];
    }
    
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
            //            self.flagLabel.text = @"RealReachabilityStatus2G";
//            [SVProgressHUD showInfoWithStatus:@"2G网络链接"];
        }
        else if (accessType == WWANType3G)
        {
            //            self.flagLabel.text = @"RealReachabilityStatus3G";
//            [SVProgressHUD showInfoWithStatus:@"3G网络链接"];
        }
        else if (accessType == WWANType4G)
        {
            //            self.flagLabel.text = @"RealReachabilityStatus4G";
//            [SVProgressHUD showInfoWithStatus:@"4G网络链接"];
        }
        else
        {
            //            self.flagLabel.text = @"Unknown RealReachability WWAN Status, might be iOS6";
            //             [SVProgressHUD showInfoWithStatus:@"未知网络，可能是IOS6"];
        }
    }
    
    
}

//command alias reveal_load_sim expr (void *)dlopen("/Applications/Reveal.app/Contents/SharedSupport/iOS-Libraries/libReveal.dylib", 0x2);
//command alias reveal_load_dev expr (void*)dlopen([(NSString*)[(NSBundle*)[NSBundle mainBundle] pathForResource:@"libReveal" ofType:@"dylib"] cStringUsingEncoding:0x4],0x2);
//command alias reveal_start expr (void)[(NSNotificationCenter *)[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:nil];
//command alias reveal_stop expr (void)[(NSNotificationCenter *)[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStop" object:nil];
@end
