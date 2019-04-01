//
//  GiftCardViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "GiftCardViewController.h"
#import "Comment.h"

#import "SDCycleScrollView.h"//滚动图
#import "SDCycleScrollView+extent.h"//滚动图分类


@interface GiftCardViewController()<SDCycleScrollViewDelegate,UIScrollViewDelegate>
@property (weak,nonatomic)  UITextField *exchangeNumberTextField;

@end
@implementation GiftCardViewController
-(void)returnText:(ReturnMeMembershipCardBlock)block
{
    self.returnMeMembershipCardBlock = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
}

-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"礼品卡兑换";
    UIBarButtonItem *queryBtnItem = [UIBarButtonItem addBarBtnItemWithTItle:@"使用说明" titleColor:[UIColor whiteColor] target:self action:@selector(clickUserGiftCardBtn)];
    [queryBtnItem setBackgroundVerticalPositionAdjustment:-10.0 forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = queryBtnItem;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.y = QiCaiNavHeight;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //头部的滚滚滚滚
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, screenFrame.size.width, 153);
    NSArray *imageArray = @[@"yanglao", @"yuesao",@"peixun"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [scrollView addSubview:cycleScrollView];
    
    //中间的view
    UIView *centerView = [[UIView alloc]init];
    centerView.frame = CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame), MYScreenW, 100);
    centerView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:centerView];
    
   // 兑换账号
    UILabel *exchangeLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(QiCaiMargin * 2, QiCaiMargin * 3, 50, 30) text:@"兑换账号" textColor:QiCaiDeepColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentCenter];
    [centerView addSubview:exchangeLabel];
    
    UITextField *exchangeTextField = [UITextField addTextFieldWithFrame:CGRectMake(CGRectGetMaxX(exchangeLabel.frame) + 5, QiCaiMargin * 3, MYScreenW - CGRectGetMaxX(exchangeLabel.frame) - 5, 30) textFieldDelegate:self contentView:centerView textFieldFont:QiCai14PFFont backGroundColor:[UIColor clearColor] attributedPlaceholder:@"" palceHolderTitleColor:QiCaiNavBackGroundColor textFieldBorderColor:nil borderWidth:0];
    exchangeTextField.textColor = QiCaiNavBackGroundColor;
    exchangeTextField.text = [MYUserDefaults objectForKey:@"mob"];
    
    //请输入兑换码
    CHTextField *exchangeNumberTextField = [CHTextField addCHTextFileWithLeftImage:nil frame:CGRectMake(QiCaiMargin * 2, CGRectGetMaxY(exchangeTextField.frame) + QiCaiMargin * 2, MYScreenW - 115, 30)  placeholder:@"请输入兑换码" placeholderLabelFont:10 placeholderTextColor:QiCaiShallowColor];
    exchangeNumberTextField.cHTextFieldType = CHTextFieldTypeUnlimitedCH;
    exchangeNumberTextField.CHDelegate = self;
    exchangeNumberTextField.textColor = QiCaiShallowColor;
    exchangeNumberTextField.placeholderTextColor = QiCaiShallowColor;
    exchangeNumberTextField.placeholderLabelFont = QiCaiDetailTitle10Font;
    [centerView addSubview:exchangeNumberTextField];
    exchangeNumberTextField.textColor = QiCaiDeepColor;
    self.exchangeNumberTextField = exchangeNumberTextField;
    //right Clear
    UIButton *button = [self.exchangeNumberTextField valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"giftCardCancel"] forState:UIControlStateNormal];
    self.exchangeNumberTextField.clearButtonMode = UITextFieldViewModeAlways;

    //兑换
    UIButton *cedeemBtn = [UIButton addZhuFuBtnWithTitle:@"兑换" rect:CGRectMake(CGRectGetMaxX(exchangeNumberTextField.frame) + 9, CGRectGetMaxY(exchangeTextField.frame) + QiCaiMargin * 2, 86, 30) Target:self action:@selector(clickExchangeBtn)];
    cedeemBtn.titleLabel.font = QiCaiDetailTitle12Font;
    cedeemBtn.layer.cornerRadius = 3;
    [centerView addSubview:cedeemBtn];
    
    //底部的展示
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(centerView.frame) + 50,MYScreenW, 50);
    [scrollView addSubview:bottomView];
    
    UIButton *tel = [UIButton addButtonWithFrame:CGRectMake(0,5,MYScreenW, 25) title:@"企业级购买请联系：4000-999-001" backgroundColor:[UIColor clearColor] titleColor:QiCaiShallowColor font:QiCai10PFFont Target:self action:@selector(clickTelBtn)];
    [bottomView addSubview:tel];
    
    UIButton *timeLabel = [UIButton addButtonWithFrame:CGRectMake(0, 33, MYScreenW, 10) title:@"客服工作时间：周一至周日8:00-20:00" backgroundColor:[UIColor clearColor] titleColor:QiCaiShallowColor font:QiCai10PFFont Target:nil action:nil];
    [bottomView addSubview:timeLabel];
    
   scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ scrollView.subviews objectAtIndex:scrollView.subviews.count - 1].frame));
}

/**
 使用说明
 */
-(void)clickUserGiftCardBtn
{
    QCHTMLViewController *homeMaternityMatronVC = [[QCHTMLViewController alloc]init];
    homeMaternityMatronVC.qcthmlType = QCHTMLTypeGiftInstruction;
    [self.navigationController pushViewController:homeMaternityMatronVC animated:YES];
}
/**
 兑换
 */
-(void)clickExchangeBtn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"]= userId ;
    
    params[@"num"] = self.exchangeNumberTextField.text;
    
    //礼品卡兑换
    NSString *urlStr = [NSString stringWithFormat:@"%@/giftCardAction.do?method=convertGificard",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:urlStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0]) {
            
            [CHMBProgressHUD showSuccess:@"礼品卡兑换成功"];
            
            if (self.returnMeMembershipCardBlock != nil) {
                
                self.returnMeMembershipCardBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([responseObject[@"message"]  isEqual: @1])
        {
            [CHMBProgressHUD showFail:@"礼品卡兑换码错误"];
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            [CHMBProgressHUD showFail:@"礼品卡兑换码已使用"];
            
        }else if ([responseObject[@"message"]  isEqual: @3]){
            
            [CHMBProgressHUD showFail:@"userId空"];
        }

    } failure:^(NSError * _Nonnull error) {
        [CHMBProgressHUD showFail:@"礼品卡兑换失败"];
    }];
}

-(void)clickTelBtn
{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}

@end
