//
//  MeViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MeViewController.h"
#import "Comment.h"
#import "PersonalInformationViewController.h"//个人信息
#import "MembershipCardController.h"//会员余额
#import "MeConponViewController.h"//优惠券
#import "GiftCardViewController.h"//礼品卡兑换
#import "MyMessageViewController.h"//我的消息
#import "FeedBackViewController.h"//意见反馈
#import "SetUpViewController.h"//设置
#import "ThirdPartyLoginViewController.h"//登录

@interface MeViewController()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UIScrollView *scrollView;
@property (weak,nonatomic)  UITableView *tableView;
@property (strong)NSMutableArray *testData;
@property (strong)NSMutableArray *testDataImage;

/**
 个人信息
 */
@property (weak,nonatomic)  UIButton *iconImageViewBtn;
@property (weak,nonatomic)  UILabel *nameLabel;
@property(weak,nonatomic) UILabel *telLabel;

/**
 会员卡优惠券信息
 */
@property(nonatomic,assign) NSNumber *membershipCardCount;
@property(nonatomic,assign) NSNumber *conponCount;

@property (nonatomic,strong)UIButton * membershipCardBtn;
@property (nonatomic,strong)UIButton *couponBtn;
/** 加减按钮的回调*/
//@property (nonatomic, copy) void(^numberBlock)(NSString *membershipCardBtn ,NSString *couponBtn);

@property (weak, nonatomic) UIButton *iconImageBtn;
@end


static NSString *const QCMeViewId = @"MeViewCell";

@implementation MeViewController
/**
 请求我的页面的会员卡和优惠券数量
 */
-(void)requestMeCount
{
//    //临时
//    [self setupUI];
    
    if (!self.couponBtn) {
        return;
    }
    [MySimple simpleInterests].hidden = YES;

    //个人信息
    //name
    NSString *nameStr = [MYUserDefaults objectForKey:@"name"];
    NSString *telStr = [MYUserDefaults objectForKey:@"mob"];;
    
    if (nameStr && ![nameStr isEqualToString:@"default"]) {
        
        nameStr = [MYUserDefaults objectForKey:@"name"];
        
    }else
    {
        nameStr = @"请完善您的资料";
    }
    self.nameLabel.text = nameStr;
    //tel
    if (telStr) {
        telStr = [MYUserDefaults objectForKey:@"mob"];
        
    }else{
        telStr = @"";
    }
    self.telLabel.text = telStr;
    //图像
    if ([UIImageView LocalHaveImage:@"userImageData" ]) {
        [self.iconImageBtn setImage:[[UIImageView GetImageFromLocal:@"userImageData"] circleImage] forState:UIControlStateNormal];
    }else{
        [self.iconImageBtn setImage:[UIImage imageNamed:@"me_iconDefault"] forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"]= userId ;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/memberAction.do?method=memberAccount",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:urlStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            self.membershipCardCount = responseObject[@"money"];
            self.conponCount = responseObject[@"couponCount"];
            
            [MYUserDefaults setObject:[NSString stringWithFormat:@"%@",responseObject[@"money"]] forKey:@"money"];//会员卡金额
            [MYUserDefaults setObject:[NSString stringWithFormat:@"%@",responseObject[@"couponCount"]] forKey:@"couponCount"];//优惠券数量
            [MYUserDefaults synchronize];
            
            [_membershipCardBtn setTitle:[NSString stringWithFormat:@"会员卡 %.2f 元",[self.membershipCardCount floatValue]] forState:UIControlStateNormal];
            [_couponBtn setTitle:[NSString stringWithFormat:@"优惠券 %@ 张",self.conponCount] forState:UIControlStateNormal];
            
            //防止重新设置富文本无效
            [self.membershipCardBtn setAttributedTitle:nil forState:UIControlStateNormal];
            [self.couponBtn setAttributedTitle:nil forState:UIControlStateNormal];
            //设置富文本
            [UIButton setRichButtonText:self.membershipCardBtn startStr:@"卡" endStr:@"元" font:self.membershipCardBtn.titleLabel.font color:QiCaiNavBackGroundColor];
            [UIButton setRichButtonText:self.couponBtn startStr:@"券" endStr:@"张" font:self.couponBtn.titleLabel.font color:QiCaiNavBackGroundColor];
            
        }else if ([responseObject[@"message"]  isEqual: @4]) {
            
            [CHMBProgressHUD showSuccess:@"重新登录"];
        }else if ([responseObject[@"message"]  isEqual: @1]) {
            VDLog(@"用户ID没有");
        }

    } failure:nil];
    
    
}

//-(void)clickError
//{
//    [MySimple simpleInterests].hidden = YES;
//    [self.tableView.mj_header beginRefreshing];
//}
/**
 *  回调状态页面刷新按钮
 *
 *  @param btn tag == 111 是立即预约
 *             tag == 222 是刷新
 */
- (void)requestDataWithStart:(UIButton *)btn{
    [self hiddenNotInternetView];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [UIView addMyNavBarWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight) centerTitle:@"" addleftImage:@"" LeftTarget:self leftAction:@selector(clickVoid) rightImageName:@"me_setupTop" addrightTarget:self rightAction:@selector(clickSetUpBtn) contentView:self.view];
    
    [self setupUI];


    //监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData1) name:@"UserInfoChangeSuccess" object:nil];
    
//    //监听事件 微信
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserWeiXinChangeSuccess" object:nil];
//    
//    //监听事件 支付宝
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserAlipayChangeSuccess" object:nil];
//    
//    //监听事件 会员卡
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData) name:@"UserHuiyuankaChangeSuccess" object:nil];
    
    //    [self requestMeCount];
}

//4. 观察者注销，移除消息观察者
-(void)dealloc
{
     [MYNotificationCenter removeObserver:@"UserInfoChangeSuccess"];
}
- (void)getUserInfoData1{
    
    [self.iconImageBtn setImage:[[UIImageView GetImageFromLocal:@"userImageData"] circleImage] forState:UIControlStateNormal];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/**
 假的
 */
-(void)clickVoid
{
    
}
-(void)setupUI
{    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.y = QiCaiNavHeight;
    scrollView.backgroundColor = QiCaiBackGroundColor;
    [self.view addSubview:scrollView];
    
    //顶部的视图
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, MYScreenW, 180);
    topView.backgroundColor = QiCaiNavBackGroundColor;
    [scrollView addSubview:topView];
    
    //顶部的子控制键
    UIButton *iconImageBtn = [UIButton addButtonWithFrame:CGRectMake(0, 17,70, 70) image:@"me_iconDefault" highImage:@"me_iconDefault" backgroundColor:[UIColor clearColor] Target:self action:@selector(clickIconImageBtn)];
    self.iconImageBtn = iconImageBtn;
    if ([UIImageView LocalHaveImage:@"userImageData" ]) {
        [iconImageBtn setImage:[[UIImageView GetImageFromLocal:@"userImageData"] circleImage] forState:UIControlStateNormal];
    }else{
        [iconImageBtn setImage:[UIImage imageNamed:@"me_iconDefault"] forState:UIControlStateNormal];
    }
    
    iconImageBtn.centerX = topView.centerX;
    [scrollView addSubview:iconImageBtn];
    self.iconImageViewBtn = iconImageBtn;
    
    //name
    NSString *nameStr = [MYUserDefaults objectForKey:@"name"];
    NSString *telStr = [MYUserDefaults objectForKey:@"mob"];;
    
    if (nameStr && ![nameStr isEqualToString:@"default"]) {
        
        nameStr = [MYUserDefaults objectForKey:@"name"];
        
    }else
    {
        nameStr = @"请完善您的资料";
    }
    UILabel *nameLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageBtn.frame) + 13, MYScreenW, 15) text:[NSString stringWithFormat:@"%@",nameStr] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] size:15 textAlignment:NSTextAlignmentCenter];
    [topView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //tel
    if (telStr) {
        telStr = [MYUserDefaults objectForKey:@"mob"];
        
    }else{
        telStr = @"";
    }
    UILabel *telLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 7, MYScreenW, 15) text:[NSString stringWithFormat:@"%@",telStr] textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor] size:15 textAlignment:NSTextAlignmentCenter];
    self.telLabel = telLabel;
    [topView addSubview:telLabel];

    topView.height = CGRectGetMaxY(telLabel.frame) + 22;
    
    //会员卡 优惠券
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), MYScreenW, 60)];
    view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view];
    
    self.membershipCardBtn = [UIButton addBtnWithFrame:CGRectMake(0, 0, MYScreenW / 2, 60) btnBackGroundColor:[UIColor whiteColor] leftImageName:@"me_membershipCard" leftHeightImageName:@"me_membershipCard" btnTitle:[NSString stringWithFormat:@"会员卡 %@ 元",@"0.00"] titleColor:QiCaiDeepColor titltFont:QiCai12PFFont imageEdge:UIEdgeInsetsMake(0, 0, 0, 0) titleEdge:UIEdgeInsetsMake(0, 5, 0, 0)];
    
    [self.membershipCardBtn addTarget:self action:@selector(clickMembershipCardBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.membershipCardBtn];
    
    //分割
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.membershipCardBtn.frame),7.5, 1, 45)];
    line.backgroundColor = QiCaiBackGroundColor;
    [view addSubview:line];
    
    self.couponBtn = [UIButton addBtnWithFrame:CGRectMake(CGRectGetMaxX(line.frame), 0, MYScreenW / 2, 60) btnBackGroundColor:[UIColor whiteColor] leftImageName:@"me_coupon" leftHeightImageName:@"me_coupon" btnTitle:[NSString stringWithFormat:@"优惠券 %@ 张",@"0"] titleColor:QiCaiDeepColor titltFont:QiCai12PFFont imageEdge:UIEdgeInsetsMake(0, 0, 0, 0) titleEdge:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.couponBtn addTarget:self action:@selector(clickConponBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.couponBtn];
    
    
//    __block UIButton *membershipCardbutton = _membershipCardBtn;
//    __block UIButton *couponBtnbutton = _couponBtn;
//    self.numberBlock = ^(NSString *membershipCard, NSString * coupon){
//        //设置界面的按钮显示 根据自己需求设置
//        [membershipCardbutton setTitle:membershipCard forState:UIControlStateNormal];
//        [couponBtnbutton setTitle:coupon forState:UIControlStateNormal];
//    };
    
//    _numberBlock ? _numberBlock(self.membershipCardCount, self.conponCount) : nil;
    
    
    //底部的各组
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), MYScreenW, 210) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc]init];
    
    tableView.delegate   = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [scrollView addSubview:tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = QiCaiBackGroundColor;
    
    _testData = [NSMutableArray array];
    
    NSArray *groupA = @[@"礼品卡兑换",@"我的消息",@"家政培训"];
    NSArray *groupB = @[@"意见反馈",@"设置"];
    [_testData addObject:groupA];
    [_testData addObject:groupB];
    
    _testDataImage = [NSMutableArray array];
    NSArray * imageArrty1 = @[@"me_giftCard",@"me_message",@"me_train"];
    NSArray *imageArr2 = @[@"me_feedBack",@"me_setup"];
    [_testDataImage addObject:imageArrty1];
    [_testDataImage addObject:imageArr2];

    //
    if (self.couponBtn) {
        [self requestMeCount];
    }
}
//会员余额
-(void)clickMembershipCardBtn
{
    MembershipCardController *membershipCardVC = [[MembershipCardController alloc]init];
    [CHMBProgressHUD showProgress:nil];
    [membershipCardVC returnTabBar:^{
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    }];
    membershipCardVC.membershipCardStr = self.membershipCardBtn.titleLabel.text;
    [self.navigationController pushViewController:membershipCardVC animated:YES];
}
//优惠券
-(void)clickConponBtn
{
    MeConponViewController *conponVC = [[MeConponViewController alloc]init];
    [self.navigationController pushViewController:conponVC animated:YES];
}
//设置
-(void)clickSetUpBtn
{
    [self pushSetupVC];
 
}
//头像
-(void)clickIconImageBtn
{
    PersonalInformationViewController *personalInformationVC = [[PersonalInformationViewController alloc]init];
    [personalInformationVC returnText:^(UIImage *ueseImage, NSString *nameStr) {
        
        [self.iconImageViewBtn setImage:ueseImage forState:UIControlStateNormal];
        
        if ([nameStr isEqualToString:@"default"]) {
            
            self.nameLabel.text = @"请完善您的资料";

        }else
        {
            self.nameLabel.text = nameStr;
        }
        
    }];
    
    [self.navigationController pushViewController:personalInformationVC animated:YES];
}

#pragma mark --tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//设置两段
{
    return _testData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//在当前段里有多少行
{
    NSArray * temp = _testData[section];
    return temp.count;//数组的内容
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell 单元格
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QCMeViewId];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    //左边的image
    UIImage * cellimage = [UIImage imageNamed:_testDataImage[indexPath.section][indexPath.row]];
    UIImageView * cellImageView = [[UIImageView alloc]init];
    cellImageView.image = cellimage;
    cellImageView.frame = CGRectMake(kTitleMargin, 15, 18, 18);
    cellImageView.centerY = cell.centerY;
    [cell addSubview:cellImageView];

    //文字
    UILabel * labelCell = [[UILabel alloc]init];
    labelCell.text = _testData[indexPath.section][indexPath.row];
    labelCell.font = QiCai12PFFont;
    labelCell.textColor = QiCaiDeepColor;
    labelCell.frame = CGRectMake(CGRectGetMaxX(cellImageView.frame) + 4, 15, MYScreenW - 2 * 50, 13);
    labelCell.centerY = cell.centerY;
    [cell addSubview:labelCell];
    
    //我的消息的圆点
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        UIImageView * messImage = [[UIImageView alloc]init];
        messImage.frame = CGRectMake(90,10,5,5);
        messImage.backgroundColor = QiCaiNavBackGroundColor;
        messImage.layer.cornerRadius = 2.5;
        [cell addSubview:messImage];
    }
    
    //右边的尖尖的image
    UIImageView * cellImageView2 = [[UIImageView alloc]init];
    cellImageView2.image =[UIImage imageNamed:@"main_icon_arrow"];
    cellImageView2.frame = CGRectMake( MYScreenW -  20, 15, 8, 15);
    cellImageView2.centerY = cell.centerY;
    [cell addSubview:cellImageView2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        GiftCardViewController *giftCardVC = [[GiftCardViewController alloc]init];
        [giftCardVC returnText:^{
            [self requestMeCount];
        }];
        [self.navigationController pushViewController:giftCardVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row ==1)
    {
        MyMessageViewController *myMessageVC = [[MyMessageViewController alloc]init];
        [self.navigationController pushViewController:myMessageVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row ==2)
    {
        QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
        homeMaternityMatronVC.qcthmlType = QCHTMLTypeHomeEconmicsTraining;
        [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        FeedBackViewController *feedBackVC = [[FeedBackViewController alloc]init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        [self pushSetupVC];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return QiCaiMargin;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
/*
 分割线移动
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 45, 0,10)];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 45, 0, 10)];

    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
/**
 设置页面
 */
-(void)pushSetupVC
{
    SetUpViewController *setUpVC = [[SetUpViewController alloc]init];
    [setUpVC returnPop:^{
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    }];
    [self.navigationController pushViewController:setUpVC animated:YES];
}
@end
