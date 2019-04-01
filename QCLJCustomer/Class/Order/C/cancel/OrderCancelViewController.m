//
//  OrderCancelViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/15.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "OrderCancelViewController.h"
#import "Comment.h"
#import "MyTextView.h"
#import "AppDelegate.h"

//#import "NSMutableDictionary+Extension.h"//加密
#import "MD5.h"//加密md5

@interface OrderCancelViewController()<UIScrollViewDelegate,UITextViewDelegate>
//@property (weak,nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  NSArray *dataArr;
//@property (strong,nonatomic)  UIButton *lastBtn;
@property (strong, nonatomic)  MyTextView *textView;
//@property (nonatomic,strong) NSMutableArray * selectedArr;

@end
@implementation OrderCancelViewController
- (void)returnOrderList:(ReturnOrderBlock)block{
    self.returnOrderBlock = block;
}
-(NSArray *)dataArr
{
    if (!_dataArr) {
        NSArray *arr = @[@"价格太高了",@"暂时不需要了",@"对匹配不满意",@"对客服顾问不满意"];
        _dataArr = arr;
        
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [self setupUI];
    
}
-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"订单取消";
    
//    UIScrollView *scrollView = [[UIScrollView alloc]init];
//    scrollView.frame = CGRectMake(0,QiCaiNavHeight + QiCaiMargin, MYScreenW, MYScreenH - QiCaiNavHeight);
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    [scrollView setBackgroundColor:QiCaiBackGroundColor];
//    scrollView.delegate = self;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    
    UILabel *tipLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, 0, MYScreenW, 38) text:@"请告知您的取消原因，我们会持续改进！" textColor:QiCaiDeepColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview: tipLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = QiCaiBackGroundColor;
    line.frame = CGRectMake(0,CGRectGetMaxY(tipLabel.frame), MYScreenW, 1);
    [self.scrollView addSubview:line];
    
    //下面的 用来装下面的控件
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), MYScreenW, 200);
    [self.scrollView addSubview:bottomView];
    
    CGFloat labelH = 44;
    
    for (int i = 0; i < self.dataArr.count; i ++) {
        //文字
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(QiCaiMargin * 2, i * labelH, MYScreenW - QiCaiMargin * 2, labelH - 1);
        label.textColor = QiCaiDeepColor;
        label.font = QiCai12PFFont;
        label.backgroundColor = [UIColor whiteColor];
        label.text = self.dataArr[i];
        [bottomView addSubview:label];
        
        //按钮
        UIButton *btn = [UIButton addButtonWithFrame:CGRectMake(MYScreenW - 31, i * labelH + 9.5, 21 , 21) image:@"order_cancel_off" highImage:@"order_cancel_on" backgroundColor:[UIColor clearColor] Target:self action:@selector(clickCancelTitleBtn:)];
        [btn setImage:[UIImage imageNamed:@"order_cancel_on"] forState:UIControlStateSelected];
        btn.tag = i;
        [bottomView addSubview:btn];
        if (i == 0) {
            btn.selected = YES;
            
            self.lastBtn = btn;
            NSString * temp = self.dataArr[i];
            [self.lastBtn setTitle:temp forState:UIControlStateNormal];
//            [self.selectedArr addObject:self.dataArr[btn.tag]];
        }

        //line
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = QiCaiBackGroundColor;
        line.frame = CGRectMake(0, CGRectGetMaxY(label.frame), MYScreenW, 1);
        [bottomView addSubview:line];
    }
    
    //背景的view
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(13,labelH * self.dataArr.count + 13, MYScreenW - 2 * 13, 115)];
    backgroundView.layer.borderColor =  QiCaiBackGroundColor.CGColor;
    backgroundView.layer.borderWidth = 1.0;
    backgroundView.layer.cornerRadius = 5;
    backgroundView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:backgroundView];
    
    //输入框的图片
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.image = [UIImage imageNamed:@"me_feedBack_write"];
    iconImageView.frame = CGRectMake(QiCaiMargin, QiCaiMargin, 26, 26);
    [backgroundView addSubview:iconImageView];
    
    CGFloat myTextWidth = backgroundView.width - CGRectGetMaxX(iconImageView.frame) - QiCaiMargin * 2;
    MyTextView *myTextView = [[MyTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame), 0, myTextWidth, 115)];
    // 滚动textView,出发方法，里面退下键盘
    myTextView.delegate = self;
    myTextView.placeHoledr = @"请输入您的取消意见(50字内)";
    myTextView.placeHoledrColor = QiCaiShallowColor;
    [backgroundView addSubview:myTextView];
    self.textView = myTextView;

    bottomView.height = CGRectGetMaxY(backgroundView.frame) + 13;
    
    //scrollview的滚动
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ self.scrollView.subviews objectAtIndex:self.scrollView.subviews.count - 1].frame) );
    
    //提交btn
    UIButton *summitBtn = [UIButton addButtonWithFrame:CGRectMake(0, MYScreenH - 43, MYScreenW, 43) title:@"确认取消" backgroundColor:QiCaiNavBackGroundColor titleColor:[UIColor whiteColor] font:QiCai12PFFont Target:self action:@selector(clickSummitBtn)];
    [self.view addSubview:summitBtn];
    
}
-(void)clickCancelTitleBtn:(UIButton *)btn
{
    if (btn == self.lastBtn) {
        self.lastBtn.selected = YES;
        NSString * temp = self.dataArr[btn.tag];
        [self.lastBtn setTitle:temp forState:UIControlStateNormal];

    }
    else if (btn != self.lastBtn)
    {
        btn.selected = YES;
        NSString * temp = self.dataArr[btn.tag];
        [btn setTitle:temp forState:UIControlStateNormal];
        self.lastBtn.selected = NO;
        self.lastBtn = btn;
    }
//     btn.selected = !btn.selected;
//    
//    if (btn.selected == YES) {
//        [self.selectedArr addObject:self.dataArr[btn.tag]];
//    }else{
//        [self.selectedArr removeObjectAtIndex:btn.tag];
//    }
}
-(void)clickSummitBtn
{
    
    NSLog(@"选择的内容%@－－－输入的内容%@",self.dataArr[self.lastBtn.tag],_textView.text);
    
    if(MYAppDelegate.isNetworkState == YES){// 没有网络
        [CHMBProgressHUD showPrompt:@"暂无网络"];
    }else{
        //意见反馈
        [self orderFeedback];
    }

   

    
}
/**
 *  取消订单
 */
- (void)orderCancel{
    NSString * URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=clientCancelOrder",kQICAIHttp];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    params[@"userId"] = userId;
    params[@"orderId"] = self.orderModel.orderId;
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"]  isEqual: @3]) {
            VDLog(@"状态错误 不可取消");
            [CHMBProgressHUD showFail:@"状态错误 不可取消"];
        }else if ([responseObject[@"message"]  isEqual: @0])
        {
            /**
             *  block回调
             */
            __weak typeof(self) weakSelf = self;
            if (weakSelf.returnOrderBlock != nil) {
                weakSelf.returnOrderBlock();
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            [CHMBProgressHUD showSuccess:@"取消订单成功"];
            VDLog(@"取消成功11232132");
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            VDLog(@"参数错误");
            [CHMBProgressHUD showFail:@"参数错误"];
        }

    } failure:nil];
    
}
- (void)orderFeedback{
    
    NSLog(@"选择的内容%@－－－输入的内容%@",self.dataArr[self.lastBtn.tag],_textView.text);
//    NSString *string = [self.selectedArr componentsJoinedByString:@","];
    
    if(MYAppDelegate.isNetworkState == YES){// 没有网络

        //给出提示
        [CHMBProgressHUD showPrompt:@"暂无网络"];
        return;
        
    }else{  // 有网络
        NSString *string = self.lastBtn.titleLabel.text;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *userId = [MYUserDefaults objectForKey:@"userId"];
        
        //    if (self.textView.text.length > 0 ) {
        if (self.textView.text.length < 50) {
            NSString * temp = [NSString stringWithFormat:@"%@,%@",string,self.textView.text];
            params[@"content"] = temp;
        }else{
            VDLog(@"评论内容大于50字");
            [CHMBProgressHUD showPrompt:@"评论内容大于50字"];
        }
        
        //    }else{
        //        VDLog(@"评论为空");
        //        [CHMBProgressHUD showPrompt:@"请输入评论"];
        //        return;
        //    }
        params[@"type"] = @"0";//类型 0 取消订单  1.0 从C端来的意见反馈 1.1 阿姨端来的意见反馈  1.2 从经销商端的意见反馈  2 对订单的投诉
        params[@"orderId"] = self.orderModel.orderId;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/feedbackAction.do?method=saveFeedback&userId=%@",kQICAIHttp,userId];
        params[@"userId"] = userId;
        
//        //加密
//        [NSMutableDictionary addParamsClientTimeAndTokenTo:params];

        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
        long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
        NSString *clientTime = [NSString stringWithFormat:@"%llu",theTime];
        //加密
        NSString *token = [MD5 md5:[NSString stringWithFormat:@"%@%@",MD5Password,clientTime]];;
        
        NSString * md5_url_Str = [NSString stringWithFormat:@"%@&clientTime=%@&token=%@",urlStr,clientTime,token];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //接收类型不一致请替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        
        
        [manager POST:md5_url_Str parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印下上传进度
            CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"%.2lf%%", progress);
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //上传成功
            VDLog(@"上传成功：%@",responseObject);

            if ([responseObject[@"message"]  isEqual: @0]) {
                VDLog(@"成功");
                [self orderCancel];
                //
            }else if ([responseObject[@"message"]  isEqual: @1]) {
                VDLog(@"图片太大");
            }else if ([responseObject[@"message"]  isEqual: @3]) {
                VDLog(@"参数错误");
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            //上传失败
            VDLog(@"上传失败：%@",error);
            [CHMBProgressHUD showFail:@"提交失败，请稍后重试"];
        }];

    }
    
}

@end
