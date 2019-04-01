//
//  HomeViewController.m
//  七彩乐居
//
//  Created by 李大娟 on 16/2/29.
//  Copyright © 2016年 七彩乐居. All rights reserved.

//2.336

#import "HomeViewController.h"
#import "Comment.h"
#import "MyButton.h"

#import "SDCycleScrollView.h"//滚动图
#import "SDCycleScrollView+extent.h"//滚动图分类

#import "AYCheckManager.h"//检查版本更新

#import "QiCaiTabBarController.h"

#import "PPNumberButton.h"//加减

#import "CHTextField.h"//自定义CHTextField点击return收回键盘

#import "CHAlertController.h"//自定义系统弹窗

#import "HomeCenterView.h"//快捷入口按钮
#import "MyCityViewController.h"//城市

#import "QCHTMLViewController.h"//h5页面
#import "StorePaymentViewController.h"//门店缴费


//#import "AppDelegate.h"
//#import "HomeMaternityMatronSummitController.h"

//#import "OrderPayViewController.h"//临时订单支付
//#import "GaodePOIViewController.h"//临时地图
//#import "PersonalInformationViewController.h"//临时个人信息
////#import "CHPopView.h"
//
//#import "OrderCancelViewController.h"//订单取消

#define HomeNavLocationFont QiCaiTitleTitleFont
#define HomeScrollViewHeight 125
#define HomeCenterViewHeight 192
#define HomeCenterWithFootMargin 8
#define HomeFootViewHeight 173
#define HomeNavTopY 13


#define MHSafeString(str) (str == nil ? @"" : str)


@interface HomeViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,clickHomeCenterViewDelegate,PopDelegate>


@property (strong, nonatomic) UIView *navView;
@property (weak,nonatomic) UIButton *leftBtn;

@property (nonatomic, strong) NSMutableArray *topics;

@property (nonatomic,strong)UILabel *memberCountLabel;
@end

@implementation HomeViewController
////重写loadView 使键盘上移导航栏不随着上移
//-(void)loadView
//{
//    [super loadView];
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //导航栏
    [self setupNavbar];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;

    [self setupUI];
    
    /**
     测试
     */
//    [MYUserDefaults setObject:@"6560" forKey:@"userId"];

    //更新
    [self setVersionUpdate];
    
//    //tabber 红点
//    [self.tabBarController.tabBar showBadgeOnItemIndex:1];
    

//    //仿京东加减按钮
//    [self example1];
    
//    UIButton * loginButn = [UIButton buttonWithType:UIButtonTypeCustom];
//    loginButn.frame = CGRectMake(100, 100, 150, 70);
//    [loginButn setTitle:@"订单支付" forState:UIControlStateNormal];
//    [loginButn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    [loginButn setBackgroundColor:[UIColor blueColor]];
//    [loginButn addTarget:self action:@selector(loginButnClink) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginButn];
//    loginButn.acceptEventInterval = 5;
//   
//    CHTextField *preDepositTextField = [CHTextField addCHTextFileWithLeftImage:nil frame: CGRectMake(100, 100, 150, 70) placeholder:@"fsdfsdf" placeholderLabelFont:12 placeholderTextColor:QiCaiShallowColor];
//    [self.view addSubview:preDepositTextField];
//    preDepositTextField.cHTextFieldType = CHTextFieldTypeName;
//    preDepositTextField.CHDelegate = self;
//    preDepositTextField.font = QiCaiDetailTitle12Font;
//    preDepositTextField.backgroundColor = [UIColor yellowColor];

   
    
    

//     [self.navigationController.navigationBar addSubview:self.titleIMg];
    /**
     *  假数字
     *
     *  @return  首页的数据 和月嫂提交页的数据
     */
    [self addNuber];
}
#pragma mark- 通知 UITextInputCurrentInputModeDidChangeNotification
-(void) changeMode:(NSNotification *)notification{
//    UITextField *textField = (UITextField *)notification.object;
//    NSString *toBeString = textField.text;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        int chNum =0;
//        for (int i=0; i<toBeString.length; ++i)
//        {
//            NSRange range = NSMakeRange(i, 1);
//            NSString *subString = [toBeString substringWithRange:range];
//            const char *cString = [subString UTF8String];
//            if (strlen(cString) == 3)
//            {
//                NSLog(@"汉字:%@",subString);
//                chNum ++;
//            }
//        }
//        
//        if (chNum>=9) {
////            _canedit =NO;
//        }
//        
//        if (!position) {
//            if (toBeString.length > 10) {
//                textField.text = [toBeString substringToIndex:10];
////                _canedit =YES;
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//        }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        if (toBeString.length > 20) {
//            textField.text = [toBeString substringToIndex:20];
////            _canedit =NO;
//        }
//    }
}

#pragma mark- 订单支付
- (void)loginButnClink{
    
    //更新
    [self setVersionUpdate];
    
    //这里是关键，点击按钮后先取消之前的操作，再进行需要进行的操作
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClicked:) object:nil];
//    [self performSelector:@selector(buttonClicked: )withObject:sender afterDelay:0.2f];
    
    VDLog(@"11111");
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClicked:) object:nil];
//    [self performSelector:@selector(buttonClicked:) withObject:nil afterDelay:3.0f];
    
    
////    GaodePOIViewController * thirdPartyVC = [[GaodePOIViewController alloc]init];
////    
////    [self.navigationController pushViewController:thirdPartyVC animated:YES];
//    OrderPayViewController *myCityVC = [[OrderPayViewController alloc]init];
//    [self.navigationController pushViewController:myCityVC animated:YES];
}
- (void)buttonClicked:(UIButton *)btn{
    VDLog(@"2222");

}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    VDLog(@"---点击了第%ld张图片", (long)index);
////        [[CHPopView sharedInstance] showPopViewWhitImage:@"home_enterpriseService" title:@"温馨提示" message:@"订单支付还未完成，您确定离开吗？" buttonArr:@[@"继续支付",@"确定离开"] titleColor:[UIColor blackColor]];
//
//
////    [CHMBProgressHUD showSuccess:@"成功"];
//    
////    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
////    [CHMBProgressHUD showPopView:view mode:CHProgressModePrompt title:@"温馨提示" message:@"支订单我完成，您确定离开吗" buttonArr:@[@"确定离开",@"继续支付"]];
//    
//    [CHMBProgressHUD showPromptWithMessage:@"支订单未完成，您确定离开吗" buttonArr:@[@"确定离开",@"继续支付"]];
//    [CHMBProgressHUD shareinstance].popDelegate = self;
////    [CHMBProgressHUD showOneBtnWtihTiitle:@"订单已超时" message:@"范德萨发生" btnName:@"重新下单" mode:CHProgressModePrompt];
//    
////    [CHMBProgressHUD showFail:@"订单超时"];
//    
//    
//    
//    //    [CHAlertController CHAlertControllerWithTitle:@"温馨提示" message:@"您已欠费，请及时充费" CallBackBlock:^(NSInteger btnIndex) {
//    //        NSLog(@"======%ld",(long)btnIndex);
//    //    } cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil];
//    
//    //    [CHAlertController CHAlertControllerWithTitle:@"CHAlertControllerWithTitle" message:@"message" preferredStyle:UIAlertControllerStyleAlert CallBackBlock:^(NSInteger btnIndex) {
//    //
//    //    } titleColor:[UIColor blueColor] messageColor:[UIColor redColor] cancelButtonColor:[UIColor blueColor] destructiveButtonColor:nil otherBtnTintColor:nil cancelButtonTitle:@"c      " destructiveButtonTitle:@"d    " otherButtonTitles:nil];
//    
//    //    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
    
}

/*
 
 // 滚动到第几张图回调
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
 {
 NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
 }
 
 */
- (void)PopButton:(UIButton *)PopButton{
    VDLog(@"popView按钮个数===%ld",PopButton.tag);
}
-(void)setupUI
{
    
//    //导航栏
//    [self setupNavbar];

    
    UIScrollView *scrollViewSlip = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollViewSlip.y = 34;
    scrollViewSlip.delegate = self;
    scrollViewSlip.showsHorizontalScrollIndicator = NO;
    scrollViewSlip.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollViewSlip];
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0 , screenFrame.size.width, HomeScrollViewHeight);
    NSArray *imageArray = @[ @"yanglao", @"yuesao",@"peixun",@"hjc"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [scrollViewSlip addSubview:cycleScrollView];
    
    UIView * noticeview = [[UIView alloc]init];
    noticeview.frame = CGRectMake(CGRectGetMinX(cycleScrollView.frame), CGRectGetMaxY(cycleScrollView.frame), CGRectGetWidth(cycleScrollView.frame), 32);
    //    noticeview.backgroundColor = [UIColor whiteColor];
    [scrollViewSlip addSubview:noticeview];
    
    NSString *noticeLabelText = @"北京已经有 153057 户家庭使用七彩乐居";
    self.memberCountLabel = [UILabel addLabelWithFrame:CGRectMake(10, 0, CGRectGetWidth(noticeview.frame), CGRectGetHeight(noticeview.frame)) text:noticeLabelText size:10.3 textAlignment:NSTextAlignmentCenter];
    [noticeview addSubview:self.memberCountLabel];
    
    //设置富文本
    //设置不同的字体颜色
    [UILabel setRichLabelText:self.memberCountLabel startStr:@"有" endStr:@"户" font:QiCaiDetailTitle12Font color:UIColorFromRGB(0xe4007e)];
//    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:noticeLabelText];
//    NSRange startRange = [noticeLabelText rangeOfString:@"有"];
//    NSRange endRange = [noticeLabelText rangeOfString:@"户"];
//    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
//    [textStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:range];
//    [textStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe4007e) range:range];
//    noticeLabel.attributedText = textStr;

    
    
    
    //中间的快捷入口
    HomeCenterView *centerView = [[HomeCenterView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(noticeview.frame) , MYScreenW, HomeCenterViewHeight)];
    centerView.homeCenterViewDelegate = self;
    centerView.backgroundColor = [UIColor whiteColor];
    [scrollViewSlip addSubview:centerView];
    
    //下面的
    UIView * footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, CGRectGetMaxY(centerView.frame) + 5, CGRectGetWidth(centerView.frame), 114);
    footView.backgroundColor = [UIColor whiteColor];
    [scrollViewSlip addSubview:footView];
    
    //UIBUtton  Right
    CGRect rightBtnRect  = CGRectMake(10, 10.7, (CGRectGetWidth(footView.frame) - 30) / 2, 90);
    [self addBtnToView:footView btnFrame:rightBtnRect btnName:@"Home_Foot_right" labelTitle:@"家教培训" Target:self action:@selector(leftBtnChlie)];
    
    //UIBUtton Left
    CGRect leftBtnRect = CGRectMake((CGRectGetWidth(footView.frame) - 30) / 2 + 20, 10.7,  (CGRectGetWidth(footView.frame) - 30) / 2, 90);
    [self addBtnToView:footView btnFrame:leftBtnRect btnName:@"Home_Foot_left" labelTitle:@"养老服务" Target:self action:@selector(rightBtnChlie)];
    
}
//创建nav
-(void)setupNavbar
{
    //添加nav的子控件
    MyButton *locationBtn = [[MyButton alloc]init];
    
    locationBtn.imageView.contentMode = UIViewContentModeCenter;
    locationBtn.frame = CGRectMake(10, 25, 70, QiCaiNavHeight - 30);
    locationBtn.backgroundColor = [UIColor clearColor];
    
    //设置文字
    [locationBtn setTitle:@"北京市" forState:UIControlStateNormal];
    locationBtn.imageView.x = CGRectGetMaxX(locationBtn.titleLabel.frame) + 4;
    [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationBtn.titleLabel.font = QiCaiDetailTitle12Font;
    // 设置图片
    [locationBtn setImage:[UIImage imageNamed:@"Main_public_lower"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"Main_public_lower"] forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(clickLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = locationBtn;

//    // 设置导航栏标题
//    self.navigationItem.title = @"七彩乐居";
////    self.navigationController.navigationBar.translucent = NO;
////    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    // 设置导航栏左边的按钮
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithButton:locationBtn];
//    // 设置导航栏右边的按钮
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"Main_public_telephone" action:@selector(clickPhotoBtn) target:self];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight)];
    
    navView.backgroundColor = MYColor(228, 0, 126);
    self.navView = navView;
    //    self.navigationItem.titleView = navView;
    [self.view addSubview:navView];
    
    [self.navView addSubview:locationBtn];
    
    UIButton *titleViewBtn = [UIButton addButtonWithFrame:CGRectMake(2 * 44 , HomeNavTopY, MYScreenW - 4 * 50, 40) title:[NSString stringWithFormat:@"七彩乐居"] backgroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] font:QiCaiNavTitle14Font Target:nil action:nil];
    [navView addSubview:titleViewBtn];
    
    UIButton *photoBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 45, HomeNavTopY +17,40,40) image:[NSString stringWithFormat:@"Main_public_telephone"] highImage:nil backgroundColor:[UIColor clearColor] Target:self action:@selector(clickPhotoBtn)];
    photoBtn.centerY = titleViewBtn.centerY = locationBtn.centerY;
    titleViewBtn.centerX = CGRectGetWidth(navView.frame) / 2;
    [navView addSubview:photoBtn];

}


- (void)setVersionUpdate{
    AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
    checkManger.countryAbbreviation = @"cn";
    //    checkManger.openAPPStoreInsideAPP = YES;
    //    [checkManger checkVersion];
    checkManger.debugEnable = YES;
    checkManger.openAPPStoreInsideAPP = YES;
    [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"下次提示" confimTitle:@"前往更新"];
}

#pragma mark - foot btn 创建方法
- (void)addBtnToView:(UIView *)view btnFrame:(CGRect)btnFrame btnName:(NSString *)btnName labelTitle:(NSString *)labelTitle Target:(id)target action:(SEL)action{
    
    UIButton * rightBtn = [[UIButton alloc]init];
    rightBtn.frame = btnFrame;
    [rightBtn setImage:[UIImage imageNamed:btnName] forState:UIControlStateNormal];
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, CGRectGetHeight(rightBtn.frame) - 25, CGRectGetWidth(rightBtn.frame), 25);
    imageView.image = [UIImage imageNamed:@"Home_Foot_BlackBackground"];
    [rightBtn addSubview:imageView];

    UILabel * label = [UILabel addNoLayerLabelWithFrame:imageView.frame text:labelTitle textColor:[UIColor whiteColor] backgroundColor:nil size:13 textAlignment:NSTextAlignmentCenter];
    [rightBtn addSubview:label];
}
#pragma mark -- Foot触发方法
/**
 家政培训
 */
- (void)leftBtnChlie{
    
    [self clickH5BtnWithType:QCHTMLTypeHomeEconmicsTraining];
}

/**
 养老服务
 */
- (void)rightBtnChlie{
    
    [self clickH5BtnWithType:QCHTMLTypePensionService];
}


#pragma mark -- homeCenterDelegate
//月嫂
-(void)clickMaternityMatronBtn
{
    [self clickH5BtnWithType:QCHTMLTypeMaternityMatron];
}
//育儿嫂
-(void)clickParentalBtn
{
    [self clickH5BtnWithType:QCHTMLTypeParental];
}
//保姆
-(void)clickNannyBtn
{
    [self clickH5BtnWithType:QCHTMLTypeNanny];

}
//保洁套餐
-(void)clickCleaningPackageBtn
{
    [self clickH5BtnWithType:QCHTMLTypeHomePackage];

}
//企业服务
-(void)clickEnterpriseServiceBtn
{
    [self clickH5BtnWithType:QCHTMLTypeEnterpriseSerview];
 
}
//门店消费
-(void)clickStoreConsumptionBtn
{
    StorePaymentViewController *storePaymentVC = [[StorePaymentViewController alloc]init];
    [self.navigationController pushViewController:storePaymentVC animated:YES];
}

-(void)clickH5BtnWithType:(QCHTMLType)type
{
    QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
    homeMaternityMatronVC.qcthmlType = type;
    [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
 
}
#pragma mark -- nav方法
/**
 *位置
 */
-(void)clickLocationBtn:(UIButton *)btn
{
    MyCityViewController *myCityVC = [[MyCityViewController alloc]init];
    if (btn.titleLabel.text.length > 2) {
        myCityVC.cityHomeStr = btn.titleLabel.text;
    }
    [myCityVC returnText:^(NSString *cityStr) {
        [btn setTitle:cityStr forState:UIControlStateNormal];
    }];
    [self.navigationController presentViewController:myCityVC animated:YES completion:nil];
}
/**
 photo
 */
-(void)clickPhotoBtn
{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}


#pragma mark -- other
//默认状态
- (void)example1
{
    PPNumberButton *numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(50, 300, 110, 30)];
    //开启抖动动画
    numberButton.shakeAnimation = YES;
    //设置边框颜色
    numberButton.borderColor = [UIColor yellowColor];
    //设置加减按钮文字
    [numberButton setTitleWithIncreaseTitle:@"加" decreaseTitle:@"减"];
//    //自定义加减按钮背景图片
//    [numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"timeline_relationship_icon_addattention"] decreaseImage:[UIImage imageNamed:@"decrease_highlight"]];

    numberButton.numberBlock = ^(NSString *num){
        NSLog(@"%@",num);
        
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
//        //获取当前View的position坐标
//        CGFloat positionX = numberButton.layer.position.x;
//        //设置抖动的范围
//        animation.values = @[@(positionX-10),@(positionX),@(positionX+10)];
//        //动画重复的次数
//        animation.repeatCount = 3;
//        //动画时间
//        animation.duration = 0.07;
//        //设置自动反转
//        animation.autoreverses = YES;
//        [numberButton.layer addAnimation:animation forKey:nil];

    };
    
    [self.view addSubview:numberButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/**
 *  请求假数据
 */
- (void)addNuber{
    
    NSString * URLStr = [NSString stringWithFormat:@"%@/lieNum.do?method=getLieNum",kQICAIHttp];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"] isEqualToNumber:@0]) {
            
            [MYUserDefaults setObject:responseObject[@"memberCount"] forKey:@"memberCount"];
            [MYUserDefaults setObject:responseObject[@"orderCount"] forKey:@"orderCount"];
            [MYUserDefaults synchronize];
            
            self.memberCountLabel.text = [NSString stringWithFormat:@"北京已经有 %@ 户家庭使用七彩乐居",responseObject[@"memberCount"]];
            //设置富文本
            //设置不同的字体颜色
            [UILabel setRichLabelText:self.memberCountLabel startStr:@"有" endStr:@"户" font:QiCaiDetailTitle12Font color:UIColorFromRGB(0xe4007e)];
        }
    } failure:^(NSError * _Nullable error) {
        [MYUserDefaults setObject:@"3521" forKey:@"memberCount"];
        [MYUserDefaults setObject:@"624" forKey:@"orderCount"];
        [MYUserDefaults synchronize];
    }];
}
@end
