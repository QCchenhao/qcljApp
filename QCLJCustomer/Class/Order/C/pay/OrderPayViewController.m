
//
//  OrderPayViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/13.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "OrderPayViewController.h"

#import "CWStarRateView.h"
#import "MyTextView.h"

#import "MeConponViewController.h"//优惠券列表
#import "ConponMode.h" //优惠券模型

@interface OrderPayViewController ()<CWStarRateViewDelegate,UITextViewDelegate>

@property (nonatomic,assign)NSInteger second;
@property (nonatomic,assign)NSInteger minute;
@property (weak, nonatomic)UILabel * timeLabel;
@property (nonatomic, strong)NSTimer *timer;

@property (weak, nonatomic)UIView *payView;

@property (assign, nonatomic)CGFloat  moneyStr;

/********************************************************
 *  余额-会员卡 Member
 */
@property (weak, nonatomic)UIButton *membershipBtn;
/**
 *  余额-优惠券
 */
@property (weak, nonatomic)UIButton *discountBtn;

/*********************************************************
 *  -优惠券--无可用优惠券
 */
@property (strong, nonatomic)UILabel * discountLabel2;

/*********************************************************
 *  订单总价-会员卡
 */
@property (weak, nonatomic)UILabel * memberLabel;
/**
 *  订单总价-优惠券
 */
@property (weak, nonatomic)UILabel * discountPayLabel;


/**
 * 还需支付
 */
@property (weak, nonatomic)UILabel * payLabel;
/**
 *  优惠券数组
 */
@property (nonatomic,strong)NSMutableArray * conponArr;
/**
 *  回调优惠券模型
 */
@property (nonatomic,strong)ConponMode * conponMode;
@end

@implementation OrderPayViewController
- (void)returnOrderList:(ReturnOrderBlock)block{
    self.returnOrderBlock = block;
}
-(NSMutableArray *)conponArr{
    if (!_conponArr) {
        _conponArr = [NSMutableArray array];
    }
    return _conponArr;
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
    
    //倒计时
    self.minute = 15;
    self.second = 0;
    
//    //传值支付模型初始值
//    NSDictionary *dic = @{
//                          @"couponLogId" : @"0",
//                          @"stid" : self.detailsModel.orderId,
//                          };
//    
//    self.payModel = [PayModel mj_objectWithKeyValues:dic];
    
    self.navigationItem.title = @"订单支付";
    [self setUpUI];
    if (self.detailsModel.stid != 42) {
        [self addAfn];
        self.discountBtn.enabled = YES;
    }else{
        self.discountBtn.enabled = NO;
    }
    
    //监听事件 微信
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserWeiXinChangeSuccess" object:nil];
    
    //监听事件 支付宝
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserAlipayChangeSuccess" object:nil];
    
    //监听事件 会员卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserHuiyuankaChangeSuccess" object:nil];
    
    //    [self requestMeCount];
}

//4. 观察者注销，移除消息观察者
-(void)dealloc
{
    [MYNotificationCenter removeObserver:@"UserWeiXinChangeSuccess"];
    [MYNotificationCenter removeObserver:@"UserAlipayChangeSuccess"];
    [MYNotificationCenter removeObserver:@"UserHuiyuankaChangeSuccess"];
}
- (void)getUserInfoData{
    
//    [self.tableView.mj_header beginRefreshing];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setUpUI{
     [self.view addSubview:self.scrollView];
    //倒计时
    UIView * timeView = [self timeView];

    NSArray * imageArr;
    NSArray * titleArr;
    //前四个信息
    NSString * nameStr = [MYUserDefaults objectForKey:@"name"];
    NSString * mobStr = [MYUserDefaults objectForKey:@"mob"];
    NSString *addressStr = self.detailsModel.address;
    
    NSArray * conterArr;
    

    if (self.detailsModel.stid == 42 ) {
        imageArr = @[@"icon_lianxiren",@"icon_shoujihao"];
        titleArr = @[@"联  系  人：",@"联系电话："];
        conterArr = @[nameStr,mobStr];
    }else{
        imageArr = @[@"icon_lianxiren",@"icon_shoujihao",@"icon_shijian",@"icon_dizhi"];
        titleArr = @[@"联  系  人：",@"联系电话：",@"服务时间：",@"服务地址："];
        conterArr = @[nameStr,mobStr,self.detailsModel.stime,addressStr];
        
    }
   [self informationToY:CGRectGetMaxY(timeView.frame) + 5 imageArr:imageArr titleArr:titleArr conterArr:conterArr];
    self.moneyStr = [[MYUserDefaults objectForKey:@"money"] floatValue];
//    NSString * couponCountStr = [MYUserDefaults objectForKey:@"couponCount"];
    //会员卡
    UILabel * membershipLabel2 = [[UILabel alloc]init];
    membershipLabel2.text = @"共有有1张会员卡可以使用";
    UIButton * membershipBtn = [self addMembershipAndDiscountToY:CGRectGetMaxY(timeView.frame) + 5 + imageArr.count * 42 imageName:@"order_pay_membership" label1Text:@"会员卡" label2:membershipLabel2 buttonText:[NSString stringWithFormat:@"余额：%.2f元",self.moneyStr]];
    self.membershipBtn = membershipBtn;
    //优惠券
    self.discountLabel2 = [[UILabel alloc]init];
    [self.discountLabel2 setText:[NSString stringWithFormat:@"无可用优惠券"]];
     UIButton * discountBtn =
    [self addMembershipAndDiscountToY:CGRectGetMaxY(timeView.frame) + 5 + imageArr.count * 42 + CGRectGetHeight(membershipBtn.frame)  imageName:@"order_pay_discount" label1Text:@"优惠券" label2:self.discountLabel2  buttonText:@""];
    self.discountBtn = discountBtn;
    //订单总价
    UIView * orderPriceView = [[UIView alloc]init];
    orderPriceView.frame= CGRectMake(0, CGRectGetMaxY(timeView.frame) + 5 + imageArr.count * 42 + CGRectGetHeight(membershipBtn.frame) * 2, CGRectGetWidth(self.scrollView.frame),  2);
    orderPriceView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:orderPriceView];

    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"icon_yongjin"];
    imageView.frame = CGRectMake(10, 0, 40 * 0.4, 40 * 0.4);
    [orderPriceView addSubview:imageView];
    
    //订单总价
    UILabel *totalLabel = [self addOrderPriceToView:orderPriceView frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, CGRectGetWidth(orderPriceView.frame) * 0.4, 25) labelText1:@"订单总价" labelText2:[NSString stringWithFormat:@"%.2f元",self.detailsModel.sprice] labelColor1:QiCaiDeepColor labelColor2:QiCaiDeepColor labelFont:QiCai12PFFont];
    imageView.centerY = totalLabel.centerY;
    
    CGFloat height = 18;
    NSString * temp;
    switch (self.detailsModel.stid) {
        case OrderMaternityMatron:
            temp = @"月嫂";
            break;
        case OrderPaorental:
            temp = @"育儿";
            break;
        case OrderNammy:
            temp = @"保姆";
            break;
        case OrderPackage:
            temp = @"家政";
            break;
        case OrderEnterpriseService:
            temp = @"企业";
            break;
        case OrderStorePayment:
            temp = @"缴费";
            break;
            
        default:
            break;
    }
    //月嫂服务金额
    NSString * serviceStr ;
    if (self.detailsModel.count.length > 0) {
        serviceStr = [NSString stringWithFormat:@"%.2f元 x%@",self.detailsModel.price,self.detailsModel.count];
    }else{
        serviceStr = [NSString stringWithFormat:@"%.2f元",self.detailsModel.price];
    }
    UILabel * yuesaoServiceLabel = [self addOrderPriceToView:orderPriceView frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(totalLabel.frame) , CGRectGetWidth(orderPriceView.frame) * 0.4, height) labelText1:[NSString stringWithFormat:@"%@服务：",temp] labelText2:serviceStr labelColor1:QiCaiBZTitleColor labelColor2:QiCaiBZTitleColor labelFont:QiCai10PFFont];

    //月嫂保险金额
    UILabel * yuesaoInsuranceLabel = [self addOrderPriceToView:orderPriceView frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(yuesaoServiceLabel.frame) , CGRectGetWidth(orderPriceView.frame) * 0.4, height) labelText1:[NSString stringWithFormat:@"%@保险：",temp] labelText2:[NSString stringWithFormat:@"%.2f元",self.detailsModel.einsu] labelColor1:QiCaiBZTitleColor labelColor2:QiCaiBZTitleColor labelFont:QiCai10PFFont];
    
    //会员卡金额 Member
    UILabel * memberLabel = [self addOrderPriceToView:orderPriceView frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(yuesaoInsuranceLabel.frame) , CGRectGetWidth(orderPriceView.frame) * 0.4, height) labelText1:@"会  员 卡：" labelText2:@"-0.00元" labelColor1:QiCaiBZTitleColor labelColor2:QiCaiBZTitleColor labelFont:QiCai10PFFont];
    self.memberLabel = memberLabel;
    //优惠券金额 Discount
    UILabel * discountPayLabel = [self addOrderPriceToView:orderPriceView frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(memberLabel.frame) , CGRectGetWidth(orderPriceView.frame) * 0.4, height) labelText1:@"优  惠  券：" labelText2:@"-0.00元" labelColor1:QiCaiBZTitleColor labelColor2:QiCaiBZTitleColor labelFont:QiCai10PFFont];
    self.discountPayLabel = discountPayLabel;
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10,  CGRectGetMaxY(discountPayLabel.frame) + 5 ,CGRectGetMaxX(discountPayLabel.frame) - CGRectGetMaxX(imageView.frame) - 10, 1)];
    line.backgroundColor = QiCaiBackGroundColor;
    [orderPriceView addSubview:line];
    
    //还需支付
     UILabel * payLabel =
    [self addOrderPriceToView:orderPriceView frame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(line.frame) , CGRectGetWidth(orderPriceView.frame) * 0.4, 35) labelText1:@"还需支付：" labelText2:@"0.00元" labelColor1:QiCaiShallowColor labelColor2:QiCaiNavBackGroundColor labelFont:QiCai12PFFont];
    self.payLabel = payLabel;
    
    orderPriceView.height = CGRectGetMaxY([ orderPriceView.subviews objectAtIndex:orderPriceView.subviews.count - 1].frame);

    
    //支付View
    UIView *payView = [[UIView alloc]init];
    payView.frame = CGRectMake(0, CGRectGetMaxY(orderPriceView.frame) + 5, MYScreenW, 10);
    payView.backgroundColor = [UIColor clearColor];
    self.payView = payView;
    [self.scrollView addSubview:payView];
    
    //支付方式
    UILabel * payModeLabel = [UILabel addLabelWithFrame:CGRectMake(0,  0, CGRectGetWidth(orderPriceView.frame), 35) text:@"   选择支付方式" size:10 textAlignment:NSTextAlignmentLeft];
    payModeLabel.backgroundColor = [UIColor whiteColor];
    [payView addSubview:payModeLabel];
    
   

    if ([WXApi isWXAppInstalled]) {//安装微信
//        self.lastBtn = weixinButton;
        //weixin
        CGRect weixinRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), 50);
        //zhifubao
        CGRect zhufubaoRect = CGRectMake(0, CGRectGetMaxY(weixinRect), CGRectGetWidth(self.scrollView.frame), 50);
        
        //weixin
        UIButton * weixinButton =
        [self addImageAndLabe:payView Frame:weixinRect ImageName:@"order_pay_weixin" TitleText1:@"微信支付" TitleText2:@"亿万用户的选择，更快更安全" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:1];
        self.lastBtn = weixinButton;
        
        //zhifubao
        UIButton * zhifubaoButton =
        [self addImageAndLabe:payView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
        

        
    }
    else {//未安装微信
        //weixin
        CGRect zhufubaoRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), 50);
        
        //zhifubao
        UIButton * zhifubaoButton =
        [self addImageAndLabe:payView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
        self.lastBtn = zhifubaoButton;
        zhifubaoButton.selected = YES;

    }
//    //weixin
//    CGRect weixinRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), heightWeixin);
//    //zhifubao
//    CGRect zhufubaoRect = CGRectMake(0, CGRectGetMaxY(weixinRect), CGRectGetWidth(self.scrollView.frame), 50);
//    
//    //weixin
//    UIButton * weixinButton =
//    [self addImageAndLabe:payView Frame:weixinRect ImageName:@"order_pay_weixin" TitleText1:@"微信支付" TitleText2:@"亿万用户的选择，更快更安全" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:1];
//     self.lastBtn = weixinButton;
//    
//    //zhifubao
//    UIButton * zhifubaoButton =
//    [self addImageAndLabe:payView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
//    
   
    
//    [UIImage imageNamed:@"details_rate_on"]
    
    
    //订单支付
    payView.height = CGRectGetMaxY([payView.subviews objectAtIndex:payView.subviews.count - 1].frame) + 0;
    /**
     *  会员卡单独支付
     */
    if (self.moneyStr >= self.detailsModel.sprice) {
        payView.height = 0;
        payView.hidden  =YES;
        self.lastBtn.tag = 3;
        self.memberLabel.text = [NSString stringWithFormat:@"-%.2f元",self.detailsModel.sprice];
        self.payLabel.text = [NSString stringWithFormat:@"0.00元"];
    }else{
        [self addCalculatedPriceIsmeConpon:@"001"];
    }
    
    //修改滑动范围
    [self setScrollContentSize];

    //立即支付
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即支付" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(payBtnChile)];
    maternityMatronsummitBtn.acceptEventInterval = 5;
    [self.view addSubview:maternityMatronsummitBtn];
    
}
/**
 *  修改 self.scrollContentSize 滑动范围
 */
#pragma mark - 修改 self.scrollContentSize 滑动范围
- (void)setScrollContentSize{
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ self.scrollView.subviews objectAtIndex:self.scrollView.subviews.count - 1].frame) + 64 + 33);
}
/**
 *  会员卡 优惠券 触发方法  会员卡 tag 1000  优惠券 1001
 *
 *  @param btn 按钮
 */
#pragma mark - 会员卡 优惠券 触发方法
-(void)buttonChlie:(UIButton *)btn{
    if (btn.tag == 1000) {
        VDLog(@"会员卡");
    }else if (btn.tag == 1001) {
        VDLog(@"优惠券");
        MeConponViewController * meConponVC = [[MeConponViewController alloc]init];
        meConponVC.orderID = self.detailsModel.orderId;
        
        __weak typeof(self) weakSelf = self;
        [meConponVC returnText:^(ConponMode *conponMode) {
            weakSelf.conponMode = conponMode;
            weakSelf.discountPayLabel.text =[NSString stringWithFormat:@"-%.2f 元",[conponMode.money floatValue]];
            [weakSelf.discountBtn setTitle:[NSString stringWithFormat:@"余额：%.2f 元",[conponMode.money floatValue]] forState:UIControlStateNormal];
            //防止再次设置富文本无效
            [weakSelf.discountBtn setAttributedTitle:nil forState:UIControlStateNormal];
            [UIButton setRichButtonText:weakSelf.discountBtn startStr:@"：" endStr:@"元" font:weakSelf.discountBtn.titleLabel.font color:QiCaiNavBackGroundColor];
            [weakSelf addCalculatedPriceIsmeConpon:@"002"];

        }];
        [self.navigationController pushViewController:meConponVC animated:YES];

    }
}
#pragma mark - 计算价格
- (void)addCalculatedPriceIsmeConpon:(NSString *)isMeConpon{
    CGFloat  temp = [self.conponMode.money  floatValue] + self.moneyStr;// 优惠券 + 会员卡
    CGFloat  temp2f = [[NSString stringWithFormat:@"%.2f",temp] floatValue];
    CGFloat details2f = [[NSString stringWithFormat:@"%.2f",self.detailsModel.sprice] floatValue];
    if (temp2f >= details2f ) {//优惠券 + 会员卡  大于 订单金额
        self.payView.height = 0;
        self.payView.hidden  =YES;
        self.lastBtn.tag = 3;
        
        if (self.conponMode.money) {
            self.discountPayLabel.text =[NSString stringWithFormat:@"-%@元",self.conponMode.money];
            if ([self.conponMode.money floatValue] > self.detailsModel.sprice) {//服务器出问题 优惠券金额 大于 订单价格
                self.memberLabel.text = [NSString stringWithFormat:@"-0.00元"];
                self.discountPayLabel.text = [NSString stringWithFormat:@"-%.2f元",[self.conponMode.money floatValue]];
                VDLog(@"服务器出问题 优惠券金额 大于 订单价格");
            }else{
                self.memberLabel.text = [NSString stringWithFormat:@"-%.2f元",self.detailsModel.sprice - [self.conponMode.money floatValue] ];
            }
            
        }else{
            self.memberLabel.text = [NSString stringWithFormat:@"-%.2f元",self.detailsModel.sprice];
        }
        
        self.payLabel.text = [NSString stringWithFormat:@"0.00元"];
        
    }else{//优惠券 + 会员卡  小于 订单金额 ------ 需要使用第三方支付
        //判断会员卡是否为 0
        if (self.moneyStr == 0) {
            self.payModel.iscard = @"0";//是否使用会员卡 没有传0
        }else{
            self.payModel.iscard = @"1";
        }
        
        //优惠券显示
        self.discountPayLabel.text = [NSString stringWithFormat:@"-%.2f元",[self.conponMode.money floatValue]];
        
        //会员卡显示
        CGFloat member = self.detailsModel.sprice - [self.conponMode.money floatValue];
        VDLog(@"%.2f",member);
        self.memberLabel.text = [NSString stringWithFormat:@"-%.2f",self.moneyStr];
        
        //还需支付显示
        CGFloat pay = member - self.moneyStr ;
        self.payLabel.text = [NSString stringWithFormat:@"%.2f",pay];
        
        
        //第三方支付显示
        self.payView.height = CGRectGetMaxY([self.payView.subviews objectAtIndex:self.payView.subviews.count - 1].frame) + 0;
        self.payView.hidden  = NO;
        //需要判断用户微信是否安装
//        **
        //赋值
        //默认有微信为 1 否则为2
        if ([isMeConpon isEqualToString:@"001"]) {//不是优惠券
            if ([WXApi isWXAppInstalled]) {//安装微信
                
                self.lastBtn.tag = 1;
            }
            else {//未安装微信
                self.lastBtn.tag = 2;
                
            }
        }
        

        
        // 支付宝或者微信的金额
        self.payModel.amount = self.payLabel.text;
        
//        params[@"iscard"] = self.payModel.iscard ? self.payModel.iscard : @"0";//是否使用会员卡 没有传0
//        params[@"coupon"] = self.payModel.coupon ? self.payModel.coupon : @"0";//优惠券ID 没有传0
        
    }

    //判断是否选择优惠券
    if (self.conponMode.money) {
        //优惠券id
        self.payModel.couponLogId = self.conponMode.couponLogId;
        self.payModel.coupon = self.conponMode.couponLogId;//优惠券ID 没有传0
    }else{
        self.payModel.coupon = @"0";//优惠券ID 没有传0
    }

    
    //修改滑动范围
    [self setScrollContentSize];   

}
/**
 *  剩余时间view
 *
 *  @return view
 */
- (UIView *)timeView{
    //剩余时间
    UIView * timeView = [[UIView alloc]init];
    timeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 25);
    timeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeView];
    
    UILabel * label = [UILabel addLabelWithFrame:CGRectMake(0, 0,CGRectGetWidth(timeView.frame) /2 ,  CGRectGetHeight(timeView.frame)) text:@"剩余支付时间" size:12 textAlignment:NSTextAlignmentRight];
    [timeView addSubview:label];
    
    UILabel * timeLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, 0,CGRectGetWidth(timeView.frame) /2 - 20 ,  CGRectGetHeight(timeView.frame)) text:[NSString stringWithFormat:@"%ld分00秒",(long)self.second] size:12 textAlignment:NSTextAlignmentLeft];
    [timeLabel setTextColor:QiCaiNavBackGroundColor];
    _timeLabel = timeLabel;
    [timeView addSubview:timeLabel];
    
    NSTimer * time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    self.timer = time;
    return timeView;
}
#pragma mark - 倒计时方法
/**
 *  倒计时方法
 */
- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
        }
    }
    _timeLabel.text = [NSString stringWithFormat:@"%ld分%ld秒",(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 ) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  //前四个信息 联系人 电话 时间 地址 布局
 *
 *  @param viewY
 *  @param imageArr  图片
 *  @param titleArr  前文字
 *  @param conterArr 后内容文字
 */
- (void)informationToY:(CGFloat)viewY imageArr:(NSArray *)imageArr titleArr:(NSArray *)titleArr conterArr:(NSArray *)conterArr{

    for (NSInteger i = 0; i < imageArr.count; i++) {
        
        UIView * bacView = [[ UIView alloc]init];
        bacView.frame = CGRectMake(0,0, CGRectGetWidth(self.scrollView.frame), 42);
        bacView.backgroundColor = [UIColor whiteColor];
        bacView.y = viewY +  i * 42;
        
        [self.scrollView addSubview:bacView];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        imageView.frame = CGRectMake(10, 0, CGRectGetHeight(bacView.frame) * 0.4, CGRectGetHeight(bacView.frame) * 0.4);
        imageView.centerY = CGRectGetHeight(bacView.frame) / 2;
        [bacView addSubview:imageView];
        
        
        UILabel * label = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, CGRectGetWidth(bacView.frame) * 0.4, CGRectGetHeight(bacView.frame)) text:titleArr[i] size:12 textAlignment:NSTextAlignmentLeft];
        [bacView addSubview:label];
        
        UILabel *label2 = [UILabel addLabelWithFrame:CGRectMake(CGRectGetWidth(bacView.frame) * 0.5, 0, CGRectGetWidth(bacView.frame) * 0.5 - 15, CGRectGetHeight(bacView.frame)) text:conterArr[i] size:11 textAlignment:NSTextAlignmentRight];
        [bacView addSubview:label2];
        
        UIView * line = [[UIView alloc]init];
        line.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetHeight(bacView.frame) - 1, CGRectGetMaxX(label2.frame) - CGRectGetMinX(label.frame), 1);
        line.backgroundColor = QiCaiBackGroundColor;
        [bacView addSubview:line];
        
    }

}
/**
 *  会员卡 和 优惠券布局
 *
 *  @param viewY
 *  @param imageName  图片
 *  @param label1Text 主标题
 *  @param label2Text 副标题
 *  @param buttonText 按钮文字
 *
 *  @return 返回 按钮
 */
- (UIButton *)addMembershipAndDiscountToY:(CGFloat)viewY imageName:(NSString *)imageName label1Text:(NSString *)label1Text label2:(UILabel *)label2 buttonText:(NSString *)buttonText {
    UIView * bacView = [[ UIView alloc]init];
    bacView.frame = CGRectMake(0,0, CGRectGetWidth(self.scrollView.frame), 53);
    bacView.backgroundColor = [UIColor whiteColor];
    bacView.y = viewY;//CGRectGetMaxY(timeView.frame) + 5 + imageArr.count * 40;
    
    [self.scrollView addSubview:bacView];
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.frame = CGRectMake(10, 0, 40 * 0.4, 40 * 0.4);
    
    [bacView addSubview:imageView];
    
    
    UILabel * label = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, CGRectGetWidth(bacView.frame) * 0.4, CGRectGetHeight(bacView.frame) / 3) text:label1Text size:12 textAlignment:NSTextAlignmentLeft];
    label.centerY = CGRectGetHeight(bacView.frame) * 0.35;
    imageView.centerY = label.centerY;
    //    label.backgroundColor = [UIColor yellowColor];
    [bacView addSubview:label];
    if ([label1Text isEqualToString:@"会员卡"]) {
        label2 = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(label.frame), CGRectGetWidth(bacView.frame) * 0.4, CGRectGetHeight(bacView.frame) / 4) text:label2.text size:10 textAlignment:NSTextAlignmentLeft];
        label2.textColor = QiCaiBZTitleColor;
        [bacView addSubview:label2];

    }else{
        self.discountLabel2 = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(label.frame), CGRectGetWidth(bacView.frame) * 0.4, CGRectGetHeight(bacView.frame) / 4) text:label2.text size:10 textAlignment:NSTextAlignmentLeft];
        self.discountLabel2 .textColor = QiCaiBZTitleColor;
        [bacView addSubview:self.discountLabel2 ];

    }
        //    label2.backgroundColor = [UIColor redColor];
    
    //图片
    UIButton *imageBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetWidth(bacView.frame) - 40, 0, 25, 30) image:@"main_icon_arrow" highImage:@"main_icon_arrow" backgroundColor:nil Target:nil action:nil];
    imageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    imageBtn.centerY = CGRectGetHeight(bacView.frame) / 2;
    [bacView addSubview:imageBtn];
    
    UIButton * button = [UIButton addButtonWithFrame:CGRectMake(CGRectGetWidth(bacView.frame) * 0.5, 0, CGRectGetWidth(bacView.frame) * 0.5 - CGRectGetWidth(imageBtn.frame)  - 10, CGRectGetHeight(bacView.frame)) title:buttonText backgroundColor:nil titleColor:QiCaiShallowColor font:QiCaiDetailTitle12Font Target:self action:@selector(buttonChlie:)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [bacView addSubview:button];
    
    if ([label1Text isEqualToString:@"会员卡"]) {
        button.tag = 1000;
        [button setAttributedTitle:nil forState:UIControlStateNormal];
        [UIButton setRichButtonText:button startStr:@"：" endStr:@"元" font:button.titleLabel.font color:QiCaiNavBackGroundColor];

    }else{
        button.tag = 1001;
    }
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetHeight(bacView.frame) - 1, CGRectGetMaxX(button.frame) - CGRectGetMinX(label.frame), 1);
    line.backgroundColor = QiCaiBackGroundColor;
    [bacView addSubview:line];
    
    return button;
}
/**
 *  订单总价 横向布局
 *
 *  @param orderPriceView 添加的view
 *  @param frame          位置
 *  @param labelText1     前文字
 *  @param labelText2     后文字
 *  @param labelColor1    前文字颜色
 *  @param labelColor2    后文字颜色
 *  @param labelFont      文字字体
 *
 *  @return 后文字 label
 */
- (UILabel *)addOrderPriceToView:(UIView *)orderPriceView frame:(CGRect)frame labelText1:(NSString *)labelText1 labelText2:(NSString *)labelText2 labelColor1:(UIColor *)labelColor1 labelColor2:(UIColor *)labelColor2 labelFont:(UIFont *)labelFont {
    
    UILabel * titlabel =[ UILabel addLabelWithFrame:frame text:labelText1 size:12 textAlignment:NSTextAlignmentLeft];
    [orderPriceView addSubview:titlabel];
//    imageView.centerY = titlabel.centerY;
    
    UILabel *conLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetWidth(orderPriceView.frame) * 0.5 , CGRectGetMinY(frame), CGRectGetWidth(orderPriceView.frame) * 0.5 - 20, CGRectGetHeight(titlabel.frame)) text:labelText2 size:12 textAlignment:NSTextAlignmentRight];
    [orderPriceView addSubview:conLabel];
    
    
    titlabel.font = labelFont;
    titlabel.textColor = labelColor1;
    conLabel.font = labelFont;
    conLabel.textColor = labelColor2;

    return conLabel;
}
/**
 *  接口判断是否有可用优惠券
 */
- (void)addAfn{
//    couponLogAction.do?method=usableCoupon
    NSString * URLStr=  [NSString stringWithFormat:@"%@/couponLogAction.do?method=usableCoupon",kQICAIHttp];
    NSLog(@"%@",URLStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"] = userId;
    params[@"orderId"] = self.detailsModel.orderId;
    params[@"pageNumber"] = @"1";
 
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @1]) {
            VDLog(@"没优惠券");
            [self.discountLabel2 setText:[NSString stringWithFormat:@"无可用优惠券"]];
        }else if ([responseObject[@"message"]  isEqual: @0])
        {
            VDLog(@"成功==%@",responseObject);
            NSArray *cellArr = [ConponMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.conponArr addObjectsFromArray:cellArr];
            //            self.discountLabel2.text = [NSString stringWithFormat:@"共有有%lu张优惠券可以使用",(unsigned long)self.conponArr.count];
            VDLog(@"%@",cellArr);
            if (cellArr.count > 0) {
                [self.discountLabel2 setText:[NSString stringWithFormat:@"有可用优惠券"]];
                [self.discountLabel2 setTextColor:QiCaiNavBackGroundColor];
                self.discountBtn.enabled = YES ;
            }else{
                self.discountBtn.enabled = NO;
            }
            
            //            MeConponViewController * meConponVC = [[MeConponViewController alloc]init];
            //            meConponVC.orderID = self.detailsModel.orderId;
            //            [self.navigationController pushViewController:meConponVC animated:YES];
            
        }

    } failure:nil];
}
///**
// *  支付宝URl回调
// */
//- (BOOL)addAlipayOpenURL:(NSURL *)url{
//    /**
//     9000 订单支付成功 8000 正在处理中 4000 订单支付失败 6001 用户中途取消 6002 网络连接出错
//     */
//    //*支付宝
//    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            NSLog(@"返回数值%@",resultDic[@"resultStatus"]);
//            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                //                        [HUDprompt showSuccessWithTitle:@"支付成功"];
//                
//            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
//                //                        [HUDprompt showErrorWithTitle:@"网络连接出错"];
//            }
//        }];
//        
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//    }
//    return YES;
//}
@end
