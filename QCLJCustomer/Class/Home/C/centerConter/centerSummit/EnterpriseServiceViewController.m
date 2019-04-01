//
//  EnterpriseServiceViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/8.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "EnterpriseServiceViewController.h"

@implementation EnterpriseServiceViewController
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
    self.navigationItem.title = @"企业服务";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"main_fenxiang" action:@selector(clickShareBtn) target:self];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    UIView *topBJView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW, QiCaiMargin)];
    topBJView.backgroundColor = QiCaiBackGroundColor;
    [scrollView addSubview:topBJView];
    self.scrollView =scrollView;
    
    CGFloat Hheight = 40;
    //企业名称
    self.enterpriseTextField = [CHTextField addCHTextFileWithLeftImage:@"home_enterprise" frame:CGRectMake(0,CGRectGetMaxY(topBJView.frame),  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"请输入企业名称" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    [scrollView addSubview:self.enterpriseTextField];
    self.enterpriseTextField.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.enterpriseTextField.CHDelegate = self;
    self.enterpriseTextField.layer.borderWidth = 0;
    self.enterpriseTextField.textColor = QiCaiShallowColor;
    self.enterpriseTextField.placeholder = @"请输入企业名称";
    self.enterpriseTextField.cHTextFieldType = CHTextFieldTypeUnlimitedCH;
    self.enterpriseTextField.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(self.enterpriseTextField.frame) lineX:36 contentView:scrollView];
    
    //联系人
    self.nameChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_lianxiren" frame:CGRectMake(0,CGRectGetMaxY(self.enterpriseTextField.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"请输入联系人" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    [scrollView addSubview:self.nameChTextFile];
    NSString * nameStr = [MYUserDefaults objectForKey:@"name"];
    if (nameStr && ![nameStr isEqualToString:@"default"] && ![nameStr isEqualToString:@""] ) {
        self.nameChTextFile.text = [MYUserDefaults objectForKey:@"name"];
        self.nameChTextFile.userInteractionEnabled = NO;//禁止编辑
    }else{
        self.nameChTextFile.userInteractionEnabled = YES;//禁止编辑
    }
    self.nameChTextFile.textColor = QiCaiShallowColor;
    self.nameChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.nameChTextFile.CHDelegate = self;
    self.nameChTextFile.layer.borderWidth = 0;
    self.nameChTextFile.cHTextFieldType = CHTextFieldTypeName;
    self.nameChTextFile.font = [UIFont systemFontOfSize:12];
    [UIView addHLineWithY:CGRectGetMaxY(self.nameChTextFile.frame) lineX:36 contentView:scrollView];
    
    //手机号
    self.telephoneChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_shoujihao" frame:CGRectMake(0, CGRectGetMaxY(self.nameChTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight) placeholder:@"请输入11位手机号" placeholderLabelFont:6 placeholderTextColor:QiCaiBZTitleColor];
    [scrollView addSubview:self.telephoneChTextFile];
    self.telephoneChTextFile.layer.borderWidth = 0;
    self.telephoneChTextFile.textColor = QiCaiShallowColor;
    self.telephoneChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.telephoneChTextFile.CHDelegate = self;
    self.telephoneChTextFile.cHTextFieldType = CHTextFieldTypeTelephone;
    self.telephoneChTextFile.font = [UIFont systemFontOfSize:12];
    if ([MYUserDefaults objectForKey:@"mob"]) {
        self.telephoneChTextFile.text = [MYUserDefaults objectForKey:@"mob"];
        self.telephoneChTextFile.userInteractionEnabled = NO;//禁止编辑
    }
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
   
    
    //服务类型
    self.durationView = [[UIView alloc]init];
    self.durationView.frame = CGRectMake(0, CGRectGetMaxY(addressView.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight);
    self.durationView.backgroundColor =[UIColor whiteColor];
    [scrollView addSubview:self.durationView];
    
    UILabel * durationLabel = [[UILabel alloc]init];
    durationLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_qita"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(scrollView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"请选择服务类型" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    durationLabel.centerY = CGRectGetHeight(self.durationView.frame) / 2;
    [self.durationView addSubview:durationLabel];
    
    VDLog(@"%f",CGRectGetMaxY(self.durationView.frame));
    
    self.homeDurationBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetWidth(self.durationView.frame)- 80 -30, 0, 80, CGRectGetHeight(self.durationView.frame) / 2) ButtonTitle:@"包月保洁 " titleColor:[UIColor darkGrayColor] titleFont:[UIFont systemFontOfSize:12] borderColor:QiCaiBackGroundColor backGroundColor:nil Target:self action:@selector(homeDurationBtnChlie:) btnCornerRadius:0];
    //    [self.homeDurationBtn setImage:[UIImage imageNamed:@"home_triangle_off"] forState:UIControlStateNormal];
    //    [self.homeDurationBtn setImage:[UIImage imageNamed:@"home_triangle_on"] forState:UIControlStateSelected];
    self.homeDurationBtn.centerY = CGRectGetHeight(self.durationView.frame) / 2;
    self.homeDurationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.popArr = @[@"包月保洁",@"劳务派遣"];
    //设置button图右文左
    //    [self.homeDurationBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
    //                                 imageTitleSpace:3];
    //    self.homeDurationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 1);
    [self.durationView addSubview:self.homeDurationBtn];
     [UIView addHLineWithY:CGRectGetMaxY(self.durationView.frame) lineX:36 contentView:scrollView];
    
    // 服务时间
    UIView * dateView =  [[UIView alloc]init];
    dateView.frame = CGRectMake(0, CGRectGetMaxY(self.durationView.frame) + 1,  CGRectGetWidth(scrollView.frame), Hheight);
    dateView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:dateView];
    
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_shijian"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(dateView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"请选择服务时间" textColor:QiCaiDeepColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    dateLabel.centerY = CGRectGetHeight(dateView.frame) / 2;
    [dateView addSubview:dateLabel];
    //
    self.dateBtn = [UIButton addRightArrowBtnFrame:CGRectMake(CGRectGetWidth(dateView.frame) * 0.5, 0, CGRectGetWidth(dateView.frame) * 0.5 - 20, CGRectGetHeight(dateView.frame)) title:@" 请选择您的服务时间" color:QiCaiShallowColor imageName:[UIImage imageNamed:@"main_icon_arrow" ] target:self action:@selector(dateBtnChlie:)];
    //设置button图右文左
    [self.dateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                  imageTitleSpace:13];
    [dateView addSubview:self.dateBtn];
    
    [UIView addHLineWithY:CGRectGetMaxY(dateView.frame) lineX:36 contentView:scrollView];
    
    //温馨提示
    UIView * reminderView = [[UIView alloc]init];
    reminderView.frame = CGRectMake(0, CGRectGetMaxY(dateView.frame) + 1,  CGRectGetWidth(scrollView.frame), 68.5);
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
    
    
    CGFloat btnX = (MYScreenW - 137 * 2) / 3;
    //在线预定
    UIButton *enterpriseBtn = [UIButton addButtonWithFrame:CGRectMake(btnX, CGRectGetMaxY(reminderView.frame) + 10, 137, 30) title:@"在线预订" backgroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] font:QiCai10PFFont Target:self action:@selector(clickEnterpriseBtn:)];
    [enterpriseBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_normal"] forState:UIControlStateNormal];
    [enterpriseBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_select"] forState:UIControlStateHighlighted];
    [scrollView addSubview: enterpriseBtn];
    enterpriseBtn.acceptEventInterval = 1;
    
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        self.homeDurationBtn.selected = weakSelf.isShow;
        NSLog(@"点击第%ld个item",index+1);
        [self.homeDurationBtn setTitle:self.popArr[index] forState:UIControlStateNormal];
        //        [self.homeDurationBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
        //                                      imageTitleSpace:3];
        //        self.homeDurationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 1);
    }];
    

    
    //电话预定
    UIButton *phoneBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(enterpriseBtn.frame) + btnX, CGRectGetMaxY(reminderView.frame) + 10, 137, 30) title:@"电话预订" backgroundColor:[UIColor clearColor] titleColor:[UIColor whiteColor] font:QiCai10PFFont Target:self action:@selector(clickTelBtn)];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_normal"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_select"] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self action:@selector(clickTelBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview: phoneBtn];
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ scrollView.subviews objectAtIndex:scrollView.subviews.count - 1].frame) + 64 + 33);
    
   
    
    
}
-(void)clickEnterpriseBtn:(UIButton *)btn
{
    [self AFNPlaceOrderWith:@"41" btn:btn];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.isShow = NO;
    [self.showView dismissView];
}
-(void)clickTelBtn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000999001"]];
}

@end
