//
//  MembershipCardAccountInquiryVViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MembershipCardAccountInquiryVViewController.h"
#import "Comment.h"
#import "MembershipAccountTableView.h"//账户查询的cell的tableview
#import "HMDatePickView.h"//时间选择器

#define kDateBtnWidth 94

@interface MembershipCardAccountInquiryVViewController()<UIScrollViewDelegate>
@property(weak, nonatomic) UIScrollView *contentView;
@property(weak, nonatomic) UIView *bottomLine;
@property(weak, nonatomic) UIView *tagsView;
@property (weak, nonatomic) UIButton *selectedButton;

@property (strong,nonatomic)  UIButton *dateLeftBtn;
@property (strong,nonatomic)  UIButton *dateRightBtn;
@property (assign, nonatomic)  BOOL  isShow;//服务时长弹窗显示

@end

@implementation MembershipCardAccountInquiryVViewController
//重写loadView 使键盘上移导航栏不随着上移
-(void)loadView
{
    [super loadView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [self setupUI];
    
}

-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"账户查询";
    
    // 添加子控制器
    [self addChildVC];
    
    // 添加scrollView
    [self addContentView];
    
    // 添加toolbar
    [self setupTagsView];
    
    //添加搜索类的view
    [self addSearchView];
    
}
-(void)addSearchView
{
    UIView *searchView = [[UIView alloc]init];
    searchView.frame = CGRectMake(0, CGRectGetMaxY(self.tagsView.frame), MYScreenW, 50);
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];

    //左边的框
    self.dateLeftBtn = [UIButton addButtonWithFrame:CGRectMake(QiCaiMargin * 2, 14 , kDateBtnWidth, 30) ButtonTitle:nil titleColor:QiCaiDeepColor titleFont:QiCaiDetailTitle12Font borderColor:QiCaiBackGroundColor backGroundColor:[UIColor whiteColor] Target:self action:@selector(clickDateBtn:) btnCornerRadius:3];
    self.dateLeftBtn.tag = 0;
    [searchView addSubview:self.dateLeftBtn];
    
    //中间的字
    UILabel *centerLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(CGRectGetMaxX(self.dateLeftBtn.frame), 14 , 30, 30) text:@"至" textColor:QiCaiDeepColor backgroundColor:[UIColor whiteColor] size:10 textAlignment:NSTextAlignmentCenter];
    [searchView addSubview:centerLabel];
    
    //右边的框
    self.dateRightBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(centerLabel.frame) , 14 , kDateBtnWidth, 30) ButtonTitle:nil titleColor:QiCaiDeepColor titleFont:QiCaiDetailTitle12Font borderColor:QiCaiBackGroundColor backGroundColor:[UIColor whiteColor] Target:self action:@selector(clickDateBtn:) btnCornerRadius:3];
    self.dateRightBtn.tag = 1;
    [searchView addSubview:self.dateRightBtn];
    
    //右边的搜索
    UIButton *searchBtn = [UIButton addZhuFuBtnWithTitle:@"搜索" rect:CGRectMake(CGRectGetMaxX(self.dateRightBtn.frame) + 9, 14 , MYScreenW - CGRectGetMaxX(self.dateRightBtn.frame) - 20, 30) Target:self action:@selector(clickSearchBtn)];
    searchBtn.titleLabel.font = QiCaiDetailTitle12Font;
    searchBtn.layer.cornerRadius = 3;
    [searchView addSubview:searchBtn];

}
- (void)addChildVC
{
    //充值记录
    MembershipAccountTableView *rechargeVC= [[MembershipAccountTableView alloc]init];
    rechargeVC.title = @"充值记录";
    rechargeVC.stateType = @"99";
    [self addChildViewController:rechargeVC];
    
    //消费记录
    MembershipAccountTableView *consumptionVC= [[MembershipAccountTableView alloc]init];
    consumptionVC.title = @"消费记录";//待发货
    consumptionVC.stateType = @"68";
    [self addChildViewController:consumptionVC];
}
-(void)addContentView
{
    // 自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    CGFloat contentViewY = QiCaiNavHeight + 44 + 50;
    contentView.frame = CGRectMake(CGRectGetMinX(self.view.bounds),contentViewY, CGRectGetWidth(self.view.bounds),MYScreenH - contentViewY);
    contentView.delegate = self;
    // 能滚动的范围
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 1);
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    
    // 添加第一个子控制器的View
    [self scrollViewDidEndScrollingAnimation:contentView];
}
-(void)setupTagsView
{
    UIView *tagsView = [[UIView alloc]init];
    tagsView.backgroundColor = [UIColor whiteColor];
    
    //当前导航条高度
    tagsView.y = QiCaiNavHeight;
    tagsView.height = 44;
    tagsView.width = self.view.width;
    [self.view addSubview:tagsView];
    self.tagsView = tagsView;
    
    //不动的下划线
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = QiCaiBackGroundColor;
    line.frame = CGRectMake(0, tagsView.height - 1, MYScreenW, 1);
    
    // 下划线
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = QiCaiNavBackGroundColor;
    bottomLine.height = 2;
    bottomLine.y = tagsView.height - bottomLine.height - 1;
    self.bottomLine = bottomLine;

    // 添加按钮
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        
        UIViewController *childVC = self.childViewControllers[i];
        
        [button setTitle:childVC.title forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateDisabled];
        button.titleLabel.font = QiCaiDetailTitle12Font;
        
        button.width = self.view.width / self.childViewControllers.count;
        button.height = tagsView.height;
        button.x = i * button.width;
        
        // 计算titleLabel的尺寸
        [button.titleLabel sizeToFit];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagsView addSubview:button];
        
        
        // 默认第一个按钮是橘黄色
        if (tagsView.subviews.count == 1) {
            
            
            [self titleClick:button];
            //下划线宽度
            bottomLine.width = self.view.width / self.childViewControllers.count;
            bottomLine.centerX = button.centerX;
        }
    }
    
    //中间的分割线
    UIView *centerLine = [[UIView alloc]init];
    centerLine.backgroundColor = QiCaiBackGroundColor;
    centerLine.frame = CGRectMake(MYScreenW / 2, 5, 1, 44 - 10);
    
    [tagsView addSubview:bottomLine];
    [tagsView addSubview:line];
    [tagsView addSubview:centerLine];
}
// 滚动scrollView、改变下划线的位置和长度
-(void)titleClick:(UIButton *)button
{
//    //移除原来的时间，并重新搜索记录
//    self.dateLeftBtn.titleLabel.text = @"";
//    self.dateRightBtn.titleLabel.text = @"";
    
//    int index = (self.contentView.contentOffset.x / self.contentView.width);
//    MembershipAccountTableView *consumptionVC = self.childViewControllers[index];
//    [consumptionVC retrievalLaodMoreTopicToMin:self.dateLeftBtn.titleLabel.text max:self.dateRightBtn.titleLabel.text];
    
    
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 改变下划线的位置
    [UIView animateWithDuration:0.01 animations:^{
        
        // button的title字数可能不一样
        //下划线滑动后的长度
        self.bottomLine.width = self.view.width / self.childViewControllers.count;
        
        self.bottomLine.centerX = button.centerX;
    }];
    
    // 滚动scrollView
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.view.width;
    self.contentView.contentOffset = offset;
    // 加载View，才会出现自动刷新
    [self scrollViewDidEndScrollingAnimation:self.contentView];
    //    NSLog(@"zhuan-----%ld",button.tag);
    
}

// 动画执行完成调用，不设置contentOffSet不调用
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 加载子视图
    
    int index = (scrollView.contentOffset.x / scrollView.width);
    
    //移除原来的时间，并重新搜索记录
    self.dateLeftBtn.titleLabel.text = nil;
    self.dateRightBtn.titleLabel.text = nil;
    
    [self.dateLeftBtn setTitle:nil forState:UIControlStateNormal];
    [self.dateRightBtn setTitle:nil forState:UIControlStateNormal];
    
    MembershipAccountTableView *childVC = self.childViewControllers[index];
    [childVC.tableView.mj_header beginRefreshing];
    childVC.view.x = index * scrollView.width;
    childVC.view.y = 0;// 默认是20
    childVC.view.height = MYScreenH - 44 - 30;
    childVC.view.backgroundColor = QiCaiBackGroundColor;
    
    [scrollView addSubview:childVC.view];
}

// 退拽结束(手松开调用)scrollView.contentOffset.x不确定
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动调用加载视图，不会自动调
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSLog(@"%f     /    %f ",scrollView.contentOffset.x,scrollView.width);
    NSInteger index = scrollView.contentOffset.x / scrollView.width; // 新特性页面
    
    // 改变bottomLine的位置
    [self titleClick:self.tagsView.subviews[index]];
}

#pragma mark -- 顶部的搜索
-(void)clickDateBtn:(UIButton *)btn
{
    
//    self.dateLeftBtn
//    //右边的框
//    self.dateRightBtn
    
    
    self.isShow = NO;
    
    /** 自定义日期选择器 */
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.view.frame];
    if (btn.tag == 0) {//左边
        //距离当前日期的年份差（设置最大可选日期）
        datePickVC.maxYear = 0;
        //设置最小可选日期(年分差)
        datePickVC.minYear = 10;
    }else{//右边
        //距离当前日期的年份差（设置最大可选日期）
        datePickVC.maxYear = 0;
        //设置最小可选日期(年分差)
        datePickVC.minYear = 10;
    }
    
    //    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor =  QiCaiNavBackGroundColor;
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
        
        if (btn == self.dateLeftBtn) {
            VDLog(@"%@",self.dateRightBtn.titleLabel.text);
            VDLog(@"%@",self.dateLeftBtn.titleLabel.text);
            
            if (self.dateRightBtn.titleLabel.text.length > 0) {
                int index = [self compareDate:self.dateRightBtn.titleLabel.text withDate:selectDate];
                if (index == -1 || index == 0) {
                    [self.dateLeftBtn setTitle:selectDate forState:UIControlStateNormal];
                }else{
                    [CHMBProgressHUD showPrompt:@"您选择的时间已超出"];
                    return;
                }
            }else{
                [self.dateLeftBtn setTitle:selectDate forState:UIControlStateNormal];
            }
        }else{
            if (self.dateLeftBtn.titleLabel.text.length > 0) {
                int index = [self compareDate:selectDate withDate:self.dateLeftBtn.titleLabel.text];
                if (index == -1 || index == 0) {
                    [self.dateRightBtn setTitle:selectDate forState:UIControlStateNormal];
                }else{
                    [CHMBProgressHUD showPrompt:@"您选择的时间已超出"];
                    return;
                }
            }else{
                [self.dateRightBtn setTitle:selectDate forState:UIControlStateNormal];
            }
        }

        
//        if (btn == self.dateLeftBtn) {
//            [self.dateLeftBtn setTitle:selectDate forState:UIControlStateNormal];
//        }else if (btn == self.dateRightBtn){
//            [self.dateRightBtn setTitle:selectDate forState:UIControlStateNormal];
//        }
        
//        [self.dateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                                      imageTitleSpace:13];
//        self.homeDateStr = selectDate;
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
}
/**
 *  两个时间比较大小
 *
 *  @param date01 时间1
 *  @param date02 时间1
 *
 *  @return 
  1  date02比date01大
  -1 date02比date01小
  0  date02=date01
 */
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

-(void)clickSearchBtn
{
    int index = (self.contentView.contentOffset.x / self.contentView.width);
    if (!self.dateLeftBtn.titleLabel.text.length) {
        [CHMBProgressHUD showFail:@"请选择开始时间"];
    }else if (!self.dateRightBtn.titleLabel.text.length)
    {
        [CHMBProgressHUD showFail:@"请选择结束时间"];

    }else
    {
        MembershipAccountTableView *consumptionVC = self.childViewControllers[index];
        [consumptionVC retrievalLaodMoreTopicToMin:self.dateLeftBtn.titleLabel.text max:self.dateRightBtn.titleLabel.text];
    }
    
}

@end
