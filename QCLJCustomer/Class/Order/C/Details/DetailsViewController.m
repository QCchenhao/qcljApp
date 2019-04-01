//
//  DetailsViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "DetailsViewController.h"

#import "DetailsStatusInSubmissionViewController.h"//订单提交 上门中
#import "DetailsStatusPayYesAndNoViewController.h"//待付款 已付款
#import "DetailsStatusInServiceViewController.h"//服务中
#import "DetailsStatusEvaluateViewController.h"//评价
#import "DetailsStatuscancelViewController.h"//取消

@interface DetailsViewController ()

//@property (nonatomic, copy) NSString *stateStr;//订单状态

@end

@implementation DetailsViewController
- (void)returnOrderList:(ReturnOrderBlock)block{
    self.returnOrderBlock = block;
}
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
    self.navigationItem.title = @"预约结果";
     // 添加子控制器
    [self addChildVC];
    [self AFN];
//    [self setUpUI];
}
- (void)AFN{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params addParamsClientTimeAndTokenTo:params];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];

    params[@"userId"] = userId;

    params[@"orderId"] = self.orderModel.orderId;
    NSString * URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=getDetailOrder",kQICAIHttp];

    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        
        NSLog(@"成功 ＝＝＝%@",responseObject);
        
        if ([responseObject[@"message"]  isEqual: @4]) {
            
            
            VDLog(@"重新登录");
            
            
        }else if ([responseObject[@"message"]  isEqual: @0])
        {
            
            DetailsModel * mode = [DetailsModel mj_objectWithKeyValues:responseObject];
            
            NSLog(@"%ld",(long)mode.state);
            NSInteger index;
            
            switch (mode.state) {
                case 0:
                    self.stateStr = @"未审核";
                    index = 1;
                    break;
                case 1:
                    self.stateStr = @"未接单";
                    index = 2;
                    break;
                case 2:
                    self.stateStr = @"面试中";
                    index = 3;
                    break;
                case 3:
                    self.stateStr = @"待付款";
                    index = 4;
                    break;
                case 4:
                    self.stateStr = @"待上门服务";
                    break;
                case 5:
                    self.stateStr = @"服务中";
                    break;
                case 6:
                    self.stateStr = @"待雇主确认";
                    break;
                case 7:
                    self.stateStr = @"待评价";
                    break;
                case 8:
                    self.stateStr = @"已评价";
                    break;
                case 9:
                    self.stateStr = @"已取消";
                    break;
                case 10:
                    self.stateStr = @"重新分配阿姨";
                    break;
                case 11:
                    self.stateStr = @"已付定金";
                    break;
                    
                default:
                    self.stateStr = @"进行中";
                    break;
            }
            if (mode.state == 0 || mode.state == 1 || mode.state == 2) {//1、提交订单   面试中
                DetailsStatusInSubmissionViewController *childVC = self.childViewControllers[0];
                /**
                 *  block回调
                 */
                __weak typeof(self) weakSelf = self;
                [childVC returnOrderList:^{
                    if (weakSelf.returnOrderBlock != nil) {
                        weakSelf.returnOrderBlock();
                    }
                }];
                childVC.detailsModel = mode;
                childVC.detailsModel.orderId = self.orderModel.orderId;
                childVC.orderModel = self.orderModel;
                childVC.stateStr = self.stateStr;//订单状态
                childVC.view.frame = self.view.frame;
                childVC.view.backgroundColor = QiCaiBackGroundColor;
                
                [self.view addSubview:childVC.view];
            }else if (mode.state == 3){//待付款
                
                DetailsStatusPayYesAndNoViewController *childVC = self.childViewControllers[1];
                /**
                 *  block回调
                 */
                __weak typeof(self) weakSelf = self;
                [childVC returnOrderList:^{
                    if (weakSelf.returnOrderBlock != nil) {
                        weakSelf.returnOrderBlock();
                    }
                }];
                childVC.detailsModel = mode;
                childVC.detailsModel.orderId = self.orderModel.orderId;
                childVC.orderModel = self.orderModel;
                childVC.stateStr = self.stateStr;//订单状态
                childVC.view.frame = self.view.frame;
                childVC.view.backgroundColor = QiCaiBackGroundColor;
                [self.view addSubview:childVC.view];
            }else if (  mode.state == 4 || mode.state == 5 || mode.state == 6 || mode.state == 10){//服务中
                
                DetailsStatusInServiceViewController *childVC = self.childViewControllers[2];
                /**
                 *  block回调
                 */
                __weak typeof(self) weakSelf = self;
                [childVC returnOrderList:^{
                    if (weakSelf.returnOrderBlock != nil) {
                        weakSelf.returnOrderBlock();
                    }
                }];
                childVC.detailsModel = mode;
                childVC.detailsModel.orderId = self.orderModel.orderId;
                childVC.orderModel = self.orderModel;
                childVC.stateStr = self.stateStr;//订单状态
                childVC.view.frame = self.view.frame;
                childVC.view.backgroundColor = QiCaiBackGroundColor;
                [self.view addSubview:childVC.view];
            }else if (mode.state == 7 || mode.state == 8 ){//评价
                
                DetailsStatusEvaluateViewController *childVC = self.childViewControllers[3];
                /**
                 *  block回调
                 */
                __weak typeof(self) weakSelf = self;
                [childVC returnOrderList:^{
                    if (weakSelf.returnOrderBlock != nil) {
                        weakSelf.returnOrderBlock();
                    }
                }];
                childVC.detailsModel = mode;
                childVC.detailsModel.orderId = self.orderModel.orderId;
                childVC.orderModel = self.orderModel;
                childVC.stateStr = self.stateStr;//订单状态
                childVC.view.frame = self.view.frame;
                childVC.view.backgroundColor = QiCaiBackGroundColor;
                [self.view addSubview:childVC.view];
            }else if (mode.state == 9){//取消
                
                DetailsStatuscancelViewController *childVC = self.childViewControllers[4];
                
                childVC.detailsModel = mode;
                childVC.detailsModel.orderId = self.orderModel.orderId;
                childVC.orderModel = self.orderModel;
                childVC.stateStr = self.stateStr;//订单状态
                childVC.view.frame = self.view.frame;
                childVC.view.backgroundColor = QiCaiBackGroundColor;
                [self.view addSubview:childVC.view];
            }
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            //            _superiorId = @"0";
            [self showNotInternetViewToAbnormalState:AbnormalStateNoDataNo message1:nil message2:nil];
        }
    } failure:nil];
    
}
- (void)addChildVC
{
    DetailsStatusInSubmissionViewController * allVC= [[DetailsStatusInSubmissionViewController alloc]init];
    allVC.title = @"待审核 面试中";
    [self addChildViewController:allVC];
    
    DetailsStatusPayYesAndNoViewController * twoVC= [[DetailsStatusPayYesAndNoViewController alloc]init];
    twoVC.title = @"待付款 已付款";
    [self addChildViewController:twoVC];
    
    DetailsStatusInServiceViewController * fourVC= [[DetailsStatusInServiceViewController alloc]init];
    fourVC.title = @"进行中";
    [self addChildViewController:fourVC];
    
    DetailsStatusEvaluateViewController * fiveVC= [[DetailsStatusEvaluateViewController alloc]init];
    fiveVC.title = @"评价";
    [self addChildViewController:fiveVC];
    
    DetailsStatuscancelViewController * sisVC= [[DetailsStatuscancelViewController alloc]init];
    sisVC.title = @"取消";
    [self addChildViewController:sisVC];

}
@end
