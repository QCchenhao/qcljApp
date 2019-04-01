//
//  MembershipAccountTableView.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MembershipAccountTableView.h"
#import "Comment.h"
#import "MemberBalanceCell.h"
#import "MemberBalanceMode.h"

@interface MembershipAccountTableView()

@property (strong,nonatomic)  NSMutableArray *accountInquiryArr;
@property (nonatomic, assign) NSInteger pageNumber;
//@property (nonatomic,strong)UIView * tipView ;

@property (copy, nonatomic) NSString * min;
@property (copy, nonatomic) NSString * max;
@end
@implementation MembershipAccountTableView
//-(UIView *)tipView
//{
//    if (!_tipView) {
//        UIView *view = [MySimple addViewWithFrame:CGRectMake(0,0, MYScreenW, MYScreenH-90)   imageType:MySimpleImageTypeNo topTitle:@"没有查询到您想要的结果" topFont:12 topTitleColor:QiCaiShallowColor bottomTitle:@"请重新查询" bottomFont:12 bottomColor:QiCaiShallowColor];
//        view.hidden = YES;
//        _tipView = view;
//        [self.view addSubview:view];
//    }
//    return _tipView;
//}
-(NSMutableArray *)accountInquiryArr
{
    if (!_accountInquiryArr) {
        _accountInquiryArr = [NSMutableArray array];
    }
    return _accountInquiryArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNumber = 1;
    
    // 初始化表格
    [self setupTableView];

    if ([self.VCType isEqualToString:@"100"]) {
        self.tableView.scrollEnabled = NO;
        [self loadOrderWithPageNmuber:1 min:nil max:nil];
    }else{
        [self setupRefreshView];
    }
        
}

- (void)setupTableView
{
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
    
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
}

-(void)setupRefreshView
{
    
    // 设置header 只要刷新就会触发loadNewData方法
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrder)];
    
    // 开启刷新想自动调用请求方法
    [self.tableView.mj_header beginRefreshing];
    
    
    // 上拉刷新控件
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(laodMoreTopic)];
    
    self.tableView.mj_footer = footer;
}


/**
 检索  点击搜索的
 */
-(void)retrievalLaodMoreTopicToMin:(NSString *)min max:(NSString *)max
{
    NSLog(@"%@ %@",min,max);
    
    //删除旧数据
//    [self.accountInquiryArr removeAllObjects];
    
    self.pageNumber = 1;
    self.min = min;
    self.max = max;
    [self.tableView.mj_header beginRefreshing];
//    [self loadOrderWithPageNmuber:self.pageNumber min:min max:max];

}
/**
 加载更多
 */
-(void)laodMoreTopic
{
    self.pageNumber ++;
    [self loadOrderWithPageNmuber:self.pageNumber min:nil max:nil];
}
/**
 加载最新的
 */
-(void)loadNewOrder
{
    self.pageNumber = 1;
    [self loadOrderWithPageNmuber:self.pageNumber min:nil max:nil];
}
-(void)loadOrderWithPageNmuber:(NSInteger)orderPageNumber min:(NSString *)min max:(NSString *)max
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *urlStr;
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"]= userId;
    if ([self.VCType isEqualToString:@"100"]) {
        urlStr = [NSString stringWithFormat:@"%@/memCardAction.do?method=getMemCardPage",kQICAIHttp];
    }else{
        
        params[@"pageNum"] = [NSString stringWithFormat:@"%ld",self.pageNumber];
        params[@"type"] = self.stateType;
        
        if (self.min.length) {
            
            params[@"timeStart"] = [NSString stringWithFormat:@"%@ 00:00:00", self.min];
        }else
        {
            params[@"timeStart"] = [NSString stringWithFormat:@"2016-12-12 00:00:00"];

        }
        if (self.max.length) {
            
            params[@"timeEnd"] = [NSString stringWithFormat:@"%@ 23:59:59", self.max];
            
        }else
        {
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            NSLog(@"dateString:%@",dateString);
            
            params[@"timeEnd"] = [NSString stringWithFormat:@"%@ 23:59:59", dateString];
        }
        
        urlStr = [NSString stringWithFormat:@"%@/memCardAction.do?method=getAccountList",kQICAIHttp];
        
    }
    
        [[HttpRequest sharedInstance]post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.accountInquiryArr url:urlStr params:params success:^(id  _Nullable responseObject) {
        
        
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            if (self.pageNumber == 1) {
                
                [self.accountInquiryArr removeAllObjects];
            }
            
            NSArray *cellArr = [MemberBalanceMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.accountInquiryArr addObjectsFromArray:cellArr];
            
            if (self.accountInquiryArr.count) {
                
//                [self.tableView reloadData]
                
            }else
            {
                [self showNotInternetViewToAbnormalState:AbnormalStateNoDataNo message1:@"没有查询到您想要的结果"  message2:@"请重新查询"];
            }
            
        }
        else if ([responseObject[@"message"]  isEqual: @2]) {
            
            [CHMBProgressHUD showSuccess:@"重新登录"];
        }
        else if ([responseObject[@"message"]  isEqual: @9]) {
            
            [self showNotInternetViewToAbnormalState:AbnormalStateNoDataNo message1:@"没有查询到您想要的结果"  message2:@"请重新查询"];
        }
        
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
        
        
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
-(void)clickError
{

    [MySimple simpleInterests].hidden = YES;

    [self.tableView.mj_header beginRefreshing];

}

#pragma mark -- UITableViewDelegate DataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//在当前段里有多少行
{
    
    return self.accountInquiryArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell 单元格
{
    MemberBalanceCell *cell = [MemberBalanceCell cellWithTableView:tableView];
    
    if (indexPath.row < [self.accountInquiryArr count]) {

        for (MemberBalanceMode *mode in _accountInquiryArr) {
            if (indexPath.row == 0) {
                mode.isTopShow = NO;
                mode.isBottomShow = YES;
            }
            else if (indexPath.row == _accountInquiryArr.count - 1)
            {
                mode.isTopShow = YES;
                mode.isBottomShow = NO;
            }
            else
            {
                mode.isTopShow = YES;
                mode.isBottomShow = YES;
            }
            
        }
        cell.memcardNum = [MYUserDefaults objectForKey:@"mob"];
        cell.memberBalanceMode = _accountInquiryArr[indexPath.row];

    }else{
        
    }
    
    return cell;
    
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}

@end
