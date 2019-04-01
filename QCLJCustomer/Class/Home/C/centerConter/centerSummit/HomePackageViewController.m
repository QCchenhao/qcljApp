//
//  HomePackageViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/8.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "HomePackageViewController.h"
#import "PPNumberButton.h"//加减


@implementation HomePackageViewController
- (void)returnHomeBlock:(ReturnHomeBlock)block
{
    self.returnHomeBlock = block;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //键盘处理
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    
    [self setUpUI];
    
}
-(void)setUpUI
{
    [CHMBProgressHUD shareinstance].popDelegate = self;
    
    // 设置导航栏标题
    self.navigationItem.title = @"家政套餐";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"main_fenxiang" action:@selector(clickShareBtn) target:self];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0 , screenFrame.size.width, 153);
    NSArray *imageArray = @[ @"baojie",@"yanglao", @"yuesao"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [scrollView addSubview:cycleScrollView];
    
    CGFloat Hheight = 42;
    // 服务时间
    UIView * dateView =  [[UIView alloc]init];
    dateView.frame = CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight);
    dateView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:dateView];
    
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_shijian"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(dateView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"服务时间" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    dateLabel.centerY = CGRectGetHeight(dateView.frame) / 2;
    [dateView addSubview:dateLabel];
    //
    self.dateBtn = [UIButton addRightArrowBtnFrame:CGRectMake(CGRectGetWidth(dateView.frame) * 0.5, 0, CGRectGetWidth(dateView.frame) * 0.5 - 20, CGRectGetHeight(dateView.frame)) title:@" 请选择您的服务时间" color:QiCaiShallowColor imageName:[UIImage imageNamed:@"main_icon_arrow" ] target:self action:@selector(dateBtnChlie:)];
    //设置button图右文左
    [self.dateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                  imageTitleSpace:13];
    [dateView addSubview:self.dateBtn];
    
    [UIView addHLineWithY:CGRectGetMaxY(dateView.frame) lineX:36 contentView:scrollView];
    
    //保洁服务套餐
    UIView *homePageView = [[UIView alloc]init];
    homePageView.frame = CGRectMake(0, CGRectGetMaxY(dateView.frame) + 1, CGRectGetWidth(scrollView.frame), 50);
    homePageView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:homePageView];

    UILabel *topHomepageLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(36, 8, 100, 15) text:@"保洁服务套餐" textColor:QiCaiDeepColor backgroundColor:[UIColor clearColor] size:12 textAlignment:NSTextAlignmentLeft];
    [homePageView addSubview:topHomepageLabel];
    UILabel *bottomHomepageLabel = [UILabel addNoLayerLabelWithFrame:CGRectMake(36, CGRectGetMaxY(topHomepageLabel.frame) + 3, 100, 15) text:@"450/套 立省40元" textColor:QiCaiBZTitleColor backgroundColor:[UIColor clearColor] size:10 textAlignment:NSTextAlignmentLeft];
    [homePageView addSubview:bottomHomepageLabel];
    
    PPNumberButton *numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(homePageView.frame)  - 100 - 30, 12.5, 100, 25)];
    //开启抖动动画
//    numberButton.shakeAnimation = YES;
    //设置边框颜色
    numberButton.borderColor = QiCaiShallowColor;
    //设置加减按钮文字
    [numberButton setTitleWithIncreaseTitle:@"+" decreaseTitle:@"-"];
    //    //自定义加减按钮背景图片
    //    [numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"timeline_relationship_icon_addattention"] decreaseImage:[UIImage imageNamed:@"decrease_highlight"]];
    self.cleaningServiceNuber = @"1";
    __weak typeof(self) weakSelf = self;
    numberButton.numberBlock = ^(NSString *num){
        weakSelf.cleaningServiceNuber = num;
        NSLog(@"%@",num);
    };
    [homePageView addSubview:numberButton];
    
    [UIView addHLineWithY:CGRectGetMaxY(homePageView.frame) lineX:36 contentView:scrollView];
    
    //联系人
    self.nameChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_lianxiren" frame:CGRectMake(0, CGRectGetMaxY(homePageView.frame) + 1,  CGRectGetWidth(scrollView.frame), 47) placeholder:@"请输入联系人" placeholderLabelFont:6 placeholderTextColor:nil];
    [scrollView addSubview:self.nameChTextFile];
    self.nameChTextFile.textColor = QiCaiShallowColor;
    self.nameChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.nameChTextFile.CHDelegate = self;
    self.nameChTextFile.layer.borderWidth = 0;
    self.nameChTextFile.cHTextFieldType = CHTextFieldTypeName;
    NSString * nameStr = [MYUserDefaults objectForKey:@"name"];
    if (nameStr && ![nameStr isEqualToString:@"default"] && ![nameStr isEqualToString:@""] ) {
        self.nameChTextFile.text = [MYUserDefaults objectForKey:@"name"];
        self.nameChTextFile.userInteractionEnabled = NO;//禁止编辑
    }else{
        self.nameChTextFile.userInteractionEnabled = YES;//禁止编辑
    }
    self.nameChTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(self.nameChTextFile.frame) lineX:36 contentView:scrollView];


    //手机号
    self.telephoneChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_shoujihao" frame:CGRectMake(0, CGRectGetMaxY(self.nameChTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), 47) placeholder:@"请输入联系人" placeholderLabelFont:6 placeholderTextColor:nil];
    [scrollView addSubview:self.telephoneChTextFile];
    self.telephoneChTextFile.layer.borderWidth = 0;
    self.telephoneChTextFile.textColor = QiCaiShallowColor;
    self.telephoneChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.telephoneChTextFile.CHDelegate = self;
    self.telephoneChTextFile.cHTextFieldType = CHTextFieldTypeTelephone;
    if ([MYUserDefaults objectForKey:@"mob"]) {
        self.telephoneChTextFile.text = [MYUserDefaults objectForKey:@"mob"];
        self.telephoneChTextFile.userInteractionEnabled = NO;//禁止编辑
    }
    self.telephoneChTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(self.telephoneChTextFile.frame) lineX:36 contentView:scrollView];

    
    //地址
    UIView * addressView = [[UIView alloc]init];
    addressView.frame = CGRectMake(0, CGRectGetMaxY(self.telephoneChTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight);
    addressView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:addressView];
    

    //登录状态
    self.addressTEmpView = [[UIView alloc]init];
    self.addressTEmpView.frame = CGRectMake(0, 0, CGRectGetWidth(addressView.frame), CGRectGetHeight(addressView.frame));
    [addressView addSubview:self.addressTEmpView];
    
    UIImageView * addressImageView = [[UIImageView alloc]init];
    addressImageView.frame = CGRectMake(10, 0, 20, 20);
    addressImageView.image = [UIImage imageNamed:@"icon_dizhi"];
    addressImageView.centerY = CGRectGetHeight(addressView.frame) / 2;
    [self.addressTEmpView addSubview:addressImageView];
    
    self.addressLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(addressImageView.frame) + 10, 0, CGRectGetWidth(addressView.frame) * 0.8, CGRectGetHeight(addressView.frame)) text:@"请选择服务地址" size:12 textAlignment:NSTextAlignmentLeft];
    [self.addressTEmpView addSubview:self.addressLabel];
    
    if ([MYUserDefaults objectForKey:@"address"]) {
        self.addressLabel.text = [MYUserDefaults objectForKey:@"address"];
    }
    
    
    UIButton *  addressBtn = [UIButton addRightArrowBtnFrame:CGRectMake(CGRectGetWidth(addressView.frame) * 0.5, 0, CGRectGetWidth(addressView.frame) * 0.5 - 20, CGRectGetHeight(addressView.frame)) title:nil color:[UIColor darkGrayColor] imageName:[UIImage imageNamed:@"main_icon_arrow" ] target:self action:@selector(addressBtnChlie:)];
    //设置button图右文左
    [addressBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                imageTitleSpace:13];
    [self.addressTEmpView addSubview:addressBtn];
    [UIView addHLineWithY:CGRectGetMaxY(addressView.frame) lineX:36 contentView:scrollView];


    //温馨提示
    UIView * reminderView = [[UIView alloc]init];
    reminderView.frame = CGRectMake(0, CGRectGetMaxY(addressView.frame) + 1,  CGRectGetWidth(scrollView.frame), 68.5);
    reminderView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:reminderView];
    
    UILabel * reminderLabel = [[UILabel alloc]init];
    reminderLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"home_wxts"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(reminderView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"温馨提示" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [reminderView addSubview:reminderLabel];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    
    UILabel * reminderContentLabel = [UILabel addLayerLabelWithFrame:CGRectMake(34, CGRectGetMaxY(reminderLabel.frame) , MYScreenW - 43 , 50) text:@"客服会在24小时内与您的电话沟通，遇到节假日顺延一般会在9:00-18:00与您联系，届时请保持手机顺畅！" textColor:QiCaiBZTitleColor size:9 lineSpacing:3];
    [reminderView addSubview:reminderContentLabel];
    
    [reminderContentLabel setLabelSpace:reminderContentLabel withValue:reminderContentLabel.text withFont:reminderContentLabel.font];
    reminderContentLabel.height = 35;
    reminderContentLabel.width = MYScreenW - 43;
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ scrollView.subviews objectAtIndex:scrollView.subviews.count - 1].frame) + 64 + 33);
    
    //立即预定
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即预订" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickHomepageBtn:)];
    maternityMatronsummitBtn.acceptEventInterval = 1;
    [self.view addSubview:maternityMatronsummitBtn];
    
}
-(void)clickHomepageBtn:(UIButton *)btn
{
    [self AFNPlaceOrderWith:@"40" btn:btn];
}
@end
