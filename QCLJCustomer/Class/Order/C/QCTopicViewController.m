//
//  QCTopicViewController.m
//  七彩乐居
//
//  Created by QCJJ－iOS on 16/3/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "QCTopicViewController.h"
#import "Comment.h"

#import "OrderTableViewCell.h"
#import "OrderModel.h"

#import "DetailsViewController.h"
#import "QiCaiTabBarController.h"//用于跳转首页
#import "OrderPayViewController.h"//订单支付
#import "StorePayViewController.h"//门店缴费
#import "OrderCancelViewController.h"//取消页面


#import "NannyViewController.h"//保姆
#import "ParentalViewController.h"//育儿嫂
#import "MaternityMatronViewController.h"//月嫂
#import "HomePackageViewController.h"//家政套餐
#import "EnterpriseServiceViewController.h"//企业服务
#import "StorePaymentViewController.h"//门店缴费

@interface QCTopicViewController ()<QCTopicCellDelegate,PopDelegate>


@property (nonatomic,assign)NSInteger pageNumber;


@end

static NSString *const QCcontractId = @"QCcontract";

@implementation QCTopicViewController

-(NSMutableArray *)tops{
    if (!_tops) {
        _tops = [NSMutableArray array];
    }
    return _tops;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 1;
    
    // 初始化表格
    [self setupTableView];
    [self setupRefreshView];

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
    
    [self.tableView.mj_header beginRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"]= userId ;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/memberAction.do?method=memberAccount",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:urlStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            
            
            [MYUserDefaults setObject:[NSString stringWithFormat:@"%@",responseObject[@"money"]] forKey:@"money"];//会员卡金额
            [MYUserDefaults setObject:[NSString stringWithFormat:@"%@",responseObject[@"couponCount"]] forKey:@"couponCount"];//优惠券数量
            [MYUserDefaults synchronize];
            
            
        }else if ([responseObject[@"message"]  isEqual: @4]) {
            
        }else if ([responseObject[@"message"]  isEqual: @1]) {
            VDLog(@"用户ID没有");
        }
        
    } failure:nil];

}



- (void)orderRefresh{
    
    [self.tops removeAllObjects];
//    // 开启刷新想自动调用请求方法
    [self.tableView.mj_header beginRefreshing];
    
//    //判断是否处于刷新状态
//    if ([self.tableView.mj_header isRefreshing]) {
//        
//        
//        [self.tableView.mj_header endRefreshing];//是的话，结束刷新状态
//        [self setupRefreshView];//重新刷新
////        [self.tableView.mj_footer endRefreshing];
//    }else{
//        [self setupRefreshView];//重新刷新
//    }
    
    
    
}
- (void)setupTableView
{
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = 0 ;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    //隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //cell设置无下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];//不想让下面的那些空显示
}

-(void)setupRefreshView
{
    // 设置header 只要刷新就会触发loadNewData方法
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 开启刷新想自动调用请求方法
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"刷新");
    
    
    // 上拉刷新控件
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(laodMoreTopic)];
    
    self.tableView.mj_footer = footer;
    
    
}
/**
 加载更多
 */
-(void)laodMoreTopic
{
    self.pageNumber ++;
    [self loadOrderWithPageNmuber:self.pageNumber];
}
/**
 加载最新的
 */
-(void)loadNewData
{
    
//    [self.tops removeAllObjects];
    self.pageNumber = 1;
//    [self loadOrderWithPageNmuber:self.pageNumber];
    
    [self loadOrderWithPageNmuber:self.pageNumber];
}

-(void)loadOrderWithPageNmuber:(NSInteger)pageNumber
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    NSString * stateType ;
    switch (self.stateType) {
        case OrderStateAll:

            break;
        case OrderStateNoComplete:
            stateType = @"(0,1,2,3,4,5,6,10,11)";
            break;
        case OrderStateComplete:
            stateType = @"(7,8)";
            break;
        case OrderStateToEvaluate:
            stateType = @"(7)";
            break;
        default:
            break;
    }
    
    params[@"userId"] = userId;
    params[@"pageNumber"] = [NSString stringWithFormat:@"%ld",(long)pageNumber];
    params[@"state"] = stateType;
    if (self.orderType != OrderAlltype) {
        params[@"orderType"] = [NSString stringWithFormat:@"%ld",(long)self.orderType];
    }
    NSString * URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=getClientOrders",kQICAIHttp];

    [[HttpRequest sharedInstance]post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.tops url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (!responseObject) {
            VDLog(@"用户ID有问题");
        }

        if ([responseObject[@"message"]  isEqual: @4]) {
            VDLog(@"重新登录");
        }else if ([responseObject[@"message"]  isEqual: @0])
        {
            NSLog(@"成功 ＝＝＝%@",responseObject);
            if (pageNumber == 1) {
                [self.tops removeAllObjects];
            }
            NSArray *cellArr = [OrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tops addObjectsFromArray:cellArr];
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            if (pageNumber == 1) {
                
                [self.tops removeAllObjects];
            }
            
            if (self.tops.count > 0) {
                
            }else{
                VDLog(@"没有相关数据");
                [self showNotInternetViewToAbnormalState:AbnormalStateNoDataLookup message1:@"还没有未完成的订单，赶快下单吧！" message2:nil];
            }
            
        }
    } failure:nil];
}
//-(void)clicksummitBtn
//{
//    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
//}
//-(void)clickError
//{
//
//    [MySimple simpleInterests].hidden = YES;
//
//    [self.tableView.mj_header beginRefreshing];
//}
#pragma mark - 状态页面刷新
/**
 *  回调状态页面刷新按钮
 *
 *  @param btn tag == 111 是立即预约
 *             tag == 222 是刷新
 */
- (void)requestDataWithStart:(UIButton *)btn{
    
    [self hiddenNotInternetView];
    if (btn.tag == 111) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    }else{
        
        [self.tableView.mj_header beginRefreshing];
    }
    
}
#pragma mark - Table view data source
#pragma mark --table代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%lu",(unsigned long)self.tops.count);
    return self.tops.count;
    
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:QCcontractId];
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QCcontractId];
        //        cell.managementAddressCellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中状
        
    }
    cell.topDelegate = self;
    if (indexPath.row < [_tops count]) {
        cell.orderModel = self.tops[indexPath.row];
    }else{
    
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//设置两段
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CHMBProgressHUD showProgress:nil];

    DetailsViewController * detailsVC = [[DetailsViewController alloc]init];
    
    if (indexPath.row < [_tops count]) {//无论你武功有多高，有时也会忘记加
        detailsVC.orderModel = self.tops[indexPath.row];

    
    }else{
        
    }
    [detailsVC returnOrderList:^{
       [self.tableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}
#pragma mark - QCTopicCellDelegate--cell按钮 代理方法

/**
 //取消订单
 */
-(void)cancelButtonClick:(UIButton *)btn{
    
    OrderTableViewCell * cell = (OrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    VDLog(@"%ld",(long)indexPath.row);
    OrderModel * orderMode = self.tops[indexPath.row];
    
    //取消页面
    OrderCancelViewController * orderCancelVC = [[OrderCancelViewController alloc]init];
    [orderCancelVC returnOrderList:^{
        [self.tops removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
    }];
    orderCancelVC.orderModel = orderMode;
    [self.navigationController pushViewController:orderCancelVC animated:YES];
    
    
   
}
/**
 //确认付款
 */
- (void)payButtonChile:(UIButton *)btn{
    
   
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=getDetailOrder",kQICAIHttp];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrderTableViewCell * cell = (OrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderModel * orderMode = self.tops[indexPath.row];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"] = userId;
    params[@"orderId"] = orderMode.orderId;

    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @4]) {
            VDLog(@"重新登录");
        }else if ([responseObject[@"message"]  isEqual: @0])
        {
            DetailsModel * mode = [DetailsModel mj_objectWithKeyValues:responseObject];
            
           
            
            //传值支付模型初始值
            NSString * spriceStr = [NSString stringWithFormat:@"%.2f",mode.sprice];
            NSDictionary *dic = @{
                                  @"couponLogId" : @"0",
                                  @"stid" : orderMode.orderId,
                                  @"amount" : spriceStr,
                                  };
    
            OrderPayViewController * payVC= [[OrderPayViewController alloc]init];
            /**
             *  block回调
             */
            [payVC returnOrderList:^{
                [self.tops removeAllObjects];
                [self.tableView.mj_header beginRefreshing];
            }];
            payVC.detailsModel = mode;
            payVC.payModel = [PayModel mj_objectWithKeyValues:dic];
            payVC.detailsModel.orderId = orderMode.orderId;//订单ID传值
            [self.navigationController pushViewController:payVC animated:YES];
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            VDLog(@"没有相关数据");
        }

    } failure:nil];
    
}
/**
 //续约订单
 */
- (void)renewButtonChile:(UIButton *)btn{
    VDLog(@"%@",btn.titleLabel.text);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
    
}

/**
 //验收订单
 */
- (void)completeButtonChile:(UIButton *)btn{
    VDLog(@"%@",btn.titleLabel.text);
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=clientAcceptanceOrder",kQICAIHttp];
    NSLog(@"%@",URLStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    OrderTableViewCell * cell = (OrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderModel * orderMode = self.tops[indexPath.row];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"] = userId;
    params[@"orderId"] = orderMode.orderId;
    
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.tops url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0])
        {
            [CHMBProgressHUD showSuccess:@"成功验收订单"];
            [self.tops removeAllObjects];
            // 开启刷新想自动调用请求方法
            [self.tableView.mj_header beginRefreshing];
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            [CHMBProgressHUD showPrompt:@"验收订单失败"];
        }
    } failure:nil];
}
/**
 //我来点评
 */
- (void)commentButtonChile:(UIButton *)btn{
    VDLog(@"%@",btn.titleLabel.text);
    [CHMBProgressHUD showProgress:nil];
    OrderTableViewCell * cell = (OrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    VDLog(@"%ld",(long)indexPath.row);
    
    DetailsViewController * detailsVC = [[DetailsViewController alloc]init];
    
    if (indexPath.row < [_tops count]) {//无论你武功有多高，有时也会忘记加
        detailsVC.orderModel = self.tops[indexPath.row];
        
    }else{
        
    }
    [detailsVC returnOrderList:^{
        [self.tableView.mj_header beginRefreshing];
    }];

    [self.navigationController pushViewController:detailsVC animated:YES];
}
/**
 //再来一单
 */
- (void)againButtonChile:(UIButton *)btn{
    VDLog(@"%@",btn.titleLabel.text);
    
    OrderTableViewCell * cell = (OrderTableViewCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    VDLog(@"%ld",(long)indexPath.row);
    OrderModel * orderMode = self.tops[indexPath.row];
    
    if ([orderMode.orderType isEqualToString:@"月嫂"]) {
        MaternityMatronViewController * maternVC = [[MaternityMatronViewController alloc]init];
        [maternVC returnHomeBlock:^{
             self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
        [self.navigationController pushViewController:maternVC animated:YES];
    }else if ([orderMode.orderType isEqualToString:@"育儿师"]) {
        ParentalViewController * parentaVC = [[ParentalViewController alloc]init];
        [parentaVC returnHomeBlock:^{
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
        [self.navigationController pushViewController:parentaVC animated:YES];
    }else if ([orderMode.orderType isEqualToString:@"保姆"]) {
        NannyViewController * nannVC = [[NannyViewController alloc]init];
        [nannVC returnHomeBlock:^{
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
        [self.navigationController pushViewController:nannVC animated:YES];
    }else if ([orderMode.orderType isEqualToString:@"家政套餐"]) {
        HomePackageViewController * homePackageVC = [[HomePackageViewController alloc]init];
        [homePackageVC returnHomeBlock:^{
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
        [self.navigationController pushViewController:homePackageVC animated:YES];
    }else if ([orderMode.orderType isEqualToString:@"企业服务"]) {
        EnterpriseServiceViewController * enterpriseVC = [[EnterpriseServiceViewController alloc]init];
        [enterpriseVC returnHomeBlock:^{
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
        [self.navigationController pushViewController:enterpriseVC animated:YES];
    }else if ([orderMode.orderType isEqualToString:@"门店缴费"]) {
        StorePaymentViewController * storeVC = [[StorePaymentViewController alloc]init];
        [storeVC returnHomeBlock:^{
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    
}
@end
