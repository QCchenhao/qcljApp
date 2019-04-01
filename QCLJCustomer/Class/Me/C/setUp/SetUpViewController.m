//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "SetUpViewController.h"
#import "Comment.h"
#import "MyBaseCellGroupDataMode.h"
#import "MyBaseCellMode.h"
#import "MyBaseCell.h"
#import "MyBaseCellArrowMode.h"
#import "NSString+File.h"
#import "AboutMeViewcontroller.h"
//#import "QiCaiTabBarController.h"

//#import "QiCaiNavigationController.h"
//#import "MeViewController.h"

@interface SetUpViewController ()<UITableViewDataSource,UITableViewDelegate,PopDelegate>
@property (strong, nonatomic)  NSMutableArray *dataArr;

@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic,weak) UIView * noLoginView;
@property (weak,nonatomic)  MyBaseCell *cell;

@end

@implementation SetUpViewController
- (void)returnPop:(ReturnSetUpViewBlock)block{
    self.returnSetUpViewBlock = block;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = QiCaiBackGroundColor;
    self.navigationItem.title = @"设置";
    
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.frame = CGRectMake(0, 0, MYScreenW, MYScreenH - QiCaiZhifuHeight);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView.separatorColor = QiCaiBackGroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.showsVerticalScrollIndicator = NO;
    tableView.bounces = NO;
    
    //退出
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"退出登录" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickGoodBay)];
    [self.view addSubview:maternityMatronsummitBtn];
    
    [self setupData];
}
-(void)clickGoodBay
{
    [CHMBProgressHUD showPromptWithMessage:@"确定退出吗？" buttonArr:@[@"取消",@"确定"]];
    [CHMBProgressHUD shareinstance].popDelegate = self;
}
-(void)PopButton:(UIButton *)PopButton
{
    
    VDLog(@"popView按钮个数===%ld",PopButton.tag);
    if (PopButton.tag == 0) {//取消
        
    }else
    {
        [MYUserDefaults removeObjectForKey:@"name"];
        [MYUserDefaults removeObjectForKey:@"mob"];
        [MYUserDefaults removeObjectForKey:@"birthday"];
        [MYUserDefaults removeObjectForKey:@"userId"];
        
        [MYUserDefaults removeObjectForKey:@"address"];
        [MYUserDefaults removeObjectForKey:@"contactName"];
        [MYUserDefaults removeObjectForKey:@"contactTel"];
        [MYUserDefaults removeObjectForKey:@"addressId"];
        
        [MYUserDefaults removeObjectForKey:@"money"];
        [MYUserDefaults removeObjectForKey:@"couponCount"];
        
//        UIImageView * figureurl_qq_2 = [[UIImageView alloc]init];
//        //            figureurl_qq_2.image = [UIImage imageNamed:@"Member_me_user_ placeholder"];
//        [figureurl_qq_2 imageToNamed:@"Member_me_user_ placeholder"];
//        //本地保存
//        [UIImageView SaveImageToLocal:figureurl_qq_2.image Keys:@"userImageData"];
        
//        [MYUserDefaults removeObjectForKey:@"addArrrty"];
        [MYUserDefaults synchronize];

        
        if (self.returnSetUpViewBlock != nil) {
            self.returnSetUpViewBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    }
    [[CHMBProgressHUD shareinstance].hud hide:YES];
    
}
-(void)setupData
{
    MyBaseCellGroupDataMode *g0 = [[MyBaseCellGroupDataMode alloc]init];
    MyBaseCellMode *cell00 = [MyBaseCellArrowMode cellWithTitle:@"用户协议" descVC:nil];
    MyBaseCellMode *cell01 = [MyBaseCellArrowMode cellWithTitle:@"关于我们" descVC:[AboutMeViewcontroller class]];

    MyBaseCellMode *cell02 = [MyBaseCellMode cellWithtitle:@"清理缓存"];
    [self clearMemory:cell02];
    
    g0.cells = @[cell00,cell01,cell02];
    
    NSArray *dataArr = @[g0];
    self.dataArr =[NSMutableArray array];
    [self.dataArr addObjectsFromArray:dataArr];
}

/**
 清理缓存
 */
-(void)clearMemory:(MyBaseCellMode *)cell
{
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imageCachesPath = [cachesPath stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    //计算文件大小
    long long fileSize = [imageCachesPath fileSize];
    
    cell.subTitle = [NSString stringWithFormat:@"(%.2fM)",fileSize / (1000.0 * 1000.0)];
    [self.tableView reloadData];
    
    __weak typeof (cell) weakCell = cell;
    __weak typeof  (self) weakVC = self;
    
    //点击清理缓存
    cell.myBlock = ^{
        
       [CHMBProgressHUD showSuccess:@"清理缓存成功"];
        
        //清理
        NSFileManager *fileMag = [[NSFileManager alloc]init];
        [fileMag removeItemAtPath:imageCachesPath error:nil];        
        weakCell.subTitle = @"(0.0K)";
        [weakVC.tableView reloadData];
        
    };
}

#pragma mark - UITableViewDelegate data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    MyBaseCellGroupDataMode *groupMode = self.dataArr[section];
    return groupMode.cells.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBaseCellGroupDataMode *groupMode = self.dataArr[indexPath.section];
    MyBaseCellMode *cellMode = groupMode.cells[indexPath.row];
    MyBaseCell *cell = [MyBaseCell CellWithTableView:tableView];
    cell.cellMode = cellMode;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        // 1.取出这行对应的模型
        MyBaseCellGroupDataMode *group = self.dataArr[indexPath.section];
        MyBaseCellMode *cellMode = group.cells[indexPath.row];
        
        // 2.判断有无需要跳转的控制器
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
        homeMaternityMatronVC.qcthmlType = QCHTMLTypeUserProtocol;
        [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
    }
    else
    {
        if ([cellMode isKindOfClass:[MyBaseCellArrowMode class]]) {
            
            MyBaseCellArrowMode *arrowCell = (MyBaseCellArrowMode *)cellMode;
            
            UIViewController *descVC = [[arrowCell.descVC alloc]init];
            descVC.title = cellMode.title;
            
            [self.navigationController pushViewController:descVC animated:YES];
            
        }
    }
        if (cellMode.myBlock) {
            cellMode.myBlock();
            
        }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


@end
