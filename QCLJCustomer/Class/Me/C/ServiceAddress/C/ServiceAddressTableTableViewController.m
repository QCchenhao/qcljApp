//
//  ServiceAddressTableTableViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/12/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "ServiceAddressTableTableViewController.h"

#import "GaodePOIViewController.h"

#import "Comment.h"

//#import "ServiceAddressMode.h"

@interface ServiceAddressTableTableViewController ()<ServiceAddressDelegate>

@property (nonatomic,strong) NSMutableArray *serviceAddresss;

@property  NSInteger indexTitleMenu;//选中行数

@end

static NSString *const QCServiceAddressId = @"QCServiceAddress";

@implementation ServiceAddressTableTableViewController
- (void)returnAddTableText:(ReturnAddTextTableBlock)block {
    self.returnAddTextTableBlock = block;
}
- (NSMutableArray * )serviceAddresss
{
    if (!_serviceAddresss ) {
        _serviceAddresss = [NSMutableArray array];
    }
    return _serviceAddresss;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.returnAddTextTableBlock != nil) {
        self.returnAddTextTableBlock([MYUserDefaults objectForKey:@"address"],[MYUserDefaults objectForKey:@"addressId"]);
    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indexTitleMenu = 100000;
    [self setupTableView];
    [self setupRefreshView];
//    [self setupUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupTableView{
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = 0 ;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];//不想让下面的那些空显示
    
}
- (void)setupRefreshView{
    
    // 设置header 只要刷新就会触发loadNewData方法
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAddressData)];
    
    // 开启刷新想自动调用请求方法
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"刷新");
    
}

/**
 加载最新的
 */
-(void)loadAddressData
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params addParamsClientTimeAndTokenTo:params];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"] = userId;
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=getAddresses",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.serviceAddresss url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0]) //0 成功
        {
            [self.serviceAddresss removeAllObjects];
            
            NSArray *cellArr = [ServiceAddressMode mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.serviceAddresss addObjectsFromArray:cellArr];
            [self.tableView reloadData];
            
            for (NSInteger i = 0; i < self.serviceAddresss.count; i++) {
                ServiceAddressMode *nuber = self.serviceAddresss[i];
                if ([nuber.state isEqualToString:@"1"]) {
                    _indexTitleMenu = i;
                }
            }
            
        }else if ([responseObject[@"message"]  isEqual: @4])//4重新登录
        {
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            [self showNotInternetViewToAbnormalState:AbnormalStateNoDataNoAddress message1:@"请添加服务地址" message2:nil];
        }
    } failure:nil];
    
}
#pragma mark - Table view data source
#pragma mark --table代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.serviceAddresss.count;
    
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:QCServiceAddressId];
    if (cell == nil) {
        cell = [[ServiceAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QCServiceAddressId];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中状
    cell.serviceAddressDelegate = self;
    cell.serviceAddressMode = self.serviceAddresss[indexPath.row];
        
    //    _indexTitleMenu = [cell.serviceAddressMode.state integerValue];
    // 重用机制，如果选中的行正好要重用
    if (_indexTitleMenu == indexPath.row) {
        //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.addressBtn.selected = YES;
        [cell.deleteButton setTitleColor:UIColorFromRGB(0xe6e6e6) forState:UIControlStateNormal];
        cell.deleteButton.layer.borderColor = [UIColor clearColor].CGColor;

    } else {
        //        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.addressBtn.selected = NO;
        [cell.deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//设置两段
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceAddressMode * model = self.serviceAddresss[indexPath.row];
    if (self.returnAddTextTableBlock != nil) {
        self.returnAddTextTableBlock(model.address, model.addressId);
        
    }
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=setAddressDefault",kQICAIHttp];
    [self addAFNURLStr:URLStr indexPath:indexPath tableView:tableView];
    
    
    
}
#pragma mark - ServiceAddressDelegate--cell代理方法
- (void)editAddChlie:(UIButton *)btn{
    ServiceAddressCell * cell = (ServiceAddressCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    VDLog(@"%ld",(long)indexPath.row);
    ServiceAddressMode * moder = self.serviceAddresss[indexPath.row];
    
    GaodePOIViewController * detailsVC = [[GaodePOIViewController alloc]init];
    detailsVC.adderssID = moder.addressId;
    detailsVC.GaodePOIBlock = ^(NSString * address , NSString * adderssID){
        [self.tableView.mj_header beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}
- (void)deleteAddChlie:(UIButton *)btn{
    ServiceAddressCell * cell = (ServiceAddressCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    VDLog(@"%ld",(long)indexPath.row);
    
    ServiceAddressMode * moder = self.serviceAddresss[indexPath.row];
    if ([moder.state isEqualToString:@"1"] ) {
//        [CHMBProgressHUD showPrompt:@"默认地址不能删除"];
        return;
    }
    NSString * URLStr=  [NSString stringWithFormat:@"%@/addressAction.do?method=deleteAddress",kQICAIHttp];
    [self addAFNURLStr:URLStr indexPath:indexPath tableView:nil];
    
    
}
//封装方法
- (void)addAFNURLStr:(NSString *)URLStr indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    ServiceAddressMode * moder = self.serviceAddresss[indexPath.row];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params addParamsClientTimeAndTokenTo:params];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"] = userId;
    params[@"addressId"] = moder.addressId;
    
    if (!tableView && [moder.state isEqualToString:@"1"] ) {
        [CHMBProgressHUD showPrompt:@"默认地址不能删除"];
        return;
    }
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:self.tableView modelArr:self.serviceAddresss url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @1]) //0 成功
        {
            
            [self.serviceAddresss removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            
            
        }else if ([responseObject[@"message"]  isEqual: @4])//4重新登录
        {
            
        }else if ([responseObject[@"message"]  isEqual: @0]) {
            
            // 取消前一个选中的，就是单选啦
            NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_indexTitleMenu inSection:0];
            ServiceAddressCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
            //    lastCell.accessoryType = UITableViewCellAccessoryNone;
            lastCell.addressBtn.selected = NO;
            
            // 选中操作
            ServiceAddressCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
            //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.addressBtn.selected = YES;
            
            // 保存选中的
            _indexTitleMenu = indexPath.row;
            [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
            
            // 保存默认地址
            [MYUserDefaults setObject:moder.address forKey:@"address"];
            [MYUserDefaults setObject:moder.addressId forKey:@"addressId"];
            [MYUserDefaults synchronize];
            
            if(tableView){
                [self.navigationController popViewControllerAnimated:YES];
            }
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
    
    [self hiddenNotInternetView];
    
    [self.tableView.mj_header beginRefreshing];
    
}

@end
