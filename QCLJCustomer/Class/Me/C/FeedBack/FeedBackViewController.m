//
//  FeedBackViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Comment.h"
#import "MyTextView.h"

/*====
 图片选择器
 ===*/
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIButton+WebCache.h"

#import "AppDelegate.h"

//#import "NSMutableDictionary+Extension.h"//加密
#import "MD5.h"//加密md5

@interface FeedBackViewController()<UIScrollViewDelegate,UITextViewDelegate>
@property (weak,nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  MyTextView *textView;

//添加图片
@property (nonatomic , strong) NSMutableArray *assets;
@property (strong,nonatomic) UIScrollView * imageScrollView;
@property (weak,nonatomic)  UIButton *summitBtn;

@end
@implementation FeedBackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    if (!self.type) {
        self.type = @"1.0";//设置默认为雇主端意见反馈
    }
    
    [self setupUI];
    
    // 九宫格创建ScrollView
    [self reloadScrollView];
    
}
- (UIScrollView *)imageScrollView{
    
    if (!_imageScrollView) {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.frame = CGRectMake(0, QiCaiNavHeight, self.view.frame.size.width, self.view.frame.size.height * 0.15);
        _imageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.scrollView addSubview:_imageScrollView];
    }
    return _imageScrollView;
}
-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"me_feedBack_tel" action:@selector(clickTelBtn) target:self];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.y = QiCaiNavHeight + QiCaiMargin;
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    UILabel *tipLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(0, 0, MYScreenW, 38) text:@"告诉我们您的反馈意见，我们会改进更快呀！" textColor:QiCaiDeepColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentCenter];
    [scrollView addSubview: tipLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = QiCaiBackGroundColor;
    line.frame = CGRectMake(0,CGRectGetMaxY(tipLabel.frame), MYScreenW, 1);
    [scrollView addSubview:line];
    
    //背景的view
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(13,CGRectGetMaxY(line.frame) + 13, MYScreenW - 2 * 13, 115)];
    backgroundView.layer.borderColor =  QiCaiBackGroundColor.CGColor;
    backgroundView.layer.borderWidth = 1.0;
    backgroundView.layer.cornerRadius = 5;
    [scrollView addSubview:backgroundView];
    
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
    
    //上传照片
    UILabel *pagramLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(QiCaiMargin * 2, CGRectGetMaxY(backgroundView.frame) + QiCaiMargin, MYScreenW, 38) text:@"上传照片" textColor:QiCaiDeepColor backgroundColor:[UIColor whiteColor] size:12 textAlignment:NSTextAlignmentLeft];
    [scrollView addSubview: pagramLabel];
    
//    UIView
    //添加相册
    self.imageScrollView.frame = CGRectMake(QiCaiMargin, CGRectGetMaxY(pagramLabel.frame) + QiCaiMargin, self.view.frame.size.width, self.view.frame.size.height * 0.12);
    [scrollView addSubview:self.imageScrollView];
    
    
    //提交btn
    UIButton *summitBtn = [UIButton addButtonWithFrame:CGRectMake(QiCaiMargin * 2, CGRectGetMaxY(self.imageScrollView.frame) + QiCaiMargin, MYScreenW - QiCaiMargin * 4, 35) title:@"提交宝贵意见" backgroundColor:QiCaiNavBackGroundColor titleColor:[UIColor whiteColor] font:QiCai12PFFont Target:self action:@selector(clickSummitBtn)];
    summitBtn.layer.cornerRadius = 17.5;
    [scrollView addSubview:summitBtn];
    self.summitBtn = summitBtn;
    
}
/**
 提交宝贵意见
 */
-(void)clickSummitBtn
{

    if(MYAppDelegate.isNetworkState == YES){// 没有网络
        //给出提示
        [CHMBProgressHUD showPrompt:@"暂无网络"];
        return;
    }else{  // 有网络
        
        //图片
        NSMutableArray * arrty = [NSMutableArray array];
        
        for (NSInteger i = 0; i < self.assets.count; i++) {
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                
                UIImage * image = [self.assets[i] originImage];
                
                //           image = PostImage();
                //上传的图片转化二进制
                NSData * imageData = UIImageJPEGRepresentation(image ,0.00001);
                
                [arrty addObject:imageData];
                
            }else if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLCamera class]]){
                UIImage * image = [self.assets[i] photoImage];
                NSData * imageData = UIImageJPEGRepresentation(image,0.00001);
                [arrty addObject:imageData];
            }else if ([[self.assets objectAtIndex:i] isKindOfClass:[NSString class]]){
                
                UIImage * image = [self.assets[i] originImage];
                NSData * imageData = UIImageJPEGRepresentation(image,0.00001);
                [arrty addObject:imageData];
            }
        }
        
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *userId = [MYUserDefaults objectForKey:@"userId"];
        
        if (self.textView.text.length > 0 ) {
            if (self.textView.text.length < 50) {
                params[@"content"] = self.textView.text
                ;
            }else{
                VDLog(@"评论内容大于50字");
                [CHMBProgressHUD showPrompt:@"评论内容大于50字"];
            }
            
        }else{
            VDLog(@"评论为空");
            [CHMBProgressHUD showPrompt:@"请输入评论"];
            return;
        }
        params[@"type"] = self.type;//类型 0 取消订单  1.0 从C端来的意见反馈 1.1 阿姨端来的意见反馈  1.2 从经销商端的意见反馈  2 对订单的投诉
        if (self.orderID) {
            params[@"orderId"] = self.orderID;
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@/feedbackAction.do?method=saveFeedback&userId=%@",kQICAIHttp,userId];
        params[@"userId"] = userId;
        
//        params[@"orderId"] = self.orderModel.orderId;
        
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
            
            for (NSInteger i = 0; i < arrty.count; i++) {
                
                //            NSData *imageData =UIImageJPEGRepresentation(arrty[i],1);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                
                //上传的参数(上传图片，以文件流的格式)
                [formData appendPartWithFileData:arrty[i]
                                            name:@"uploadImage"
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
                
            }
            
            
        } progress:^(NSProgress *_Nonnull uploadProgress) {
            //打印下上传进度
            CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSLog(@"%.2lf%%", progress);
        } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            //上传成功
            VDLog(@"上传成功：%@",responseObject);
            if ([responseObject[@"message"]  isEqual: @0]) {
                VDLog(@"成功");
                [CHMBProgressHUD showSuccess:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([responseObject[@"message"]  isEqual: @1]) {
                VDLog(@"图片太大");
                [CHMBProgressHUD showPrompt:@"图片太大"];
            }else if ([responseObject[@"message"]  isEqual: @3]) {
                VDLog(@"参数错误");
                [CHMBProgressHUD showFail:@"参数错误"];
            }
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            //上传失败
            VDLog(@"上传失败：%@",error);
            [CHMBProgressHUD showFail:@"提交失败，请稍后重试"];
        }];

    }
    
}
- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.imageScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger column = 4;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count + 1;
    CGFloat width = (self.view.frame.size.width - QiCaiMargin * assetCount - 10 ) / column;
    
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(5 + (width + 5) * col , row * (width + 5), width, width);
        
        // UIButton
        if (i == self.assets.count){
            // 最后一个Button
            //            [btn setImage:[UIImage ml_imageFromBundleNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"me_feedBack_add"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"me_feedBack_add"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(photoSelectet) forControlEvents:UIControlEventTouchUpInside];
        }else{
            // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
            if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
            }else if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLCamera class]]){
                [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
            }else if ([[self.assets objectAtIndex:i] isKindOfClass:[NSString class]]){
                [btn sd_setImageWithURL:[NSURL URLWithString:self.assets[i]] forState:UIControlStateNormal];
            }
            btn.tag = i;
        }
        
        [self.imageScrollView addSubview:btn];
    }
    
    self.imageScrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.imageScrollView.subviews lastObject] frame]));
    if (self.assets.count > 3) {
        
        self.imageScrollView.height = width * 2 + 10;
        self.summitBtn.y = CGRectGetMaxY(self.imageScrollView.frame) + QiCaiMargin;
    }
    else
    {
        self.imageScrollView.height = width  + 10;
        self.summitBtn.y = CGRectGetMaxY(self.imageScrollView.frame) + QiCaiMargin;

    }
    
}

#pragma mark - 选择图片
- (void)photoSelectet{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 9
    pickerVc.maxCount = 6;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Recoder Select Assets
    pickerVc.selectPickers = self.assets;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.isShowCamera = YES;
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        self.assets = status.mutableCopy;
        [self reloadScrollView];
    };
    [pickerVc showPickerVc:self];
}

-(void)clickTelBtn
{
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}

#pragma mark --textfield
//文字编辑结束按下range时
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
