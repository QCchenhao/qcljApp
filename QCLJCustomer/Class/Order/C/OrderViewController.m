 //
//  OrderViewController.m
//  七彩乐居
//
//  Created by 李大娟 on 16/3/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "OrderViewController.h"
#import "QCTopicViewController.h"
#import "Comment.h"
#import "MyNavBar.h"

//#import "ZTTitleButton.h"
#import "ZTDropdownMenu.h"
#import "HWTitleMenuViewController.h"

#import "MyButton.h"

#define QCTitilesViewH  51.3


@interface OrderViewController ()<UIScrollViewDelegate,ZTDropdownMenuDelegate,QCTitleMenuDelegate>

@property (weak, nonatomic) UIButton *selectedButton;

@property(weak, nonatomic) UIView *bottomLine;

@property(weak, nonatomic) UIView *tagsView;

@property(weak, nonatomic) UIScrollView *contentView;

@property (strong, nonatomic) UIView *navView;

@property (nonatomic,strong) UINavigationItem * NavigationBar;

@property (nonatomic, readonly) NSInteger indexTitleMenu;//选中行数
@property (nonatomic,strong)ZTDropdownMenu *menu; //创建下拉菜单

@property (nonatomic,strong) NSArray * navTitleArr;
@end

@implementation OrderViewController
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

    [self setupUI];
}

-(void)setupUI
{
    self.navTitleArr = @[@"全部分类", @"月嫂",@"保姆",@"育儿嫂",@"家政保洁",@"企业服务",@"门店缴费"];
//    //自定义导航栏
//    [self setupNavbar];
    // 添加子控制器
    [self addChildVC];
    
    // 添加scrollView
    [self addContentView];
    
    // 添加toolbar
    [self setupTagsView];
    
    // tabbar 小红点隐藏
    [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
}
-(void)setupNavbar
{
////    //导航栏标题、字体大小颜色
//    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    
////    MyNavBar *navBar = [[MyNavBar alloc]init];
////    navBar.backgroundColor = QiCaiNavBackGroundColor;
////    navBar.frame = CGRectMake(0, 0, MYScreenW, QiCaiNavHeight);
////    navBar.titleLabel.text = @"订单";
////    [self.view addSubview:navBar];
//    
//    ZTTitleButton *titleButton = [[ZTTitleButton alloc] init];
////    titleButton.frame = CGRectMake(MYScreenW / 2 , 6, 100, 30);
//    [titleButton setTitle:@"订单" forState:UIControlStateNormal];
//    [titleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [titleButton addTarget:self action:@selector(titleClick2:) forControlEvents:UIControlEventTouchUpInside];
//
//    titleButton.backgroundColor = [UIColor yellowColor];
////    _NavigationBar = [UINavigationBar addMyNavBarWithCenterTitle:titleButton contentView:self.view];
//    
////    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    
////    self.navigationItem.titleView = titleButton;
//    self.navigationItem.titleView = titleButton;
    

    
//    [self.view addSubview:navView];
    

    
   
    
    
    //    UIView *view = [[UIApplication sharedApplication].delegate window];
    //
    //    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    //    CGRect rect=[self.view convertRect: self.view.bounds toView:window];
    
    
    
    //    _nav = [UINavigationBar addMyNavBarWithCenterTitle:@"七彩乐居" addLeft:locationBtn addRight:rightButton contentView:self.navigationController.navigationBar];
    
    
    
    // 设置导航栏标题
    //    self.navigationItem.title = @"fdsfds";
    
//    UIButton *titleButton = [[UIButton alloc] init];
    UIButton * titleButton =[UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(MYScreenW / 2 , 6, 100, 30);
    [titleButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"order_list_lower_off"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"order_list_lower_on"] forState:UIControlStateSelected];
    [titleButton.titleLabel setFont:QiCaiNavTitle14Font];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleClick2:) forControlEvents:UIControlEventTouchUpInside];

    //设置button图右文左
    [titleButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    
//    self.navigationItem.titleView = titleButton;
//    
//    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//
//    /*
//     设置导航栏左边的按钮
//     self.navigationItem.titleView 时根据左右BarButtonItem 居中
//     */
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]init];
//    //    [rightButton setBackgroundVerticalPositionAdjustment:5.0 forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.leftBarButtonItem = rightButton;
//    self.navigationItem.rightBarButtonItem = rightButton;

    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiNavHeight)];
    
    navView.backgroundColor = MYColor(228, 0, 126);
    self.navView = navView;
    //    self.navigationItem.titleView = navView;
    [self.view addSubview:navView];
    
    titleButton.centerX = CGRectGetWidth(navView.frame) / 2;
    titleButton.centerY = CGRectGetHeight(navView.frame) * 0.65;
    [self.navView addSubview:titleButton];
    
//    UIButton *titleViewBtn = [UIButton addButtonWithFrame:CGRectMake(2 * 44 , HomeNavTopY, MYScreenW - 4 * 50, 40) title:[NSString stringWithFormat:@"七彩乐居"] backgroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] font:QiCaiNavTitle14Font Target:nil action:nil];
//    [navView addSubview:titleViewBtn];
//    
//    UIButton *photoBtn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 45, HomeNavTopY +17,40,40) image:[NSString stringWithFormat:@"Main_public_telephone"] highImage:nil backgroundColor:[UIColor clearColor] Target:self action:@selector(clickPhotoBtn)];
//    photoBtn.centerY = titleViewBtn.centerY = locationBtn.centerY;
//    titleViewBtn.centerX = CGRectGetWidth(navView.frame) / 2;
//    [navView addSubview:photoBtn];
    
}

- (void)addChildVC
{
    QCTopicViewController * allVC= [[QCTopicViewController alloc]init];
    allVC.title = @"未完成";
    allVC.stateType = OrderStateNoComplete;//1、待审核
    [self addChildViewController:allVC];
    
    //0 待审核        1待接单   2 面试中  3 待付款
    QCTopicViewController * otherVC= [[QCTopicViewController alloc]init];
    otherVC.title = @"已完成";
    otherVC.stateType = OrderStateComplete;//1、待审核
    [self addChildViewController:otherVC];
    
   // 5服务中  6待雇主确定
    QCTopicViewController * completeeVC= [[QCTopicViewController alloc]init];
    completeeVC.title = @"待评价";
    completeeVC.stateType = OrderStateToEvaluate;
    [self addChildViewController:completeeVC];
    
    
    //7 已完成（待评价） 8 已评价       9已取消
    QCTopicViewController * notEvaluateVC= [[QCTopicViewController alloc]init];
    notEvaluateVC.title = @"全部";
    notEvaluateVC.stateType = OrderStateAll;
    [self addChildViewController:notEvaluateVC];
    
}


-(void)setupTagsView
{
    UIView *tagsView = [[UIView alloc]init];
    tagsView.backgroundColor = [UIColor whiteColor];
    
    //当前导航条高度
    tagsView.y = QiCaiNavHeight ;
    tagsView.height = QCTitilesViewH;
    tagsView.width = self.view.width;
    
    [self.view addSubview:tagsView];
    self.tagsView = tagsView;
    
    //下划线
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = QiCaiNavBackGroundColor;
    bottomLine.height = 1.5;
    bottomLine.y = tagsView.height - bottomLine.height;

    NSArray * buttonArrOff = @[@"list_order_tags_fork_off",@"list_order_tags_hook_off",@"list_order_tags_evaluate_off",@"list_order_tags_all_off"];
     NSArray * buttonArrOn = @[@"list_order_tags_fork_on",@"list_order_tags_hook_on",@"list_order_tags_evaluate_on",@"list_order_tags_all_on"];
    // 添加按钮
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        
        UIViewController *childVC = self.childViewControllers[i];
        
        [button setTitle:childVC.title forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateDisabled];
        button.titleLabel.font = QiCaiDetailTitle12Font;
        
        [button setImage:[UIImage imageNamed:buttonArrOff[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:buttonArrOn[i]] forState:UIControlStateDisabled];
        
        button.width = self.view.width / self.childViewControllers.count;
        button.height = tagsView.height;
        button.x = i * button.width;
        button.centerY = tagsView.height / 2;
        
        // 计算titleLabel的尺寸
        [button.titleLabel sizeToFit];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置button图上文下
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:3];
        

        [tagsView addSubview:button];
        

        if (_orderSelectedIndex) {
            // 默认第一个按钮是橘黄色
            if (tagsView.subviews.count == 2) {
                
                [self titleClick:button];
                //下划线宽度
//                bottomLine.width = button.titleLabel.width;
//                bottomLine.width = MYScreenW / buttonArrOff.count;
                self.bottomLine.width = MYScreenW / self.childViewControllers.count;
                bottomLine.centerX = button.centerX;
                
            }
        }else
        {
            // 默认第一个按钮是橘黄色
            if (tagsView.subviews.count == 1) {
                
                bottomLine.width = MYScreenW / self.childViewControllers.count;
                bottomLine.centerX = button.centerX;

                [self titleClick:button];
                //下划线宽度
//                bottomLine.width = button.titleLabel.width;
                
            }
        }
        
       
    }
    [tagsView addSubview:bottomLine];
    self.bottomLine = bottomLine;
}

-(void)addContentView
{
    // 自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds) + QiCaiNavHeight + QCTitilesViewH  , CGRectGetWidth(self.view.bounds),MYScreenH - QiCaiNavHeight - QCTitilesViewH - 40);
    contentView.delegate = self;
    
    //隐藏滚动条
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;

    // 能滚动的范围
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 1);
    contentView.pagingEnabled = YES;
    
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    
    // 添加第一个子控制器的View
    [self scrollViewDidEndScrollingAnimation:contentView];
}
// 滚动scrollView、改变下划线的位置和长度
-(void)titleClick:(UIButton *)button
{

    self.selectedButton.enabled = YES;
    
    button.enabled = NO;
   
    self.selectedButton = button;
    

    // 改变下划线的位置
    
    [UIView animateWithDuration:0.01 animations:^{
        
        // button的title字数可能不一样
//        self.bottomLine.width = button.titleLabel.width;
       self.bottomLine.width = MYScreenW / self.childViewControllers.count;
        
        self.bottomLine.centerX = button.centerX;
    }];
    
    // 滚动scrollView
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.view.width;
    self.contentView.contentOffset = offset;
    // 加载View，才会出现自动刷新
    [self scrollViewDidEndScrollingAnimation:self.contentView];
}

// 动画执行完成调用，不设置contentOffSet不调用
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 加载子视图
    int index = (scrollView.contentOffset.x / scrollView.width);
    
    QCTopicViewController *childVC = self.childViewControllers[index];
    childVC.view.x = index * scrollView.width;
    childVC.view.y = 0;// 默认是20
    if (childVC.tops) {
        [childVC.tops removeAllObjects];
    }
    [childVC.tableView.mj_header beginRefreshing];
    childVC.view.height = MYScreenH - QiCaiNavHeight ;
    childVC.view.backgroundColor = QiCaiBackGroundColor;
    
    [scrollView addSubview:childVC.view];
}

// 退拽结束(手松开调用)scrollView.contentOffset.x不确定
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动调用加载视图，不会自动调
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width; // 新特性页面
    
    // 改变bottomLine的位置
    [self titleClick:self.tagsView.subviews[index]];
}
- (void)tagClick
{
    NSLog(@"tagClick");
}
/**
 *  标题点击
 */
- (void)titleClick2:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    ZTDropdownMenu *menu = [ZTDropdownMenu menu];
    _menu = menu;
    menu.delegate = self;
    
    // 2.设置内容
    HWTitleMenuViewController *menuVc = [[HWTitleMenuViewController alloc] init];
    menuVc.titleMenuDelegate = self;
    menuVc.indexTitleMenu = self.indexTitleMenu;
    menuVc.view.width = MYScreenW;
    menuVc.view.height = 260;
    menuVc.titleArr = self.navTitleArr;
    menu.contentController = menuVc;
    
    // 3.显示
    [menu showFrom:titleButton];
}
#pragma mark - ZTDropdownMenuDelegate
- (void)dropdownMenuDidShow:(ZTDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}

- (void)dropdownMenuDidDismiss:(ZTDropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}
//传递参数
-(void)ClickBtnTitleMenuBtn:(NSInteger )btn{
    _indexTitleMenu = btn;
    
    //改变状态删除弹窗
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
    [_menu removeFromSuperview];
  
    [titleButton setTitle:self.navTitleArr[btn] forState:UIControlStateNormal];
    
    //设置button图右文左
    [titleButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    
    //判断视图是否创建，防止第一次tabber进来刷新报错
    if (self.childViewControllers.count < 2) {
        return ;
    }
    // 加载子视图
    int index = (self.contentView.contentOffset.x / self.contentView.width);
    
    QCTopicViewController *childVC = self.childViewControllers[index];
    
    switch (btn) {
        case 0:
            childVC.orderType = OrderAlltype;/**全部**/
            break;
        case 1:
            childVC.orderType = OrderMaternityMatron;/**月嫂**/
            break;
        case 2:
            childVC.orderType = OrderNammy; /**保姆**/
            break;
        case 3:
            childVC.orderType = OrderPaorental;/**育儿嫂**/
            break;
        case 4:
            childVC.orderType = OrderPackage;/**家政套餐**/
            break;
        case 5:
            childVC.orderType = OrderEnterpriseService;/**企业服务**/
            break;
        case 6:
            childVC.orderType = OrderStorePayment;/**门店缴费**/
            break;
        default:
            break;
    }

    [childVC orderRefresh];
//    [self.contentView addSubview:childVC.view];
    
}
@end
