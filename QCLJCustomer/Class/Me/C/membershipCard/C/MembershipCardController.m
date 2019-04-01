//
//  MembershipCardController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/2.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MembershipCardController.h"
#import "Comment.h"
#import "MemberBalanceCell.h"
#import "MemberBalanceMode.h"
#import "MembershipCardAccountInquiryVViewController.h"//账户查询

#import "MembershipAccountTableView.h"

@interface MembershipCardController()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UIScrollView *scrollView;
@property (weak,nonatomic)  UITableView *tableView;
@property (strong,nonatomic)  NSMutableArray *membershipArr;
@property(nonatomic,copy) NSString *memcardMoney;//余额
@property(nonatomic,copy) NSString *memcardNum; //会员卡号

@end
@implementation MembershipCardController
-(void)returnTabBar:(ReturnTabBarControllViewBlock)block
{
    self.returnTabBarControllViewBlock = block;
}

-(NSMutableArray *)membershipArr
{
    if (!_membershipArr) {
        
        _membershipArr = [NSMutableArray array];
    }
    return _membershipArr;
}
////重写loadView 使键盘上移导航栏不随着上移
//-(void)loadView
//{
//    [super loadView];
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    // 设置导航栏
    self.navigationItem.title = @"会员余额";
    UIBarButtonItem *queryBtnItem = [UIBarButtonItem addBarBtnItemWithTItle:@"账户查询" titleColor:[UIColor whiteColor] target:self action:@selector(clickQueayBtn)];
    [queryBtnItem setBackgroundVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = queryBtnItem;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self loadMemberData];
    
}

-(void)setupUI
{
    //底层
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.y = QiCaiNavHeight;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //会员卡账户
    UILabel *accountLabel = [[UILabel alloc]init];
    accountLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"me_member_account"] interval:3 frame:CGRectMake(10, 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"会员卡账户" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];

    [scrollView addSubview:accountLabel];
    
    UILabel *accountDetailLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(CGRectGetMaxX(accountLabel.frame), 10, MYScreenW - CGRectGetMaxX(accountLabel.frame) - 10, 20) text:[NSString stringWithFormat:@"%@",self.memcardNum] textColor:QiCaiNavBackGroundColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentRight];
    [scrollView addSubview:accountDetailLabel];
    
    //line
    UIView *accountLine = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(accountDetailLabel.frame) + 10, MYScreenW - 45, 1)];
    accountLine.backgroundColor = QiCaiBackGroundColor;
    [scrollView addSubview:accountLine];
    
    //余额
    UILabel *balanceLabel = [[UILabel alloc]init];
    balanceLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"me_member_balance"] interval:3 frame:CGRectMake(10,CGRectGetMaxY(accountLine.frame) + 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"会员卡余额" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:balanceLabel];

    UILabel *balanceDetailLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(balanceLabel.frame), CGRectGetMaxY(accountLine.frame) + 10, MYScreenW - CGRectGetMaxX(balanceLabel.frame) - 10, 20) text:[NSString stringWithFormat:@"%.2f元",[self.memcardMoney floatValue]] size:12 textAlignment:NSTextAlignmentRight];
    balanceDetailLabel.textColor = QiCaiDeepColor;
    [scrollView addSubview:balanceDetailLabel];
    
    //line
    UIView *balanceLine = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(balanceDetailLabel.frame) + 10, MYScreenW - 45, 1)];
    balanceLine.backgroundColor = QiCaiBackGroundColor;
    [scrollView addSubview:balanceLine];

    //最新消费记录
    UILabel *recordLabel = [[UILabel alloc]init];
    recordLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"me_member_record"] interval:3 frame:CGRectMake(10,CGRectGetMaxY(balanceLine.frame) + 10, MYScreenW * 0.5, 20) imageFrame:CGRectZero text:@"最新消费记录" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:recordLabel];
    
    MembershipAccountTableView * tableView = [[MembershipAccountTableView alloc]init];
    tableView.VCType = @"100";
    tableView.view.frame = CGRectMake(0, CGRectGetMaxY(recordLabel.frame), MYScreenW, MYScreenH - CGRectGetMaxY(recordLabel.frame) - 10);
    
    [scrollView addSubview:tableView.view];
    [self addChildViewController:tableView];
    
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(recordLabel.frame), MYScreenW, MYScreenH - CGRectGetMaxY(recordLabel.frame) - 10)];
//    self.tableView = tableView;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.tableFooterView = [[UIView alloc]init];
//    tableView.showsVerticalScrollIndicator = NO;
//    tableView.bounces = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [scrollView addSubview:tableView];
    
    UIButton *instantRechargeBtn = [UIButton addZhuFuBtnWithTitle:@"立即充值" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight, MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickInstantRechargeBtn)];
    [self.view addSubview:instantRechargeBtn];

}

-(void)loadMemberData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"]= userId ;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/memCardAction.do?method=getMemCardPage",kQICAIHttp];
    
    NSLog(@"%@",urlStr);

    [[HttpRequest sharedInstance]post_Internet_general_getWithTarget:self tableView:nil modelArr:self.membershipArr url:urlStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            self.memcardNum = responseObject[@"memcardNum"];
            self.memcardMoney = responseObject[@"memcardMoney"];
            
            [self setupUI];
            
        }else if ([responseObject[@"message"]  isEqual: @1]) {
            
            [CHMBProgressHUD showSuccess:@"重新登录"];
        }

    } failure:^(NSError * _Nullable error) {

        [self showNotInternetViewToAbnormalState:AbnormalStateNoNetwork message1:nil message2:nil];
    }];

    
}

- (void)requestDataWithStart:(UIButton *)btn{
    [self hiddenNotInternetView];
    [CHMBProgressHUD hide];

    [CHMBProgressHUD showProgress:@"加载中......"];
    [self loadMemberData];
    
}
-(void)clickInstantRechargeBtn
{
    if (self.returnTabBarControllViewBlock != nil) {
        self.returnTabBarControllViewBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//账户查询
-(void)clickQueayBtn
{
    MembershipCardAccountInquiryVViewController *membershipCardAccountInquiryVC = [[MembershipCardAccountInquiryVViewController alloc]init];
    [self.navigationController pushViewController:membershipCardAccountInquiryVC animated:YES];
}

@end
