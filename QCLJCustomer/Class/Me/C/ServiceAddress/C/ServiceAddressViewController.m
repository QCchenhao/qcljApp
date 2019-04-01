//
//  ServiceAddressViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "ServiceAddressViewController.h"

#import "Comment.h"

#import "SDCycleScrollView.h"//滚动图
#import "SDCycleScrollView+extent.h"//滚动图分类

#import "GaodePOIViewController.h"

#import "ServiceAddressTableTableViewController.h"


@interface ServiceAddressViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)ServiceAddressTableTableViewController * serviceAddressVC;
//@property (nonatomic,strong)UITableView * tableView;

//@property (nonatomic,strong) NSMutableArray *serviceAddresss;
//
//@property  NSInteger indexTitleMenu;//选中行数

//@property (weak,nonatomic)  UIView *tipView;

//@property (assign, nonatomic)NSInteger pageNumber;
@end

//static NSString *const QCServiceAddressId = @"QCServiceAddress";
@implementation ServiceAddressViewController
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)returnAddText:(ReturnAddTextBlock)block {
    self.returnAddTextBlock = block;
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [self.serviceAddressVC returnAddTableText:^(ServiceAddressMode *address) {
//        if (self.returnAddTextBlock != nil) {
//            self.returnAddTextBlock (address);
//        }
//    }];
}
- (ServiceAddressTableTableViewController *)serviceAddressVC{
    if (!_serviceAddressVC) {
        _serviceAddressVC = [[ServiceAddressTableTableViewController alloc]init];
    }
    return _serviceAddressVC;
}
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}
//- (NSMutableArray * )serviceAddresss
//{
//    if (!_serviceAddresss ) {
//        _serviceAddresss = [NSMutableArray array];
//    }
//    return _serviceAddresss;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
//    _indexTitleMenu = 100000;
//    [self setupTableView];
//    [self setupRefreshView];
    [self setupUI];
    
}
//- (void)setupTableView{
//    // 设置内边距
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    CGFloat top = 0 ;
//    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//
//    // 设置滚动条的内边距
//    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.tableFooterView = [[UIView alloc] init];//不想让下面的那些空显示
//    
//}
//- (void)setupRefreshView{
//    
//    // 设置header 只要刷新就会触发loadNewData方法
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAddressData)];
//    
//    // 开启刷新想自动调用请求方法
//    [self.tableView.mj_header beginRefreshing];
//    NSLog(@"刷新");
//    
//}

///**
// 加载最新的
// */
//-(void)loadAddressData
//{
//    
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //    [params addParamsClientTimeAndTokenTo:params];
//    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
//    params[@"userId"] = userId;
//    
//    NSString * URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=getAddresses",kQICAIHttp];
//
//    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.serviceAddresss url:URLStr params:params success:^(id  _Nullable responseObject) {
//        if ([responseObject[@"message"]  isEqual: @0]) //0 成功
//        {
//            [self.serviceAddresss removeAllObjects];
//
//            NSArray *cellArr = [ServiceAddressMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//            [self.serviceAddresss addObjectsFromArray:cellArr];
//            [self.tableView reloadData];
//            
//            for (NSInteger i = 0; i < self.serviceAddresss.count; i++) {
//                ServiceAddressMode *nuber = self.serviceAddresss[i];
//                if ([nuber.state isEqualToString:@"1"]) {
//                    _indexTitleMenu = i;
//                }
//            }
//            
//        }else if ([responseObject[@"message"]  isEqual: @4])//4重新登录
//        {
//            
//        }else if ([responseObject[@"message"]  isEqual: @2]) {
//            
//            //            _superiorId = @"0";
//        }
//    } failure:nil];
//   
//}
//-(void)clickError
//{
//
//    [MySimple simpleInterests].hidden = YES;
//
//    [self.tableView.mj_header beginRefreshing];
//}
-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"服务地址";
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0 , screenFrame.size.width, 153);
    NSArray *imageArray = @[ @"yanglao", @"yuesao",@"peixun"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [self.view addSubview:cycleScrollView];
    
    //列表控制器
    [self addChildViewController:self.serviceAddressVC];
    
    [self.serviceAddressVC returnAddTableText:^(NSString *address ,NSString *adderssID) {
        if (self.returnAddTextBlock != nil) {
            self.returnAddTextBlock (address, adderssID);
        }
    }];
    
    self.serviceAddressVC.view.x = 0;
    self.serviceAddressVC.view.y = CGRectGetMaxY(cycleScrollView.frame) + 7;
    self.serviceAddressVC.view.height =  CGRectGetHeight(self.view.frame) - CGRectGetHeight(cycleScrollView.frame) - QiCaiZhifuHeight - 40;
    self.serviceAddressVC.view.width =  MYScreenW;
    [self.view addSubview:self.serviceAddressVC.view];
    
    //立即预定
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"添加服务地址" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickMaternityMatronSummit)];
    [self.view addSubview:maternityMatronsummitBtn];
    
}
- (void)clickMaternityMatronSummit{
    GaodePOIViewController * detailsVC = [[GaodePOIViewController alloc]init];
    detailsVC.GaodePOIBlock = ^(NSString * address , NSString * adderssID){
        //刷新
        [self.serviceAddressVC.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailsVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SDCycleScrollViewDelegate--轮播图代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    VDLog(@"---点击了第%ld张图片", (long)index);
}
/*
 // 滚动到第几张图回调
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
 {
 NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
 }
 */
#pragma mark - Table view data source
//#pragma mark --table代理方法
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return self.serviceAddresss.count;
//    
//}
//
////单元格
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ServiceAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:QCServiceAddressId];
//    if (cell == nil) {
//        cell = [[ServiceAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QCServiceAddressId];
//        //        cell.managementAddressCellDelegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中状
//        
//    }
//    cell.serviceAddressDelegate = self;
//    cell.serviceAddressMode = self.serviceAddresss[indexPath.row];
//    
//
////    _indexTitleMenu = [cell.serviceAddressMode.state integerValue];
//    // 重用机制，如果选中的行正好要重用
//    if (_indexTitleMenu == indexPath.row) {
////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.addressBtn.selected = YES;
//    } else {
////        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.addressBtn.selected = NO;
//    }
//    
//    return cell;
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//    
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//设置两段
//{
//    return 1;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ServiceAddressMode * model = self.serviceAddresss[indexPath.row];
//    if (self.returnAddTextBlock != nil) {
//        self.returnAddTextBlock(model);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//    NSString * URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=setAddressDefault",kQICAIHttp];
//    [self addAFNURLStr:URLStr indexPath:indexPath tableView:tableView];
//    
//   
//}
//#pragma mark - ServiceAddressDelegate--cell代理方法
//- (void)editAddChlie:(UIButton *)btn{
//    ServiceAddressCell * cell = (ServiceAddressCell *)[[btn superview] superview];
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    VDLog(@"%ld",(long)indexPath.row);
//    ServiceAddressMode * moder = self.serviceAddresss[indexPath.row];
//    
//    GaodePOIViewController * detailsVC = [[GaodePOIViewController alloc]init];
//    detailsVC.adderssID = moder.addressId;
//    detailsVC.GaodePOIBlock = ^(NSString * address){
//        [self loadAddressData];
//    };
//    
//    [self.navigationController pushViewController:detailsVC animated:YES];
//    
//}
//- (void)deleteAddChlie:(UIButton *)btn{
//    ServiceAddressCell * cell = (ServiceAddressCell *)[[btn superview] superview];
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    VDLog(@"%ld",(long)indexPath.row);
//     NSString * URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=deleteAddress",kQICAIHttp];
//    [self addAFNURLStr:URLStr indexPath:indexPath tableView:nil];
//  
//
//}
////封装方法
//- (void)addAFNURLStr:(NSString *)URLStr indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
//    ServiceAddressMode * moder = self.serviceAddresss[indexPath.row];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //    [params addParamsClientTimeAndTokenTo:params];
//    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
//    params[@"userId"] = userId;
//    params[@"addressId"] = moder.addressId;
//    
//    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.serviceAddresss url:URLStr params:params success:^(id  _Nullable responseObject) {
//        if ([responseObject[@"message"]  isEqual: @1]) //0 成功
//        {
//            //判断如果删除的是默认地址
//            if ([moder.state isEqualToString:@"1"]) {
//                [MYUserDefaults removeObjectForKey:@"addressId"];
//                [MYUserDefaults synchronize];
//                _indexTitleMenu = 100000;
//            }
//            [self.serviceAddresss removeObjectAtIndex:indexPath.row];
//            [self.tableView reloadData];
//            
//        }else if ([responseObject[@"message"]  isEqual: @4])//4重新登录
//        {
//            
//        }else if ([responseObject[@"message"]  isEqual: @0]) {
//            
//            // 取消前一个选中的，就是单选啦
//            NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_indexTitleMenu inSection:0];
//            ServiceAddressCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
//            //    lastCell.accessoryType = UITableViewCellAccessoryNone;
//            lastCell.addressBtn.selected = NO;
//            
//            // 选中操作
//            ServiceAddressCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
//            //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            cell.addressBtn.selected = YES;
//            
//            // 保存选中的
//            _indexTitleMenu = indexPath.row;
//            [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
//            
//            // 保存默认地址
//            [MYUserDefaults setObject:moder.address forKey:@"address"];
//            [MYUserDefaults setObject:moder.addressId forKey:@"addressId"];
//            [MYUserDefaults synchronize];
//            
//        }
//
//    } failure:nil];
//    
//    
//   
//}
@end
