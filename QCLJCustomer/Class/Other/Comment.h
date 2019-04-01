#import "UIView+Extension.h"

#import "MyNavBar.h"

#import "UINavigationBar+extent.h"
#import "UITabBar+XSDExt.h"
#import "UIBarButtonItem+Extension.h"

#import "UIButton+extent.h"
#import "UILabel+extent.h"
#import "UITextField+extent.h"
#import "NSString+RegularExpression.h"
#import "UIImage+extent.h"
#import "UIImageView+Extention.h"

#import "CHMBProgressHUD.h"//MBProgressHUD二次封装
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CHTextField.h"//自定义CHTextField点击return收回键盘
#import "MySimple.h"//自定义方法
#import "HttpRequest.h"//ANF二次封装

#import "QCHTMLViewController.h"// h5页面

#import "UIViewController+CHNotNetController.h"//状态分类
#import "CHNotInternetView.h"//状态页面

#import "UIControl+CHGControl.h"//分类按钮设置XX时间之内响应

#import "IQKeyboardManager.h"//键盘控制
#import <IQKeyboardReturnKeyHandler.h>//键盘控制

//2.336
/**
 全局
 */
#define QiCaiMargin 5

//44 + 10
#define QiCaiNavHeight 54
#define QiCaiZhifuHeight 40
//0c806938e2413ce73eef92cc3
#define  kServeContentViewCol 3

//MD5密码
#define MD5Password @"4a62435b845e11e6"//拼接在明文前边

//qq的id
#define kQQAppId @"1105383137"

static NSString *QCAuthOpenID = @"wxc36ced2ebd7092d5";//微信OpenID
static NSString *QCAuthState = @"42343242";//微信State

#define WXPatient_App_ID @"wxc36ced2ebd7092d5"
#define WXPatient_App_Secret @"113c104a7e67124e68891adf3e30b410"

#define WX_ACCESS_TOKEN @"access_token"
#define WX_OPEN_ID @"openid"
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"
#define WX_REFRESH_TOKEN @"refresh_token"

//服务器119.90.36.37:8008
//#define kQICAIHttp @"http://119.90.36.37:8008"
//@"http://192.168.1.139:8008"
#define kQICAIHttp @"http://115.47.58.225:8008"

//上线 8888     测试：8008
#define kQCImageHttp @"http://115.47.58.225"

//导航栏的高度（不算状态栏20的高度）
#define NavigationBarHeight 34

//** 16进制颜色 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 主色0xe4007e
 */
#define QiCaiNavBackGroundColor UIColorFromRGB(0xe4007e)
/**
 点缀色0x3984b3
 */
#define QiCaiEmbellishmentColor UIColorFromRGB(0x3984b3)
/**
 菜单文字主色21212
 */
#define QiCaiTitleMainColor UIColorFromRGB(0x212121)
/**
 楼层文字333333
 */
#define QiCaiDeepColor UIColorFromRGB(0x333333)
/**
 正文文字颜色666666
 */
#define QiCaiShallowColor UIColorFromRGB(0x666666)
/**
 标注文字颜色99999
 */
#define QiCaiBZTitleColor UIColorFromRGB(0x999999)

/**
 背景色f6f6f6
 */
#define QiCaiBackGroundColor UIColorFromRGB(0xf6f6f6)

//字体大小
#define QiCaiNavTitle14Font [UIFont systemFontOfSize:16]
#define QiCaiDetailTitle12Font [UIFont systemFontOfSize:12]
#define QiCaiDetailTitle10Font [UIFont systemFontOfSize:10]

#define QiCai10PFFont [UIFont fontWithName:@".PingFang-SC-Light" size:10]
#define QiCai12PFFont [UIFont fontWithName:@".PingFang-SC-Light" size:12]
#define QiCai14PFFont [UIFont fontWithName:@".PingFang-SC-Light" size:14]

#define kTitleMargin 20

//项目里面访问AppDelegate做全局变量
#define MYAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//通知
#define MYNotificationCenter [NSNotificationCenter defaultCenter]
#define MYUserDefaults [NSUserDefaults standardUserDefaults]

/* 自定义log 可以输出所在的类名,方法名,位置(行数)*/
#define VDLog(format, ...) NSLog((@"%s [Line %d] " format), __FUNCTION__, __LINE__, ##__VA_ARGS__)

//拿到屏幕的宽高
#define MYScreenW [UIScreen mainScreen].bounds.size.width
#define MYScreenH [UIScreen mainScreen].bounds.size.height
// 4.7
#define FourInch [UIScreen mainScreen].bounds.size.height == 568.0

// iOS7
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

// 颜色
#define MYColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 颜色
#define MYColorRGB [UIColor colorWithRed:127/255.0 green:81/255.0 blue:98/255.0 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 iOS的版本
 */
#define iOS10 ([[UIDevice currentDevice].systemVersion intValue]>=10?YES:NO)
#define kDownHeight 5


//**订单类型**/
typedef  enum  StateType : NSInteger {
    OrderStateAll = 0,//**全部订单**/
    OrderStateNoComplete, //未完成
    OrderStateComplete,//以完成
    OrderStateToEvaluate // 待评价
    
} StateType;

//**订单服务类型**/
typedef  enum  OrderType : NSInteger {
    /**全部**/
    OrderAlltype = 0,
    /**月嫂**/
    OrderMaternityMatron = 22,
    /**育儿嫂**/
    OrderPaorental = 24,
    /**保姆**/
    OrderNammy = 25,
    /**家政套餐**/
    OrderPackage = 40,
    /**企业服务**/
    OrderEnterpriseService = 41,
    /**门店缴费**/
    OrderStorePayment = 42
} OrderType;


////指明枚举类型
//StateType state = StateType OK;
 //0 待审核        1待接单   2 面试中  3 待付款
