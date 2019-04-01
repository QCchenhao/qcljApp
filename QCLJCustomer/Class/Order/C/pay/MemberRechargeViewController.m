 //
//  MemberRechargeViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/9.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MemberRechargeViewController.h"
//#import "Comment.h"

@interface MemberRechargeViewController()<UIScrollViewDelegate>
@property (weak, nonatomic)UIView * giveView;
@property (weak, nonatomic)UIView * footView;
@end
@implementation MemberRechargeViewController

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
    
    [self setupUI];
    
    //监听事件 微信
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserWeiXinChangeSuccess" object:nil];
    
    //监听事件 支付宝
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserAlipayChangeSuccess" object:nil];
    
    
    //    [self requestMeCount];
}

//4. 观察者注销，移除消息观察者
-(void)dealloc
{
    [MYNotificationCenter removeObserver:@"UserWeiXinChangeSuccess"];
    [MYNotificationCenter removeObserver:@"UserAlipayChangeSuccess"];
}
- (void)getUserInfoData{
    
    //    [self.tableView.mj_header beginRefreshing];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setupUI
{
    // 设置导航栏标题
    self.navigationItem.title = @"会员充值";
    
    [self.view addSubview:self.scrollView];
    [self.scrollView setBackgroundColor:QiCaiBackGroundColor];
    
    //上面的view
    CGFloat Hheight = 40;
    UIView *topBJView = [[UIView alloc]initWithFrame:CGRectMake(0, QiCaiMargin, MYScreenW, Hheight * 4)];
    topBJView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topBJView];
    
    //充值账户
    UILabel *rechargeAccountLabel = [[UILabel alloc]init];
    rechargeAccountLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"member_rechargeAccount"] interval:3 frame:CGRectMake(10, 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"充值账户" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [topBJView addSubview:rechargeAccountLabel];
    
    UILabel *rechargeAccountDetailLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(CGRectGetMaxX(rechargeAccountLabel.frame), 10, MYScreenW - CGRectGetMaxX(rechargeAccountLabel.frame) - 10, 20) text:[NSString stringWithFormat:@"%@",[MYUserDefaults objectForKey:@"mob"]] textColor:QiCaiNavBackGroundColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentRight];
    [topBJView addSubview:rechargeAccountDetailLabel];
    
    //line
    UIView *accountLine = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(rechargeAccountLabel.frame) + 10, MYScreenW - 45, 1)];
    accountLine.backgroundColor = QiCaiBackGroundColor;
    [topBJView addSubview:accountLine];
    
    //金额
    UILabel *maneyAccountLabel = [[UILabel alloc]init];
    maneyAccountLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"member_maneyAccount"] interval:3 frame:CGRectMake(10,CGRectGetMaxY(accountLine.frame) + 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"充值金额" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [topBJView addSubview:maneyAccountLabel];
    
    UILabel *maneyAccountDetailLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(maneyAccountLabel.frame), CGRectGetMaxY(accountLine.frame) + 10, MYScreenW - CGRectGetMaxX(maneyAccountLabel.frame) - 10, 20) text:[NSString stringWithFormat:@"%.2f元", [self.mebershipCardMode.givemoney floatValue]  + [self.mebershipCardMode.money floatValue]] size:12 textAlignment:NSTextAlignmentRight];
    maneyAccountDetailLabel.textColor = QiCaiDeepColor;
    [topBJView addSubview:maneyAccountDetailLabel];
    
    //line
    UIView *balanceLine = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(maneyAccountDetailLabel.frame) + 10, MYScreenW - 45, 1)];
    balanceLine.backgroundColor = QiCaiBackGroundColor;
    [topBJView addSubview:balanceLine];
    
    //应付金额
    UILabel *amountPayableLabel = [[UILabel alloc]init];
    amountPayableLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"member_amountPayable"] interval:3 frame:CGRectMake(10,CGRectGetMaxY(balanceLine.frame) + 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"应付金额" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [topBJView addSubview:amountPayableLabel];
   
    UILabel *amountPayableDetailLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(CGRectGetMaxX(amountPayableLabel.frame), CGRectGetMaxY(balanceLine.frame) + 10, MYScreenW - CGRectGetMaxX(amountPayableLabel.frame) - 10, 20) text:[NSString stringWithFormat:@"%.2f元",[self.mebershipCardMode.money floatValue]] textColor:QiCaiDeepColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentRight];
    [topBJView addSubview:amountPayableDetailLabel];
    
    //line
    UIView *amountPayableLine = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(amountPayableLabel.frame) + 10, MYScreenW - 45, 1)];
    amountPayableLine.backgroundColor = QiCaiBackGroundColor;
    [topBJView addSubview:amountPayableLine];
    
    
    
//    /**
//     前期不用
//     */
//    //赠送项目
//    UILabel *giftItemsLabel = [[UILabel alloc]init];
//    giftItemsLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"member_giftItems"] interval:3 frame:CGRectMake(10,CGRectGetMaxY(amountPayableLine.frame) + 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"赠送项目" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
//    [topBJView addSubview:giftItemsLabel];
//
//    UIButton *giftItemsBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(giftItemsLabel.frame), CGRectGetMaxY(amountPayableLine.frame) + 10, MYScreenW * 0.5 - 20, 20) image:@"details_upper_off" highImage:@"details_upper_on" backgroundColor:[UIColor clearColor] Target:self action:@selector(clickGiftItemsaBtn:)];
//    giftItemsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [topBJView addSubview:giftItemsBtn];
//    
//    UIView * giveView = [[UIView alloc]init];
//    giveView.frame = CGRectMake(0, CGRectGetMaxY(topBJView.frame), CGRectGetWidth(topBJView.frame), 43);
//    self.giveView = giveView;
//    giveView.backgroundColor = [UIColor yellowColor];
//    [self.scrollView addSubview:giveView];
//
//    NSArray * imageArr = @[@"member_gift_min",@"member_gift_min",@"member_gift_min",@"member_gift_min"];
//    NSArray * titleArr = @[@"优惠券有效期3个月",@"优惠券有效期3个月",@"优惠券有效期3个月",@"优惠券有效期3个月"];
//    [self addLabelAndImageView:giveView titleArrty:titleArr imageArrty:imageArr startY:0 col:2 startX:20 margin:20];
//    
//    //line
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(amountPayableLine.frame) + 40, MYScreenW - 45, 0)];
//    line.backgroundColor = QiCaiBackGroundColor;
//    [topBJView addSubview:line];
    
    
    /**
     *  上面的topBJView  View高度 若解注释上面的代码 注释现在这行的代码
     */
    topBJView.height = CGRectGetMaxY([topBJView.subviews objectAtIndex:topBJView.subviews.count - 1].frame);

    
    //下面的View
    UIView * footView= [[UIView alloc]init];
    footView.frame = CGRectMake(0, CGRectGetMaxY([ self.scrollView.subviews objectAtIndex:self.scrollView.subviews.count - 1].frame) + 5, CGRectGetWidth(self.scrollView.frame), MYScreenH - CGRectGetHeight(topBJView.frame) - 100);
    self.footView = footView;
    footView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:footView];
    
    //支付方式
    UILabel * payModeLabel = [UILabel addLabelWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35) text:@"   选择支付方式" size:10 textAlignment:NSTextAlignmentLeft];
    payModeLabel.backgroundColor = [UIColor whiteColor];
    [footView addSubview:payModeLabel];
    
    CGRect zhufubaoRect;
    if ([WXApi isWXAppInstalled]) {//安装微信
        //        self.lastBtn = weixinButton;
        //weixin
        CGRect weixinRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), 50);
        //zhifubao
        zhufubaoRect = CGRectMake(0, CGRectGetMaxY(weixinRect), CGRectGetWidth(self.scrollView.frame), 50);
        
        //weixin
        UIButton * weixinButton =
        [self addImageAndLabe:footView Frame:weixinRect ImageName:@"order_pay_weixin" TitleText1:@"微信支付" TitleText2:@"亿万用户的选择，更快更安全" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:1];
        self.lastBtn = weixinButton;
        
        //zhifubao
        UIButton * zhifubaoButton =
        [self addImageAndLabe:footView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
        
        
        
    }
    else {//未安装微信

        zhufubaoRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), 50);
        
        //zhifubao
        UIButton * zhifubaoButton =
        [self addImageAndLabe:footView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
        self.lastBtn = zhifubaoButton;
        zhifubaoButton.selected = YES;
        
    }

//    //weixin
//    CGRect weixinRect = CGRectMake(0, CGRectGetMaxY(payModeLabel.frame) + 1, CGRectGetWidth(self.scrollView.frame), 50);
//    UIButton * weixinButton =
//    [self addImageAndLabe:footView Frame:weixinRect ImageName:@"order_pay_weixin" TitleText1:@"微信支付" TitleText2:@"亿万用户的选择，更快更安全" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:1];
//    self.lastBtn = weixinButton;
//    
//    //zhifubao
//    CGRect zhufubaoRect = CGRectMake(0, CGRectGetMaxY(weixinRect), CGRectGetWidth(self.scrollView.frame), 50);
////        UIButton * zhifubaoButton =
//    [self addImageAndLabe:footView Frame:zhufubaoRect ImageName:@"order_pay_alipay" TitleText1:@"支付宝支付" TitleText2:@"推荐支付宝用户使用" ButtonImageName:@"order_cancel_off" ButtonImageHigeName:@"order_cancel_on" Target:self action:@selector(btnChile:) lastBtn:self.lastBtn ButtonTag:2];
    
   //充值协议
    UIView * viewAgreement= [[UIView alloc]init];
    viewAgreement.frame = CGRectMake(0, CGRectGetMaxY(zhufubaoRect), MYScreenW , 30);
    viewAgreement.backgroundColor = [UIColor whiteColor];
    [footView addSubview:viewAgreement];
    UIButton * buttonAgreement = [UIButton addButtonWithFrame:CGRectMake(30, 0, MYScreenW * 0.7, 30) title:@"点击立即充值即表示同意《充值协议》" backgroundColor:[UIColor whiteColor] titleColor:QiCaiShallowColor font:QiCaiDetailTitle12Font Target:self action:@selector(buttonAgreementChlie)];
    buttonAgreement.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [UIButton setRichButtonText:buttonAgreement startStr:@"《" endStr:@"》" font: buttonAgreement.titleLabel.font color:QiCaiNavBackGroundColor];
    [viewAgreement addSubview:buttonAgreement];
    
        /**
     *  self.scrollView  的高度
     */
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ self.scrollView.subviews objectAtIndex:self.scrollView.subviews.count - 1].frame) + 0);
    
    VDLog(@"%@",self.payModel.amount);
    //立即支付
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即充值" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(payBtnChile)];
    maternityMatronsummitBtn.acceptEventInterval = 5;
    [self.view addSubview:maternityMatronsummitBtn];
    
}
- (void)buttonAgreementChlie{
    VDLog(@"协议");
    
    QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
    homeMaternityMatronVC.qcthmlType = QCHTMLTypeRechargeProtocol;
    [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
    
}
-(void)clickGiftItemsaBtn:(UIButton *)btn
{
    btn.tag = !btn.tag;
    if (btn.tag == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.giveView.height = 52;
            self.giveView.hidden = NO;
            self.footView.y = CGRectGetMaxY(self.giveView.frame) + 5;
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.giveView.hidden = YES;
            self.giveView.height = 0;
            self.footView.y = CGRectGetMaxY(self.giveView.frame) + 5;
        }completion:^(BOOL finished) {
            
        }];
        
        
    }
    btn.selected = btn.tag;
}
- (UIView * )addLabelAndImageView:(UIView *)bacView titleArrty:(NSArray *)titleArrty imageArrty:(NSArray *)imageArrty startY:(CGFloat)startY col:(NSInteger)col startX:(CGFloat)startX margin:(CGFloat)margin{
    
    
    //    CGFloat startX = 34;//整个九宫格的位置
    //    CGFloat  margin = 34;
    CGFloat width = (MYScreenW -2 * startX - (col - 1) * margin ) / col;
    CGFloat height = 17;
    CGFloat CWstartY = startY ;//45;
    for (int i = 0; i < titleArrty.count; i++) {
        UIView *meView = [[UIView alloc]init];
        meView.backgroundColor = [UIColor whiteColor];
        meView.width = width;
        meView.height = height;
        NSInteger row = i / col;//行号
        NSInteger CWcol = i % col;//列号
        meView.x = startX + (width +  margin) * CWcol;
        meView.y = CWstartY + (height + 2) * row;
        
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, CGRectGetHeight(meView.frame) * 0.7, CGRectGetHeight(meView.frame) * 0.7);
        [meView addSubview:imageView];
        imageView.centerY = CGRectGetHeight(meView.frame) / 2;
        imageView.image = [UIImage imageNamed:imageArrty[i]];
        
        UILabel * label = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, CGRectGetWidth(meView.frame) - CGRectGetWidth(imageView.frame) - 10, CGRectGetHeight(meView.frame) * 0.8) text:titleArrty[i] size:9 textAlignment:NSTextAlignmentLeft];
        label.textColor = QiCaiBZTitleColor;
        [meView addSubview:label];
        label.centerY = imageView.centerY;
        meView.tag = i + 1000;
        
        [bacView addSubview:meView];
    }
    //    UIButton * leftMsgBg = (UIButton *)[bacView viewWithTag:1000];
    
    
    return bacView;
}
#pragma mark - 微信登录授权后回调
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]){
        //        PayResp*response = (PayResp*)resp;
        __weak typeof(self) weakSelf = self;
        switch(resp.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                VDLog(@"微信支付成功");
                [CHMBProgressHUD showSuccess:@"微信支付成功"];
                
                if (weakSelf.returnOrderBlock != nil) {
                    weakSelf.returnOrderBlock();
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
                //    QiCaiTabBarController *tableViewVC = [[QiCaiTabBarController alloc]init];
                //    //    tableViewVC.selectedIndex = 1;
                //    [self.navigationController pushViewController:tableViewVC animated:YES];
                break;
            case WXErrCodeUserCancel:
            {
                //                [SVProgressHUD showErrorWithStatus:@"您已经取消支付"];
                NSLog(@"微信用户取消支付: %d",resp.errCode);

                [CHMBProgressHUD showFail:@"已取消微信支付"];
                break;
            }
            default:
                [CHMBProgressHUD showFail:@"微信支付失败"];
                NSLog(@"微信支付失败，retcode=%d",resp.errCode);
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
    
}

@end
