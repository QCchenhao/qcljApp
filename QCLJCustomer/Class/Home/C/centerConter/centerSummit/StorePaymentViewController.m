//
//  StorePaymentViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/8.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "StorePaymentViewController.h"
#import "StorePayViewController.h"//跳转支付页面  支付页面统一在订单pay文件夹📂里
#import "OrderPayViewController.h"//订单支付

//#pragma mark - StorePaymentMode-模型类
//@implementation StorePaymentMode
//
//@end

@interface StorePaymentViewController ()

/**
//收款经纪人
 */
@property (nonatomic,strong) CHTextField * storepPayment_agentName_TextField;
/**
//佣金
 */
@property (nonatomic,strong) CHTextField * storepPayment_commission_TextField;
/**
//代收工资
 */
@property (nonatomic,strong) CHTextField * storepPayment_wages_TextField;
/**
//保险
 */
@property (nonatomic,strong) CHTextField * storepPayment_insurance_TextField;
/**
//总金额
 */
@property (nonatomic,strong) UILabel * storepPayment_amount_label;
/**
 //总金额参数
 */
@property (nonatomic,copy) NSString * amountStr;

//@property (nonatomic,strong)StorePaymentMode *mode;
@end
@implementation StorePaymentViewController
- (void)returnHomeBlock:(ReturnHomeBlock)block
{
    self.returnHomeBlock = block;
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
    
    //键盘处理
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    
    [self setUpUI];
    
}
-(void)setUpUI
{
    [CHMBProgressHUD shareinstance].popDelegate = self;
    
    // 设置导航栏标题
    self.navigationItem.title = @"门店缴费";
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"main_fenxiang" action:@selector(clickShareBtn) target:self];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:QiCaiBackGroundColor];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //上面的view
    CGFloat Hheight = 40;
    UIView *topBJView = [[UIView alloc]initWithFrame:CGRectMake(0, QiCaiMargin, MYScreenW, Hheight * 4 + 13)];
    topBJView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:topBJView];
    
    //付款信息
    UILabel *maneyLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(QiCaiMargin * 2, 0,MYScreenW - QiCaiMargin * 2, 36) text:@"付款信息" textColor:QiCaiDeepColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentLeft];
    [topBJView addSubview:maneyLabel];
    [UIView addHLineWithlineX:0 lineY:CGRectGetMaxY(maneyLabel.frame) contentView:topBJView];

    
    //雇主姓名
    self.nameChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_lianxiren" frame:CGRectMake(0, CGRectGetMaxY(maneyLabel.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"请输入联系人" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    self.nameChTextFile.cHTextFieldType = CHTextFieldTypeName;
    self.nameChTextFile.CHDelegate = self;
    [topBJView addSubview:self.nameChTextFile];
    self.nameChTextFile.placeholder = @"请输入雇主姓名";
    self.nameChTextFile.textColor = QiCaiShallowColor;
    self.nameChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.nameChTextFile.layer.borderWidth = 0;
    self.nameChTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(self.nameChTextFile.frame) lineX:36 contentView:topBJView];
    
    NSString * nameStr = [MYUserDefaults objectForKey:@"name"];
    if (nameStr && ![nameStr isEqualToString:@"default"] && ![nameStr isEqualToString:@""] ) {
        self.nameChTextFile.text = nameStr;
        self.nameChTextFile.userInteractionEnabled = NO;//禁止编辑
    }else{
        self.nameChTextFile.userInteractionEnabled = YES;//禁止编辑
    }
    self.nameChTextFile.font = [UIFont systemFontOfSize:12];
    

    

    
    //雇主手机号
    self.telephoneChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_shoujihao" frame:CGRectMake(0, CGRectGetMaxY(self.nameChTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"请输入雇主手机号" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    self.telephoneChTextFile.CHDelegate = self;
    self.telephoneChTextFile.cHTextFieldType = CHTextFieldTypeTelephone;
    [topBJView addSubview:self.telephoneChTextFile];
    self.telephoneChTextFile.placeholder = @"请输入雇主手机号";
    self.telephoneChTextFile.layer.borderWidth = 0;
    self.telephoneChTextFile.textColor = QiCaiShallowColor;
    self.telephoneChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.telephoneChTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(self.telephoneChTextFile.frame) lineX:36 contentView:topBJView];
    
    if ([MYUserDefaults objectForKey:@"mob"]) {
        self.telephoneChTextFile.text = [MYUserDefaults objectForKey:@"mob"];
        self.telephoneChTextFile.userInteractionEnabled = NO;//禁止编辑
    }
    self.telephoneChTextFile.font = [UIFont systemFontOfSize:12];
    

    
    //收款经纪人
//    [UIImage imageNamed:@"home_agent"]
    CHTextField *agentTextFile = [CHTextField addCHTextFileWithLeftImage:@"home_agent" frame:CGRectMake(0, CGRectGetMaxY(self.telephoneChTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    agentTextFile.cHTextFieldType = CHTextFieldTypeUnlimitedCH;
    agentTextFile.CHDelegate = self;
    [topBJView addSubview:agentTextFile];
    agentTextFile.placeholder = @"请输入所属门店";
    agentTextFile.textColor = QiCaiShallowColor;
    agentTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    agentTextFile.layer.borderWidth = 0;
    agentTextFile.font = [UIFont systemFontOfSize:12];
    agentTextFile.returnKeyType = UIReturnKeyDefault;
    agentTextFile.keyboardType = UIKeyboardTypeNamePhonePad;//没有符号的键盘
    [UIView addHLineWithY:CGRectGetMaxY(agentTextFile.frame) lineX:36 contentView:topBJView];
    self.storepPayment_agentName_TextField = agentTextFile;
    
    
    //下面的view
    UIView *bottomBJView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topBJView.frame) + QiCaiMargin, MYScreenW, Hheight * 4 + 13)];
    bottomBJView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bottomBJView];
    
    //付款明细
    UILabel *maneyDetailLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(QiCaiMargin * 2, 0,MYScreenW - QiCaiMargin * 2, 36) text:@"付款明细" textColor:QiCaiDeepColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentLeft];
    [bottomBJView addSubview:maneyDetailLabel];
    [UIView addHLineWithlineX:0 lineY:CGRectGetMaxY(maneyDetailLabel.frame) contentView:bottomBJView];
    
    
    //服务佣金
    CHTextField *commissionTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_yongjin" frame:CGRectMake(0, CGRectGetMaxY(maneyLabel.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"请输入联系人" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    commissionTextFile.cHTextFieldType = CHTextFieldTypeAmountOfMoney;
    commissionTextFile.CHDelegate = self;
    [bottomBJView addSubview:commissionTextFile];
    commissionTextFile.placeholder = @"请输入服务佣金";
    commissionTextFile.textColor = QiCaiShallowColor;
    commissionTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    commissionTextFile.layer.borderWidth = 0;
    commissionTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(commissionTextFile.frame) lineX:36 contentView:bottomBJView];
    self.storepPayment_commission_TextField = commissionTextFile;
    
    //代收工资
    CHTextField *wageCollectionTextFile = [CHTextField addCHTextFileWithLeftImage:@"home_WageCollection" frame:CGRectMake(0, CGRectGetMaxY(commissionTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    wageCollectionTextFile.CHDelegate = self;
    wageCollectionTextFile.cHTextFieldType = CHTextFieldTypeAmountOfMoney;
    [bottomBJView addSubview:wageCollectionTextFile];
    wageCollectionTextFile.placeholder = @"请输入代收工资";
    wageCollectionTextFile.textColor = QiCaiShallowColor;
    wageCollectionTextFile.layer.borderWidth = 0;
    wageCollectionTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    wageCollectionTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(wageCollectionTextFile.frame) lineX:36 contentView:bottomBJView];
    self.storepPayment_wages_TextField = wageCollectionTextFile;
    
    
    //保险费
    //    [UIImage imageNamed:@"home_agent"]
    CHTextField *insuranceTextFile = [CHTextField addCHTextFileWithLeftImage:@"home_insurance" frame:CGRectMake(0, CGRectGetMaxY(wageCollectionTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    insuranceTextFile.cHTextFieldType = CHTextFieldTypeAmountOfMoney;
    insuranceTextFile.CHDelegate = self;
    [bottomBJView addSubview:insuranceTextFile];
    insuranceTextFile.placeholder = @"请输入保险费";
    insuranceTextFile.textColor = QiCaiShallowColor;
    insuranceTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    insuranceTextFile.layer.borderWidth = 0;
    insuranceTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(insuranceTextFile.frame) lineX:36 contentView:bottomBJView];
    self.storepPayment_insurance_TextField = insuranceTextFile;
    
    //合计
    UILabel *sumLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(QiCaiMargin, CGRectGetMaxY(insuranceTextFile.frame) + 1, MYScreenW - QiCaiMargin * 3, Hheight) text:@"合计：" textColor:QiCaiShallowColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentRight];
    [bottomBJView addSubview:sumLabel];
    [UIView addHLineWithlineX:0 lineY:CGRectGetMaxY(sumLabel.frame) contentView:bottomBJView];
    self.storepPayment_amount_label = sumLabel;
    
    //温馨提示
    UIView * reminderView = [[UIView alloc]init];
    reminderView.frame = CGRectMake(0, CGRectGetMaxY(sumLabel.frame) + 1,  CGRectGetWidth(scrollView.frame), 68.5);
    reminderView.backgroundColor = [UIColor whiteColor];
    [bottomBJView addSubview:reminderView];
    
    UILabel * reminderLabel = [[UILabel alloc]init];
    reminderLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"home_wxts"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(reminderView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"温馨提示" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [reminderView addSubview:reminderLabel];
    
    UILabel * reminderContentLabel = [UILabel addLayerLabelWithFrame:CGRectMake(34, CGRectGetMaxY(reminderLabel.frame) , MYScreenW - 43 , 50) text:@"如遇支付问题，请拨打客服4000-999-001电话！" textColor:QiCaiBZTitleColor size:9 lineSpacing:3];
    [reminderView addSubview:reminderContentLabel];
    
    [reminderContentLabel setLabelSpace:reminderContentLabel withValue:reminderContentLabel.text withFont:reminderContentLabel.font];
    reminderContentLabel.height = 35;
    reminderContentLabel.width = MYScreenW - 43;
    
    bottomBJView.height = CGRectGetMaxY(reminderView.frame);
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ scrollView.subviews objectAtIndex:scrollView.subviews.count - 1].frame) + 64 + 33);
    
    //立即预定
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即支付" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickStorePaymentBtn)];
    [self.view addSubview:maternityMatronsummitBtn];
    maternityMatronsummitBtn.acceptEventInterval = 5;

    
    __weak typeof(self) weakSelf = self;
    [self.storepPayment_commission_TextField setPayMoneyBlock:^(NSString *pay) {
        
        [weakSelf setPay];
        
    }];
    [self.storepPayment_wages_TextField setPayMoneyBlock:^(NSString *pay) {
        
        [weakSelf setPay];
        
    }];
    [self.storepPayment_insurance_TextField setPayMoneyBlock:^(NSString *pay) {
        
        [weakSelf setPay];
        
    }];
    
}
-(void)clickStorePaymentBtn
{
    NSString * URLStr=  [NSString stringWithFormat:@"%@/paymentAction.do?method=savePayment",kQICAIHttp];
    NSLog(@"%@",URLStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    if (userId) {
        params[@"userId"] = userId;//用户主键（未登录不写此参数）
        
    }else{
        params[@"userType"] = @"1";//若没有userid 此项必须要写
    }
    //姓名
    if (self.nameChTextFile.text.length > 0) {
        
        if ( [NSString checkUserName:self.nameChTextFile.text]) {
            params[@"name"] = self.nameChTextFile.text;//雇主姓名
        }else{
            [CHMBProgressHUD showPrompt:@"请输入正确联系人"];
            return;
        }
    }else{
        [CHMBProgressHUD showPrompt:@"请输入联系人"];
        return;
    }
    //电话
    if (self.telephoneChTextFile.text.length > 0) {
        if ( [NSString checkMobile:self.telephoneChTextFile.text]) {
            params[@"mob"] = self.telephoneChTextFile.text;
        }else{
            [CHMBProgressHUD showPrompt:@"请输入正确手机号"];//雇主电话
            return;
        }
    }else{
        [CHMBProgressHUD showPrompt:@"请输入手机号"];
        return;
    }
    //所属门店
    if (self.storepPayment_agentName_TextField.text.length > 0) {
         params[@"agentName"] = self.storepPayment_agentName_TextField.text;//所属门店
        
//        if ( [NSString checkUserName:self.storepPayment_agentName_TextField.text]) {
//            params[@"agentName"] = self.storepPayment_agentName_TextField.text;//雇主姓名
//        }else{
//            [CHMBProgressHUD showPrompt:@"请输入正确所属门店"];
//            return;
//        }
        
    }else{
        [CHMBProgressHUD showPrompt:@"请输入所属门店"];
        return;
    }
    //佣金
    if (self.storepPayment_commission_TextField.text.length > 0) {
        params[@"commission"] = self.storepPayment_commission_TextField.text;//佣金
    }else{
        params[@"commission"] = @"0";//佣金
    }
    //代收工资
    if (self.storepPayment_wages_TextField.text.length > 0) {
        params[@"wages"] = self.storepPayment_wages_TextField.text;//代收工资
    }else{
        params[@"wages"] = @"0";//代收工资
    }
    //保险
    if (self.storepPayment_insurance_TextField.text.length > 2) {
        params[@"insurance"] = self.storepPayment_insurance_TextField.text;//保险
    }else{
        params[@"insurance"] = @"0";//保险
    }
    //总金额
    if (self.storepPayment_amount_label.text.length > 2) {
        if ([self.amountStr floatValue] > 0) {
            params[@"amount"] = self.amountStr;//总金额
        }else{
            [CHMBProgressHUD showPrompt:@"合计总价不能为零"];
            return;
        }
        
    }

    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"]  isEqual: @0])

        {
            NSDictionary * detaDic = @{
                                       @"stid" : @"42",
                                       @"sprice": self.amountStr,
                                       };
            
            OrderPayViewController * payVC= [[OrderPayViewController alloc]init];
            payVC.payModel = [PayModel mj_objectWithKeyValues:params];
            payVC.payModel.stid = responseObject[@"stid"];
            payVC.payModel.payType = paymentOrder;
            payVC.detailsModel= [DetailsModel mj_objectWithKeyValues:detaDic];
            [self.navigationController pushViewController:payVC animated:YES];            
        }else if ([responseObject[@"message"]  isEqual: @1]) {
            VDLog(@"参数错误");
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            VDLog(@"已注册未登录");
            ThirdPartyLoginViewController * thirdPartyVC = [[ThirdPartyLoginViewController alloc]init];
            thirdPartyVC.teleNuber = self.telephoneChTextFile.text;
            [thirdPartyVC returnText:^(UIImage *ueseImage, NSString *nameStr, NSString *mobStr, NSString *adderss) {
                if (nameStr) {
                    self.nameChTextFile.text = nameStr;
                    self.nameChTextFile.userInteractionEnabled = NO;//禁止编辑
                }
                //当未登录状态下可以输入地址
                if ([MYUserDefaults objectForKey:@"userId"]) {
                    self.addressTEmpView.hidden = NO;
                }
                
                self.telephoneChTextFile.text = mobStr;
                self.addressLabel.text = adderss;
                
                self.telephoneChTextFile.userInteractionEnabled = NO;//禁止编辑
            }];
            [self.navigationController pushViewController:thirdPartyVC animated:YES];
        }
        
    } failure:nil];
}
/*
 计算价格
 */
- (void)setPay{
    self.amountStr = [NSString stringWithFormat:@"%.2f",[self.storepPayment_commission_TextField.text floatValue] + [self.storepPayment_insurance_TextField.text floatValue] + [self.storepPayment_wages_TextField.text floatValue]];
         self.storepPayment_amount_label.text = [NSString stringWithFormat:@"合计： %@",self.amountStr];
}
@end
