//
//  MyMessageViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MyMessageViewController.h"
#import "Comment.h"
#import "MyMessageMode.h"
#import "MyMessageCell.h"
#import "MYMessageDetailViewController.h"//链接的url

@interface MyMessageViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *MyMessageArr;
//@property (nonatomic, assign) NSInteger pageNumber;

@end
@implementation MyMessageViewController
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
-(NSMutableArray *)MyMessageArr
{
    if (!_MyMessageArr) {
        _MyMessageArr = [NSMutableArray array];
    }
    return _MyMessageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [self setupUI];
    [self setupRefreshView];
    
}
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
-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"我的消息";
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, MYScreenH) ];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];

}
-(void)setupRefreshView
{
    
    // 设置header 只要刷新就会触发loadNewData方法
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMyMessageData)];
    
    // 开启刷新想自动调用请求方法
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)loadMyMessageData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    //最新消息
    NSString *urlStr = [NSString stringWithFormat:@"%@/newsAction.do?method=getNewsList",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.MyMessageArr url:urlStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            [self.MyMessageArr removeAllObjects];
            
            NSArray *cellArr = [MyMessageMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.MyMessageArr addObjectsFromArray:cellArr];
            
            [self.tableView reloadData];
            
        }else if ([responseObject[@"message"]  isEqual: @1])
        {
            [CHMBProgressHUD showFail:@"暂无数据"];
        }

    } failure:^(NSError * _Nonnull error) {
        [CHMBProgressHUD showFail:@"获取失败"];
    }];
    
    
}

#pragma mark --tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//在当前段里有多少行
{
    
    return _MyMessageArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell 单元格
{
    MyMessageCell  *cell = [MyMessageCell cellWithTableView:tableView];
    cell.myMessageMode = _MyMessageArr[indexPath.row];
    return cell;
    
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    
//    MyMessageMode *myMessageMode = self.MyMessageArr[indexPath.row];
//    
//    MYMessageDetailViewController *myMessageDetailVC = [[MYMessageDetailViewController alloc]init];
//    myMessageDetailVC.newsTitle = myMessageMode.newsname;
//    myMessageDetailVC.newsURL = myMessageMode.url;
//    [self.navigationController pushViewController:myMessageDetailVC animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
/*
 分割线移动
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 40, 0,10)];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 40, 0, 10)];
        
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

@end
