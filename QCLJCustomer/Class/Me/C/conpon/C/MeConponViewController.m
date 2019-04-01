 //
//  MeConponViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MeConponViewController.h"
#import "Comment.h"
#import "ConponMode.h"
#import "ConponViewCell.h"

@interface MeConponViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UITableView *tableView;
@property (strong,nonatomic)  NSMutableArray *conponArr;
@property (nonatomic, assign) NSInteger pageNumber;
//@property (weak,nonatomic) UIView *tipView;
//@property (weak,nonatomic)  UIView *errorView;

@end
@implementation MeConponViewController
- (void)returnText:(ReturnMeConponBlock)block{
    self.returnMeConponBlock = block;
}
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}

//-(UIView *)tipView
//{
//    if (!_tipView) {
//        
//        UIView *tipView = [MySimple addViewWithFrame:CGRectMake(0,QiCaiNavHeight + 55 , MYScreenW, MYScreenH - 90)  imageType:MySimpleImageTypeNo topTitle:@"这里是空空的，快去" topFont:12 topTitleColor:QiCaiShallowColor bottomTitle:@"关注“七彩乐居”微信号，领取优惠券" bottomFont:12 bottomColor:QiCaiShallowColor];
//        _tipView = tipView;
//        _tipView.hidden = YES;
//        [self.view addSubview:_tipView];
//
//    }
//    return _tipView;
//}
-(NSMutableArray *)conponArr
{
    if (!_conponArr) {
        
        _conponArr = [NSMutableArray array];
    }
    return _conponArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [self setupUI];
    [self setupRefreshView];
    
}

-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"优惠券";
    UIBarButtonItem *queryBtnItem = [UIBarButtonItem addBarBtnItemWithTItle:@"使用说明" titleColor:[UIColor whiteColor] target:self action:@selector(clickUserConponBtn)];
    self.navigationItem.rightBarButtonItem = queryBtnItem;
    
    //顶部的
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, MYScreenW, 55);
    [self.view addSubview:topView];
    
    //请输入兑换码
    CHTextField *redeemCodeTextField = [CHTextField addCHTextFileWithLeftImage:nil frame:CGRectMake(10, 12.5, 200, 30) placeholder:@"请输入兑换码" placeholderLabelFont:10 placeholderTextColor:QiCaiShallowColor];
    redeemCodeTextField.placeholderTextColor = QiCaiShallowColor;
    redeemCodeTextField.placeholderLabelFont = QiCaiDetailTitle10Font;
    [topView addSubview:redeemCodeTextField];
    
    //兑换
    UIButton *cedeemBtn = [UIButton addZhuFuBtnWithTitle:@"兑换" rect:CGRectMake(CGRectGetMaxX(redeemCodeTextField.frame) + 9, 12.5, MYScreenW - CGRectGetMaxX(redeemCodeTextField.frame) - 20, 30) Target:self action:@selector(clickRedeemBtn)];
    cedeemBtn.titleLabel.font = QiCaiDetailTitle12Font;
    cedeemBtn.layer.cornerRadius = 3;
    [topView addSubview:cedeemBtn];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), MYScreenW, MYScreenH - CGRectGetMaxY(topView.frame) - 10 - 80) ];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    //底部的展示
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = QiCaiBackGroundColor;
    bottomView.frame = CGRectMake(0, MYScreenH - 80 - QiCaiNavHeight, MYScreenW, 80);
    [self.view addSubview:bottomView];
    
    UIButton *tel = [UIButton addBtnWithFrame:CGRectMake(0,5,MYScreenW, 25) btnBackGroundColor:[UIColor clearColor] leftImageName:@"me_conpon_tell" leftHeightImageName:@"me_conpon_tell" btnTitle:@"4000-999-001" titleColor:QiCaiNavBackGroundColor titltFont:QiCaiDetailTitle12Font imageEdge:UIEdgeInsetsZero titleEdge:UIEdgeInsetsZero];
    [tel addTarget:self action:@selector(clickTelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tel];
    
    UILabel *timeLabel = [UILabel addLabelWithFrame:CGRectMake(0, 35, MYScreenW, 10) text:@"客服工作时间：周一至周日8:00-20:00" size:10 textAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:timeLabel];
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
-(void)loadNewOrder
{
    self.pageNumber = 1;
    [self loadOrderWithPageNmuber:self.pageNumber];
}
-(void)loadOrderWithPageNmuber:(NSInteger)orderPageNumber
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"]= userId ;
    params[@"pageNumber"] = [NSString stringWithFormat:@"%ld",self.pageNumber];
    
    NSString *urlStr;
    if (self.orderID) {
        
        //可用优惠券列表
        params[@"orderId"] = self.orderID;
        urlStr = [NSString stringWithFormat:@"%@/couponLogAction.do?method=usableCoupon",kQICAIHttp];

    }else
    {
        //优惠券列表
       urlStr = [NSString stringWithFormat:@"%@/couponLogAction.do?method=clientCouponList",kQICAIHttp];
    }
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.conponArr url:urlStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            if (self.pageNumber == 1) {
                [self.conponArr removeAllObjects];
            }
            NSArray *cellArr = [ConponMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.conponArr addObjectsFromArray:cellArr];
            
//            [self.tableView reloadData];
            
        }else if ([responseObject[@"message"]  isEqual: @1]) {
            
            if (!self.conponArr.count) {
                [self showNotInternetViewToAbnormalState:AbnormalStateNoDataNo message1:@"这里是空空的，快去" message2:@"关注“七彩乐居”微信号，领取优惠券"];
            }
            
        }else if ([responseObject[@"message"]  isEqual: @4]) {
            
            [CHMBProgressHUD showSuccess:@"重新登录"];
        }
    } failure:nil];
    
}
//-(void)clickError
//{
//
//    [MySimple simpleInterests].hidden = YES;
//    [self.tableView.mj_header beginRefreshing];
//
//}
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
-(void)clickTelBtn
{
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}

//兑换
-(void)clickRedeemBtn
{
    [CHMBProgressHUD showFail:@"兑换码错误"];
}
//使用说明
-(void)clickUserConponBtn
{
    QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
    homeMaternityMatronVC.qcthmlType = QCHTMLTypeConponInstructions;
    [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
}
#pragma mark --tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//在当前段里有多少行
{
    
    return _conponArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell 单元格
{
    ConponViewCell  *cell = [ConponViewCell cellWithTableView:tableView];
    cell.conponMode = _conponArr[indexPath.row];
    return cell;
    
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    ConponMode * conponMode = self.conponArr[indexPath.row];
    if (self.returnMeConponBlock != nil) {
        self.returnMeConponBlock(conponMode );
        [self.navigationController popViewControllerAnimated:YES];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
    
}

@end
