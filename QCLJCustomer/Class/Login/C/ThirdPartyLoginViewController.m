//
//  ThirdPartyLoginViewController.m
//  七彩乐居
//
//  Created by QCJJ－iOS on 16/6/16.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "ThirdPartyLoginViewController.h"
#import "Comment.h"

#import "QiCaiTabBarController.h"

#import "CHTextField.h"

#import "WXApi.h"

#import "SDCycleScrollView.h"//滚动图
#import "SDCycleScrollView+extent.h"//滚动图分类

#import "ThirdPartyLoginModel.h"//登录模型

#import "AppDelegate.h"

//#import <TencentOpenAPI/TencentOAuth.h>
//#import "TencentOpenAPI/QQApiInterface.h"
//#import "WXApiObject.h"
//#import "WXApi.h"
//#import "WeiboSDK.h"

//#import "QCLoginDataMode.h"
//#import "ThirdWeiXinMode.h"

#define offColer UIColorFromRGB(0xe6e6e6)

#import <UIImageView+WebCache.h>

//@interface ThirdPartyLoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate,TencentSessionDelegate,WXApiDelegate>
@interface ThirdPartyLoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate,CHTextFieldDelegate,PopDelegate>
//{
//    TencentOAuth *_tencentOAuth;
//}

@property (nonatomic,weak) UITextField * phoneNumberTextField;
@property (nonatomic,weak) UITextField * passwordTextField;

@property (nonatomic,strong) CHTextField * verificationCodeTextField;//验证码输入框
@property (nonatomic,strong) UIButton * verificationCodeBtn;//验证码按钮
@property (nonatomic,strong) CHTextField * telephoneTextField;//手机号输入框
@property (nonatomic,strong) UIButton * noVerificationCodeBtn; //没有收到按钮
@property (nonatomic,strong) UIButton * signInBtn;//登录按钮
@end

@implementation ThirdPartyLoginViewController
////重写loadView 使键盘上移导航栏不随着上移
//-(void)loadView
//{
//    [super loadView];
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)returnText:(ReturnUeseNameTextToLogBlock)block {
    
    self.returnUeseNameTextToLogBlock = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.teleNuber) {
        self.telephoneTextField.text = self.teleNuber;
        self.verificationCodeBtn.backgroundColor = QiCaiNavBackGroundColor;
        self.verificationCodeBtn.enabled = YES;
    }
    [self setupUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - 懒加载Login
- (CHTextField *)verificationCodeTextField{
    if (!_verificationCodeTextField) {
        _verificationCodeTextField = [CHTextField addCHTextFileWithLeftImage:@"login_verification" frame:CGRectZero placeholder:nil placeholderLabelFont:14 placeholderTextColor:nil];
        _verificationCodeTextField.CHDelegate = self;
        _verificationCodeTextField.cHTextFieldDidChangeDelegate = self;
        _verificationCodeTextField.placeholder = @"请输入验证码";
        _verificationCodeTextField.textColor = QiCaiShallowColor;
        _verificationCodeTextField.returnKeyType = UIReturnKeyDone;
        _verificationCodeTextField.keyboardType = UIKeyboardTypePhonePad;//没有小数点的数字键盘
        _verificationCodeTextField.placeholderLabelFont = [UIFont systemFontOfSize:12];
        _verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [scrollView addSubview:verificationCodeLabel];

    }
    return  _verificationCodeTextField;
}
- (UIButton *)verificationCodeBtn{
    if (!_verificationCodeBtn) {
        _verificationCodeBtn = [UIButton addPopButtonWhiteTitle:@"获取验证码" frame:CGRectZero titleColor:[UIColor whiteColor] backgroundColor:offColer layerBorderColor:nil Target:self action:@selector(verificationCodeBtnChlie:)];
        _verificationCodeBtn.layer.cornerRadius = 2;
        _verificationCodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _verificationCodeBtn.enabled = NO;
        
//        if (MYAppDelegate.timeLogin == 60) {
//            
//        }else{
//            [self addtime];
//        }
        
    }
    return _verificationCodeBtn;
}
- (CHTextField *)telephoneTextField{
    if (!_telephoneTextField) {
//        _telephoneTextField =
        _telephoneTextField = [CHTextField addCHTextFileWithLeftImage:@"login_phone" frame:CGRectZero placeholder:nil placeholderLabelFont:14 placeholderTextColor:nil];
        _telephoneTextField.CHDelegate = self;
        _telephoneTextField.cHTextFieldDidChangeDelegate = self;
        _telephoneTextField.textColor = QiCaiShallowColor;
        _telephoneTextField.cHTextFieldType = CHTextFieldTypeTelephone;
        _telephoneTextField.placeholderLabelFont = [UIFont systemFontOfSize:12];
//        _telephoneTextField.clearsOnBeginEditing = YES;
         _telephoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _telephoneTextField;
}
- (UIButton *)noVerificationCodeBtn{
    if (!_noVerificationCodeBtn) {
        _noVerificationCodeBtn = [UIButton addPopButtonWhiteTitle:@"没有收到？" frame:CGRectZero titleColor:QiCaiShallowColor backgroundColor:[UIColor whiteColor] layerBorderColor:nil Target:self action:@selector(noVerificationCodeBtnChlie:)];
        
        _noVerificationCodeBtn.layer.cornerRadius = 2;
        _noVerificationCodeBtn.layer.borderColor = QiCaiBackGroundColor.CGColor;
    }
    return _noVerificationCodeBtn;
}
- (UIButton *)signInBtn{
    if (!_signInBtn) {
        
        _signInBtn =  [UIButton addPopButtonWhiteTitle:@"登录" frame:CGRectZero titleColor:[UIColor whiteColor] backgroundColor:offColer layerBorderColor:nil Target:self action:@selector(signInBtnChlie:)];
        _signInBtn.enabled = NO;
        _signInBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _signInBtn.acceptEventInterval = 5;
    }
    return _signInBtn;
}
#pragma mark - SDCycleScrollViewDelegate--轮播图代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    VDLog(@"---点击了第%ld张图片", (long)index);
}
/*
 // 滚动到第几张图回调
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
 {
 NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
 }
 */

- (void)setupUI
{
    [UIView addMyNavBarWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight) centerTitle:@"登录" addTarget:self action:@selector(clickBackBtn) contentView:self.view];
    
    // 设置导航栏标题
//    self.navigationItem.title = @"登录";
//    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.hidden = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.y = QiCaiNavHeight;
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];

    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0 , screenFrame.size.width, 153);
    NSArray *imageArray = @[ @"yanglao", @"yuesao",@"peixun"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [scrollView addSubview:cycleScrollView];

    //手机输入框
    CGRect telephoneRect = CGRectMake(10,  CGRectGetMaxY(cycleScrollView.frame) + 17,CGRectGetWidth(scrollView.frame) * 0.6, 33);
    self.telephoneTextField.frame = telephoneRect;
       [scrollView addSubview:_telephoneTextField];
    
    //获取验证码按钮
    CGRect verificationCodeBtnRect = CGRectMake(CGRectGetMaxX(_telephoneTextField.frame) + 10, CGRectGetMinY(_telephoneTextField.frame), CGRectGetWidth(scrollView.frame) - CGRectGetWidth(_telephoneTextField.frame) - 3 * 10, CGRectGetHeight(_telephoneTextField.frame));
    self.verificationCodeBtn.frame = verificationCodeBtnRect;
    [scrollView addSubview:_verificationCodeBtn];
    
    //验证码输入框
    CGRect verificationCodeRect = CGRectMake(10,  CGRectGetMaxY(_telephoneTextField.frame) + 7,CGRectGetWidth(scrollView.frame) * 0.6, 33);
    self.verificationCodeTextField.frame = verificationCodeRect;
    [scrollView addSubview:_verificationCodeTextField];
    
    //没有收到按钮
    CGRect noVerificationCodeBtnRect = CGRectMake(CGRectGetMaxX(_verificationCodeTextField.frame) + 10, CGRectGetMinY(_verificationCodeTextField.frame), CGRectGetWidth(scrollView.frame) - CGRectGetWidth(_verificationCodeTextField.frame) - 3 * 10, CGRectGetHeight(_verificationCodeTextField.frame));
    self.noVerificationCodeBtn.frame = noVerificationCodeBtnRect;
    [scrollView addSubview:_noVerificationCodeBtn];

    //登录
//    signInBtn
    CGRect signInBtnRect = CGRectMake(CGRectGetMinX(_telephoneTextField.frame), CGRectGetMaxY(_noVerificationCodeBtn.frame) + 30, CGRectGetWidth(scrollView.frame) - 2 * CGRectGetMinX(_telephoneTextField.frame), 35);
    self.signInBtn.frame = signInBtnRect;
    _signInBtn.layer.cornerRadius = _signInBtn.height / 2;
    [scrollView addSubview:_signInBtn];
    
    //登录下方协议
    UIButton * agreementBtn = [[UIButton alloc]init];
    agreementBtn.frame = self.signInBtn.frame;
    agreementBtn.y = CGRectGetMaxY(self.signInBtn.frame);
    [agreementBtn setTitle:@"点击“登录”，即表示同意《七彩乐居用户协议》" forState:UIControlStateNormal];
    [agreementBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [agreementBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtnChlie) forControlEvents:UIControlEventTouchUpInside];
    //btn富文本
    [UIButton setRichButtonText:agreementBtn startStr:@"《" endStr:@"》" font:agreementBtn.titleLabel.font color:UIColorFromRGB(0xe4007e)];

    [scrollView addSubview:agreementBtn];
    
    
    //自适应滑动范围
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([scrollView.subviews objectAtIndex:scrollView.subviews.count - 1].frame) + 50);

    //监听长度
     [self.verificationCodeTextField addTarget:self action:@selector(verTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark 限制输入文字长度
//限制输入文字长度
- (void)verTextFieldDidChange:(UITextField *)textField
{
    if (textField == self.verificationCodeTextField) {/**验证码**/
        
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
            
        }else if (textField.text.length == 4) {
            [textField resignFirstResponder];//正确收回键盘
        }
    }
    
}
-(void)clickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
 
}
#pragma mark - 按钮触发方法
//验证码发送倒计时
- (void)verificationCodeBtnChlie:(UIButton *)btn{
    VDLog(@"%@",btn.titleLabel.text);
    if (_telephoneTextField.text.length > 0) {
        if ([NSString checkMobile:_telephoneTextField.text]) {
            
//            //倒计时
//            [self addtime];
            //获取验证码接口
            [self getVerificationCode];
            
        }else{
            VDLog(@"手机号格式错误");
            [CHMBProgressHUD showPrompt:@"请输入正确手机号"];
        }

    }else{
        VDLog(@"手机号格式错误");
        [CHMBProgressHUD showPrompt:@"请输入手机号"];
    }
    
    
    
    
}
/**
 *  倒计时 60
 *
 */
- (void)addtime{
    //60秒倒计时
    
    __block int time = MYAppDelegate.timeLogin;
    __block UIButton *verifybutton = _verificationCodeBtn;
    verifybutton.enabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        MYAppDelegate.timeLogin = time;
        if(time<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                verifybutton.backgroundColor = QiCaiNavBackGroundColor;
                [verifybutton setTitle:@"再次发送" forState:UIControlStateNormal];
                verifybutton.enabled = YES;
                MYAppDelegate.timeLogin = 60;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                verifybutton.backgroundColor = [UIColor lightGrayColor];
                NSString *strTime = [NSString stringWithFormat:@"获取验证码(%d)",time];
                [verifybutton setTitle:strTime forState:UIControlStateNormal];
                verifybutton.titleLabel.textColor = [UIColor whiteColor];
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
  
    



}
//验证码没收到
- (void)noVerificationCodeBtnChlie:(UIButton *)btn{
    
    VDLog(@"%@",btn.titleLabel.text);
    [CHMBProgressHUD showPromptWithMessage:@"请检查手机号是否正确，如果长时间没有收到验证码，可能是因为短信运营网络不给力，请拨打客服电话获取验证码" buttonArr:@[@"拨打客服电话获取验证码"]];
    [CHMBProgressHUD shareinstance].popDelegate = self;
    
}
-(void)PopButton:(UIButton *)PopButton
{
    VDLog(@"popView按钮个数===%ld",PopButton.tag);
    if (PopButton.tag == 0) {//返回编辑
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
    }else{
        
    }
    [CHMBProgressHUD hide];
}
//登录
#pragma mark - 登录接口
- (void)signInBtnChlie:(UIButton *)btn{
    
    VDLog(@"%@",btn.titleLabel.text);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [MYUserDefaults objectForKey:@"sid"];
    params[@"code"] = _verificationCodeTextField.text;
    params[@"mob"] = _telephoneTextField.text;
    NSString * URLStr = [NSString stringWithFormat:@"%@/memberAction.do?method=userLogin&type=1",kQICAIHttp];
    

//    btn.userInteractionEnabled = NO;
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);

        if ([responseObject[@"message"] isEqual:@4] ) {
            VDLog(@"session失效");
            [CHMBProgressHUD showPrompt:@"验证码失效"];
            _verificationCodeBtn.enabled = YES;
//            btn.userInteractionEnabled = YES;
            
        }else if ([responseObject[@"message"] isEqual:@3] ) {
            VDLog(@"参数错误");
            [CHMBProgressHUD showPrompt:@"参数错误"];
        }else if ([responseObject[@"message"] isEqual:@2] ) {
            VDLog(@"验证码错误");
            [CHMBProgressHUD showPrompt:@"验证码错误"];
            _verificationCodeBtn.enabled = YES;
//            btn.userInteractionEnabled = YES;
        }else if ([responseObject[@"message"] isEqual:@0] ) {
            VDLog(@"成功");
            [CHMBProgressHUD showSuccess:@"登录成功"];
            
            NSDictionary * dataDic = responseObject[@"data"];
            ThirdPartyLoginModel * thirdMode = [ThirdPartyLoginModel mj_objectWithKeyValues:dataDic];
            
            //保存用户的数据
            [MYUserDefaults setObject:thirdMode.name forKey:@"name"];
            [MYUserDefaults setObject:thirdMode.mob forKey:@"mob"];
             //        [MYUserDefaults setObject:dataDic[@"sex"] forKey:@"sex"];
            [MYUserDefaults setObject:thirdMode.birthday forKey:@"birthday"];
            [MYUserDefaults setObject:thirdMode.userId forKey:@"userId"];
            [MYUserDefaults setObject:thirdMode.address forKey:@"address"];
            //            [MYUserDefaults setObject:thirdMode.contactName forKey:@"contactName"];
            //            [MYUserDefaults setObject:thirdMode.contactTel forKey:@"contactTel"];
            [MYUserDefaults setObject:thirdMode.addressId forKey:@"addressId"];
            [MYUserDefaults setObject:thirdMode.money forKey:@"money"];//会员卡金额
            //            [MYUserDefaults setObject:thirdMode.couponCount forKey:@"couponCount"];//优惠券数量
            
            [MYUserDefaults setObject:thirdMode.img forKey:@"img"];
            [MYUserDefaults synchronize];
            
            UIImageView * imag22e = [[UIImageView alloc]init];
            if ( ![dataDic[@"img"] isEqualToString:@"default"] || ![dataDic[@"img"] isEqualToString:@""] ) {
                
                NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQCImageHttp,dataDic[@"img"]]];
                
                [imag22e sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"me_iconDefault"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (imag22e.image) {
                        //本地保存
                        [UIImageView SaveImageToLocal:imag22e.image Keys:@"userImageData"];
                        
                        //添加通知，头像更新成功之后，我的页面重新获取一次数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChangeSuccess" object:nil];
                        
                        //                        if (self.returnUeseNameTextToLogBlock != nil) {
                        //                            self.returnUeseNameTextToLogBlock([[UIImageView GetImageFromLocal:@"userImageData"] circleImage],dataDic[@"name"],dataDic[@"mob"],dataDic[@"address"]);
                        //
                        //                        }
                    }
                    NSLog(@"图片加载完成后做的事情");
                }];
            }else{
                //                [imag22e imageToNamed:@"me_personal_information"];
                
                //                imag22e.image = [UIImage imageNamed:@"me_iconDefault"];
                //                //本地保存
                //                [UIImageView SaveImageToLocal:imag22e.image Keys:@"userImageData"];
                
            }
            
            
            if (self.returnUeseNameTextToLogBlock != nil) {
                self.returnUeseNameTextToLogBlock([UIImage imageNamed:@"me_iconDefault"],dataDic[@"name"],dataDic[@"mob"],dataDic[@"address"] );
                
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSError * _Nullable error) {
        [CHMBProgressHUD showFail:@"网络错误，登录失败"];
        _verificationCodeBtn.enabled = YES;
         btn.userInteractionEnabled = YES;
    }];
    
}
//协议
- (void)agreementBtnChlie{
    
    QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
    homeMaternityMatronVC.qcthmlType = QCHTMLTypeUserProtocol;
    [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
}
#pragma mark - 发送验证码接口
- (void)getVerificationCode{
    
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mob"] = _telephoneTextField.text;
    NSString * URLStr = [NSString stringWithFormat:@"%@/memberAction.do?method=registCode",kQICAIHttp];
    
    [[HttpRequest sharedInstance]post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        VDLog(@"%@",responseObject);
        if ([responseObject[@"message"] isEqual:@0]) {
            
            [self addtime];
            
            [CHMBProgressHUD showSuccess:@"验证码已发送"];
            [MYUserDefaults setObject:responseObject[@"sid"] forKey:@"sid"];
            [MYUserDefaults synchronize];
        }else{
            [CHMBProgressHUD showFail:@"验证码发送失败"];
            _verificationCodeBtn.enabled = YES;
            
        }
    } failure:^(NSError * _Nullable error) {
        [CHMBProgressHUD showFail:@"验证码发送失败"];
        _verificationCodeBtn.enabled = YES;
    }];
}
#pragma mark - CHTextFieldDelegate代理方法
- (void)CHTextFieldDidChange:(UITextField *)textField{
    
    if (textField == _telephoneTextField) {
        VDLog(@"%@",textField.text);
        if (textField.text.length > 0) {
            if([_verificationCodeBtn.titleLabel.text rangeOfString:@"("].location !=NSNotFound)//_roaldSearchText
            {
                NSLog(@"yes");
            }
            else
            {
                NSLog(@"no");
                _verificationCodeBtn.backgroundColor = QiCaiNavBackGroundColor;
                _verificationCodeBtn.enabled = YES;
            }
           
        }else{
            _verificationCodeBtn.backgroundColor = offColer;
            _verificationCodeBtn.enabled = NO;
        }
        
        if (_verificationCodeTextField.text.length > 0 && textField.text.length > 0) {
            _signInBtn.backgroundColor = QiCaiNavBackGroundColor;
            _signInBtn.enabled = YES;
        }else{
            _signInBtn.backgroundColor = offColer;
            _signInBtn.enabled = NO;
        }
        
    }else if (textField == _verificationCodeTextField){
        if (_telephoneTextField.text.length > 0 && textField.text.length > 0) {
            _signInBtn.backgroundColor = QiCaiNavBackGroundColor;
            _signInBtn.enabled = YES;
        }else{
            _signInBtn.backgroundColor = offColer;
            _signInBtn.enabled = NO;
        }
    }
}
#pragma mark - 微信登录
/*
 目前移动应用上德微信登录只提供原生的登录方式，需要用户安装微信客户端才能配合使用。
 对于iOS应用,考虑到iOS应用商店审核指南中的相关规定，建议开发者接入微信登录时，先检测用户手机是否已经安装
 微信客户端(使用sdk中的isWXAppInstall函数),对于未安装的用户隐藏微信 登录按钮，只提供其他登录方式。
 */
-(void)loginWeiXin
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID];
    
    if (accessToken && openID) {
        //AccessToken有效期两小时，RefreshToken有效期三十天
        [self getUserInfoWithAccessToken:accessToken andOpenId:openID];
    }else{
        [self wechatLogin];
    }
    
}
- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = QCAuthState;
//        req.openID = QCAuthOpenID;
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - button 触发方法
-(void)back
{
    //    [self.navigationController popViewControllerAnimated:YES];
    
    QiCaiTabBarController *tableViewVC = [[QiCaiTabBarController alloc]init];
    
    [self.navigationController presentViewController:tableViewVC animated:YES completion:^{
        self.view.frame = CGRectMake(0, -self.view.height, self.view.width, self.view.height);
    }];
    
}
#pragma mark --注册
-(void)registration:(UIButton *)button
{
    //    [self.navigationController pushViewController:[[NewUserViewController alloc]init] animated:YES];
}
#pragma mark --忘记密码
-(void)fogetPwd:(UIButton *)button
{
    //    [self.navigationController pushViewController:[[ForgotViewController alloc]init] animated:YES];
}
- (void)chileAgreementBtn
{
    
}

#pragma mark --登录
- (void)chileLoginBtn
{
    [self loginWeiXin];
    
    if (self.phoneNumberTextField.text.length == 0  ) {
        
//        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
    }else
        if (self.passwordTextField.text.length == 0) {
//            [SVProgressHUD showErrorWithStatus:@"密码或账号不正确"];
        }else
        {
//           [MyHttpTool getLoginWithMobString:self.phoneNumberTextField.text];
        }
}
/**
- (void)chileThirdPartyLoginBtn:(UIButton *)btn
{
    if (btn.tag == 0) {
        [self loginQQ];
    }else if(btn.tag == 1)
    {
        [self loginWeiXin];
        
    }else if(btn.tag == 2)
    {
        
        [self loginWeiBo];
    }
    
}
-(void)loginQQ
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            //            kOPEN_PERMISSION_ADD_ALBUM,
                            //            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            //            kOPEN_PERMISSION_ADD_SHARE,
                            //            kOPEN_PERMISSION_ADD_TOPIC,
                            //            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            //            kOPEN_PERMISSION_GET_INFO,
                            //            kOPEN_PERMISSION_GET_OTHER_INFO,
                            //            kOPEN_PERMISSION_LIST_ALBUM,
                            //            kOPEN_PERMISSION_UPLOAD_PIC,
                            //            kOPEN_PERMISSION_GET_VIP_INFO,
                            //            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
    
}
//微信
-(void)loginWeiXin
{
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";//snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact
    req.state = @"42343242";
    req.openID = kWeiXinAppID;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    [WXApi sendAuthReq:req viewController:self delegate:self];
    
}
-(void)loginWeiBo
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kWeiBoAppRedirectURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"QiCaiTabBarController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

#pragma mark --tencentUAuthDelegate －－QQ
-(void)tencentDidLogin
{
    
    [SVProgressHUD showInfoWithStatus:@"登录成功"];
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        //                tokenLable.text = _tencentOAuth.accessToken;
        
        // 用户授权登录后对该用户的唯一标识
        NSString *openId = _tencentOAuth.openId;
        [_tencentOAuth getUserInfo];
    }
    else
    {
        //                tokenLable.text = @"登录不成功 没有获取accesstoken";
        [SVProgressHUD showInfoWithStatus:@"登录不成功 没有获取accesstoken"];
        
    }
    
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        //        _labelTitle.text = @"用户取消登录";
        [SVProgressHUD showInfoWithStatus:@"用户取消登录"];
        
    }
    else
    {
        //        	_labelTitle.text = @"登录失败";
        [SVProgressHUD showInfoWithStatus:@"登录失败"];
    }
}
-(void)tencentDidNotNetWork
{
    //    _labelTitle.text=@"无网络连接，请设置网络";
    [SVProgressHUD showInfoWithStatus:@"无网络连接，请设置网络"];
}


// 获取qq登录的用户信息

-(void)getUserInfoResponse:(APIResponse *)response
{
    [SVProgressHUD showInfoWithStatus:@"登录完成"];
    NSString * str = response.jsonResponse[@"figureurl_qq_2"];
    UIImageView * figureurl_qq_2 = [[UIImageView alloc]init];
        [figureurl_qq_2 sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //本地保存
            [UIImageView SaveImageToLocal:figureurl_qq_2.image Keys:@"userImageData"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    //本地保存
    [MYUserDefaults setObject:response.jsonResponse[@"nickname"] forKey:@"name"];
    [MYUserDefaults setObject:response.jsonResponse[@"nickname"] forKey:@"mname"];
    [MYUserDefaults synchronize];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isLogin = YES;
//    delegate.isLoginSuccess = YES;
    [MYUserDefaults setObject:@"200" forKey:@"isLoginSuccess"];
    NSLog(@"想要的结果：%@---%@",response.jsonResponse[@"nickname"],response.jsonResponse[@"userImageData"]);
}/Users/qcjj-ios/QCLJCustomer/QCLJCustomer

#pragma mark --weixin(可能没用)
-(void)onReq:(BaseReq *)req
{
    NSLog(@"%@",req);
}
- (void) onResp:(BaseResp*)resp
{
    
    NSLog(@"%@",resp);
    
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *sendAuth = (SendAuthResp *)resp;
        NSString *code = sendAuth.code;
        [self getWeiXinReturnMessageWithCode:code];
        
    }
    
}
-(void)getWeiXinReturnMessageWithCode:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeiXinAppID,kWeiXinAppSecret,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        if (data)
        {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        if ([dict objectForKey:@"errcode"])
        {
        //获取token错误
            [SVProgressHUD showInfoWithStatus:@"获取token错误"];
        }else{
        //存储AccessToken OpenId RefreshToken以便下次直接登陆
        //AccessToken有效期两小时，RefreshToken有效期三十天
//            ThirdWeiXinMode *thirdWeiXinMode = [ThirdWeiXinMode mj_objectWithKeyValues:dict];
//            [self getWeiXinImageAndNameWithThirdWeiXinMode:thirdWeiXinMode];
            [MYUserDefaults setObject:dict[@"refresh_token"] forKey:@"kWeiXinRefreshToken"];

            [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];

        }
        }
        });
    });
}
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
 {
     NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
     NSURL *url = [NSURL URLWithString:urlString];

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
             NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
             NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
             dispatch_async(dispatch_get_main_queue(), ^{
    
                if (data)
                    {
                         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
             if ([dict objectForKey:@"errcode"])
            {
                    //AccessToken失效
                [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"kWeiXinRefreshToken"]];
            }else{
                                         
                    //获取需要的数据
                UIImageView * figureurl_qq_2 = [[UIImageView alloc]init];
                [figureurl_qq_2 sd_setImageWithURL:[NSURL URLWithString:dict[@"headimgurl"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //本地保存
                    [UIImageView SaveImageToLocal:figureurl_qq_2.image Keys:@"userImageData"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                //本地保存
                [MYUserDefaults setObject:dict[@"nickname"] forKey:@"name"];
                [MYUserDefaults synchronize];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.isLogin = YES;
//                delegate.isLoginSuccess = YES;
                [MYUserDefaults setObject:@"200" forKey:@"isLoginSuccess"];
                NSLog(@"%@",dict[@"nickname"]);
                
                }
            }
        });
        });
}
 
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
 {
         NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWeiXinAppID,refreshToken];
         NSURL *url = [NSURL URLWithString:urlString];
    
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
                 NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
                 NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
                 dispatch_async(dispatch_get_main_queue(), ^{
        
                        if (data)
                             {
                                     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                                     if ([dict objectForKey:@"errcode"])
                                         {
                             //授权过期
                                             }else{
                                 //重新使用AccessToken获取信息
                                                 
                                                 //获取需要的数据
                                                 UIImageView * figureurl_qq_2 = [[UIImageView alloc]init];
                                                 [figureurl_qq_2 sd_setImageWithURL:[NSURL URLWithString:dict[@"headimgurl"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                     //本地保存
                                                     [UIImageView SaveImageToLocal:figureurl_qq_2.image Keys:@"userImageData"];
                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                 }];
                                                 //本地保存
                                                 [MYUserDefaults setObject:dict[@"nickname"] forKey:@"name"];
                                                 [MYUserDefaults synchronize];
                                                 AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                 delegate.isLogin = YES;
//                                                 delegate.isLoginSuccess = YES;
                                                 [MYUserDefaults setObject:@"200" forKey:@"isLoginSuccess"];

                                                 }
                                 }
                     });
             });
}
 */
-(void)chileTelephoneBtn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}
#pragma mark - 微信登录 处理返回数据，获取code
//通过code获取access_token，openid，unionid
//处理返回数据，获取code
- (void)getWeiXinOpenId:(BaseResp *)resp{
    
    if (resp.errCode == 0)
        
    {
        //        statusCodeLabel.text = @"用户同意";
    SendAuthResp *aresp = (SendAuthResp *)resp;
    [self getAccessTokenWithCode:aresp.code];
        
    }else if (resp.errCode == -4){
        //        statusCodeLabel.text = @"用户拒绝";
    }else if (resp.errCode == -2){
        //         statusCodeLabel.text = @"用户取消";
    }
    
  
}
#pragma mark - 微信登录 使用code获取access token
//使用code获取access token
- (void)getAccessTokenWithCode:(NSString *)code
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXPatient_App_ID,WXPatient_App_Secret,code];
    
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //获取token错误
//                    [self wechatLogin];
                }else{
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    NSString *accessToken = [dict objectForKey:WX_ACCESS_TOKEN];
                    NSString *openID = [dict objectForKey:WX_OPEN_ID];
                    NSString *refreshToken = [dict objectForKey:WX_REFRESH_TOKEN];
                    // 本地持久化，以便access_token的使用、刷新或者持续
                    if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                        [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                        [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
                    }
                    
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    [self getUserInfoWithAccessToken:accessToken andOpenId:openID];
                }
            }
        });
    });
    
    /*
     正确返回
     "access_token" = “Oez*****8Q";
     "expires_in" = 7200;
     openid = ooVLKjppt7****p5cI;
     "refresh_token" = “Oez*****smAM-g";
     scope = "snsapi_userinfo";
     */
    /*
     错误返回
     errcode = 40029;
     errmsg = "invalid code";
     */
    
}
//使用AccessToken获取用户信息
#pragma mark - 微信登录 使用AccessToken获取用户信息
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"]){
                    
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:WX_REFRESH_TOKEN]];
                    /*
                     42001 access_token超时，请检查access_token的有效期，请参考基础支持-获取access_token中，对access_token的详细机制说明
                     42002 refresh_token超时
                     */
                    
                }else{
                    //获取需要的数据
                    VDLog(@"%@",dict);
                    self.navigationItem.title = dict[@"unionid"];
                }
            }
        });
    });
    /*
     29      city = ****;
     30      country = CN;
     31      headimgurl = "http://wx.qlogo.cn/mmopen/q9UTH59ty0K1PRvIQkyydYMia4xN3gib2m2FGh0tiaMZrPS9t4yPJFKedOt5gDFUvM6GusdNGWOJVEqGcSsZjdQGKYm9gr60hibd/0";
     32      language = "zh_CN";
     33      nickname = “****";
     34      openid = oo*********;
     35      privilege =     (
     36      );
     37      province = *****;
     38      sex = 1;
     39      unionid = “o7VbZjg***JrExs";
     40      */
    
    /*
     43      错误代码
     44      errcode = 42001;
     45      errmsg = "access_token expired";
     46      */
}
//使用RefreshToken刷新AccessToken
#pragma mark - 微信登录 使用RefreshToken刷新AccessToken
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken{

     NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WXPatient_App_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    
                    //授权过期
                    [self wechatLogin];
                    
                }else{
                    
                    //重新使用AccessToken获取信息
                    
                    NSString *accessToken = [dict objectForKey:WX_ACCESS_TOKEN];
                    NSString *openID = [dict objectForKey:WX_OPEN_ID];
                    NSString *refreshToken = [dict objectForKey:WX_REFRESH_TOKEN];
                    // 本地持久化，以便access_token的使用、刷新或者持续
                    if (accessToken && ![accessToken isEqualToString:@""] && openID && ![openID isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
                        [[NSUserDefaults standardUserDefaults] setObject:openID forKey:WX_OPEN_ID];
                        [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
                        [[NSUserDefaults standardUserDefaults] synchronize]; // 命令直接同步到文件里，来避免数据的丢失
                    }
                    
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    [self getUserInfoWithAccessToken:accessToken andOpenId:openID];
                }
                
            }
        });
    });
    /*
     30      "access_token" = “Oez****5tXA";
     31      "expires_in" = 7200;
     32      openid = ooV****p5cI;
     33      "refresh_token" = “Oez****QNFLcA";
     34      scope = "snsapi_userinfo,";
     35      */
    
    /*
     38      错误代码
     39      "errcode":40030,
     40      "errmsg":"invalid refresh_token"
     41      */
}

@end