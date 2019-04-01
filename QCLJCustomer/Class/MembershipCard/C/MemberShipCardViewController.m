//
//  MemberShipCardViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/10/10.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MemberShipCardViewController.h"
#import "Comment.h"
#import "SDCycleScrollView.h"//滚动图
#import "SDCycleScrollView+extent.h"//滚动图分类
#import "MembershipCardMode.h"
#import "MembershipCardCell.h"
#import "MemberRechargeViewController.h"//会员充值
#import "ThirdPartyLoginViewController.h"

@interface MemberShipCardViewController()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MembershipCardCellDelegatre>
@property (strong,nonatomic)  UITableView *tableView;
@property (strong,nonatomic)  NSMutableArray *membershipArr;

@end
@implementation MemberShipCardViewController
-(NSMutableArray *)membershipArr
{
    if (!_membershipArr) {
        _membershipArr = [NSMutableArray array];
    }
    return _membershipArr;
}
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
    [self setupRefreshView];

    
}
- (void)setupNavbar{
//    [UIView addMyNavBarWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight) centerTitle:@"会员卡" addTarget:self action:@selector(back) contentView:self.view];
    
    MyNavBar *navBar = [[MyNavBar alloc]init];
    navBar.backgroundColor = QiCaiNavBackGroundColor;
    navBar.frame = CGRectMake(0, 0, MYScreenW, QiCaiNavHeight);
    [navBar.rightBtn setTitle:@"会员特权" forState:UIControlStateNormal];
    navBar.titleLabel.text = @"会员卡";
//    [navBar.rightBtn.titleLabel setFont:QiCaiDetailTitle10Font];
    [navBar.rightBtn addTarget:self action:@selector(clickMembershipCardBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];

}
-(void)setupUI
{
//    // 设置导航栏标题
//    self.navigationItem.title = @"会员卡";
//    UIBarButtonItem *queryBtnItem = [UIBarButtonItem addBarBtnItemWithTItle:@"会员特权" titleColor:[UIColor whiteColor] target:self action:@selector(clickMembershipCardBtn)];
//    self.navigationItem.rightBarButtonItem = queryBtnItem;
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,QiCaiNavHeight, screenFrame.size.width, 153);
    NSArray *imageArray = @[ @"yanglao", @"yuesao",@"peixun"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [self.view addSubview:cycleScrollView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame) + QiCaiMargin, MYScreenW, 270)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.frame = CGRectMake(0, MYScreenH - 40 * 2, MYScreenW, 40);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel *timeLabel = [UILabel addLabelWithFrame:CGRectMake(0, 0, MYScreenW, 40) text:@"企业级购买请联系：4000-999-001" size:10 textAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:timeLabel];
    


}
-(void)setupRefreshView
{
    // 设置header 只要刷新就会触发loadNewData方法
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMemberData)];
    
    // 开启刷新想自动调用请求方法
    [self.tableView.mj_header beginRefreshing];

}
- (void)refressh{
     [self.tableView.mj_header beginRefreshing];
}
-(void)loadMemberData
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/memCardPayTypeAction.do?method=getList",kQICAIHttp];
    
    [[HttpRequest sharedInstance]post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.membershipArr url:urlStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            //删除旧数据
            [self.membershipArr removeAllObjects];
            
            NSArray *cellArr = [MembershipCardMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.membershipArr addObjectsFromArray:cellArr];
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            [CHMBProgressHUD showSuccess:@"后台"];
            
        }
        else if ([responseObject[@"message"]  isEqual: @1]) {
            
            [CHMBProgressHUD showSuccess:@"后台"];
        }
        
        
    } failure:nil];

    
}
/**
 *  回调状态页面刷新按钮
 *
 *  @param btn tag == 111 是立即预约
 *             tag == 222 是刷新
 */
- (void)requestDataWithStart:(UIButton *)btn{
    VDLog(@"刷新");
    [self hiddenNotInternetView];
    [self.tableView.mj_header beginRefreshing];
}

/**
 会员特权
 */
-(void)clickMembershipCardBtn
{
    QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
    homeMaternityMatronVC.qcthmlType = QCHTMLTypeMembershipPrivileges;
    [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];

}
/**
立即充值
 */
-(void)clickInstantRechargeBtn:(UIButton *)btn
{
    NSString *userIdString = [MYUserDefaults objectForKey:@"userId"];
    
    if (userIdString) {
        
        MembershipCardCell * cell = (MembershipCardCell *)[[btn superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MembershipCardMode *mode = self.membershipArr[indexPath.row];
    
        NSDictionary *dic = @{
                              @"amount" : mode.money,
                              @"stid" : mode.memberID,
                              };
        NSLog(@"%@",mode.money);
        MemberRechargeViewController *memberChargeVC = [[MemberRechargeViewController alloc]init];
        memberChargeVC.mebershipCardMode = mode;
        memberChargeVC.payModel = [PayModel mj_objectWithKeyValues:dic];
        memberChargeVC.payModel.payType = payForMemCard;
        VDLog(@"%@",memberChargeVC.payModel);
        [self.navigationController pushViewController:memberChargeVC animated:YES];
    }else
    {
        ThirdPartyLoginViewController *loginVC = [[ThirdPartyLoginViewController alloc]init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    }
    

}
#pragma mark --tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//在当前段里有多少行
{
    
    return _membershipArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell 单元格
{
    MembershipCardCell  *cell = [MembershipCardCell cellWithTableView:tableView];
    cell.membershipCardDelegate = self;
    cell.membershipCardMode = _membershipArr[indexPath.row];
    return cell;
    
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
    
}

@end
