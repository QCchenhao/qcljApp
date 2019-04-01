//
//  ParentalViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "ParentalViewController.h"



@interface ParentalViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,PopDelegate>

//@property (weak, nonatomic)UIButton * homeBtn;//设置默认住家
//@property (weak, nonatomic) UIButton * babyAgeBtn;//宝宝年龄
//@property (weak, nonatomic)UIButton * menAndWomenBtn;//男宝宝女宝宝
@property (strong, nonatomic)UIButton * menBtn;//男宝宝女宝宝
@property (strong, nonatomic)UIButton * womenBtn;//男宝宝女宝宝
//@property (nonatomic,strong)NSMutableArray * parentalPetArr;//选择的宠物


@end

@implementation ParentalViewController
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

#pragma mark - SDCycleScrollViewDelegate--轮播图代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    VDLog(@"---点击了第%ld张图片", (long)index);
}
/*
 // 滚动到第几张图回调
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
 {
 NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
 }
 */
//- (NSMutableArray *)parentalPetArr{
//    if (!_parentalPetArr) {
//        _parentalPetArr = [NSMutableArray array];
//    }
//    return _parentalPetArr;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    //键盘处理
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    
    [self setUpUI];
    
}

-(void)setUpUI
{
    
    [CHMBProgressHUD shareinstance].popDelegate = self;
    
    // 设置导航栏标题
    self.navigationItem.title = @"育儿嫂";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"main_fenxiang" action:@selector(clickShareBtn) target:self];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0 , screenFrame.size.width, 153);
    NSArray *imageArray = @[ @"yuersao",@"yanglao", @"yuesao"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [scrollView addSubview:cycleScrollView];
    
    //男宝宝女宝宝
    UIView * menAndWomenView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(cycleScrollView.frame) , CGRectGetWidth(scrollView.frame), 193)];
    menAndWomenView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:menAndWomenView];
    
    _menBtn = [UIButton addButtonWithFrame:CGRectMake(0, 4, CGRectGetWidth(menAndWomenView.frame) / 2 - 8.5, 60) image:@"home_parental_men_off" highImage:@"home_parental_men_on" backgroundColor:nil Target:self action:@selector(menAndWomenButtonChlie:)];
    [menAndWomenView addSubview:_menBtn];
    _menBtn.selected = YES;
    
    _womenBtn = [UIButton addButtonWithFrame:CGRectMake(0, 4, CGRectGetWidth(menAndWomenView.frame) / 2 - 8.5, 60) image:@"home_parental_girl_off" highImage:@"home_parental_girl_on" backgroundColor:nil Target:self action:@selector(menAndWomenButtonChlie:)];
    [menAndWomenView addSubview:_womenBtn];
    
    _menBtn.centerX = CGRectGetWidth(menAndWomenView.frame) / 4 + 8.5 - 8.5 / 2;
    _womenBtn.centerX = CGRectGetWidth(menAndWomenView.frame) / 4 * 3 - 8.5  + 8.5 / 2;
    
    NSArray *menAndWomenArr = @[@"男宝宝",@"女宝宝"];
    self.menAndWomenBtn = [self demandToView:menAndWomenView titleArrty:menAndWomenArr startY:66.7 col:2 defaultBtn:nil startX:8.5 margin:8.5 target:self action:@selector(menAndWomenButtonChlie:)];
    NSArray * babyAgeArr = @[@"1~6个月",@"7~12个月",@"13~24个月",@"24个月以上"];
    self.babyAgeBtn = [self demandToView:menAndWomenView titleArrty:babyAgeArr startY:111.3 col:4 defaultBtn:nil startX:8.5 margin:8.5 target:self action:@selector(babyAgeButtonChlie:)];
    
    NSArray *flavorArr = @[@"住家",@"不住家"];
    self.homeBtn = [self demandToView:menAndWomenView titleArrty:flavorArr startY:150 col:2 defaultBtn:self.homeBtn startX:8.5 margin:8.5 target:self action:@selector(homeButtonChlie:)];
    
    //心理价位
    UIView * psychologyVeiw = [[UIView alloc]init];
    psychologyVeiw.frame =CGRectMake(0, CGRectGetMaxY(menAndWomenView.frame) + 1, CGRectGetWidth(scrollView.frame), 80);
    psychologyVeiw.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:psychologyVeiw];
    
    NSArray * psychologyVeiwArr = @[@"3",@"4",@"5",@"7",@"8"] ;
    NSString * psychologyEndStrRichLabel = @"/月";
    NSString * psychologyUnit = @"k";
    self.homeSliderPriceLabel = [self addSlider:psychologyVeiw labelImage:@"icon_yongjin" titleLabelText:@"心理价位" showLabel:@"3~8k/月" endStrRichLabel:psychologyEndStrRichLabel sliderArr:psychologyVeiwArr unit:psychologyUnit];
    
    //服务时长
    self.durationView = [[UIView alloc]init];
    self.durationView.frame = CGRectMake(0, CGRectGetMaxY(psychologyVeiw.frame) + 1,  CGRectGetWidth(scrollView.frame), 47);
    self.durationView.backgroundColor =[UIColor whiteColor];
    [scrollView addSubview:self.durationView];
    
    UILabel * durationLabel = [[UILabel alloc]init];
    durationLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_shichang"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(self.durationView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"服务时长" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    durationLabel.centerY = CGRectGetHeight(self.durationView.frame) / 2;
    [self.durationView addSubview:durationLabel];
    
    self.homeDurationStr = @"1";
    PPNumberButton *numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.durationView.frame)- 80 -40, 0, 110, CGRectGetHeight(self.durationView.frame) / 2)];
    //开启抖动动画
    //    numberButton.shakeAnimation = YES;
    //设置边框颜色
    numberButton.borderColor = QiCaiShallowColor;
    //设置加减按钮文字
    [numberButton setTitleWithIncreaseTitle:@"+" decreaseTitle:@"-"];
    //    //自定义加减按钮背景图片
    //    [numberButton setImageWithIncreaseImage:[UIImage imageNamed:@"timeline_relationship_icon_addattention"] decreaseImage:[UIImage imageNamed:@"decrease_highlight"]];
    self.cleaningServiceNuber = @"1";
    numberButton.unitSuffixStr = @"个月";
    numberButton.maxNumber = 12;
    __weak typeof(self) weakSelf = self;
    numberButton.numberBlock = ^(NSString *num){
        
        weakSelf.homeDurationStr = num;
        
        NSLog(@"%@",num);
    };
    [self.durationView addSubview:numberButton];
    
    numberButton.centerY = CGRectGetHeight(self.durationView.frame) / 2;
    
//    self.homeDurationStr = @"1";
//    self.homeDurationBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetWidth(self.durationView.frame)- 80 -30, 0, 80, CGRectGetHeight(self.durationView.frame) / 2) ButtonTitle:@"1个月" titleColor:[UIColor darkGrayColor] titleFont:[UIFont systemFontOfSize:12] borderColor:QiCaiBackGroundColor backGroundColor:nil Target:self action:@selector(homeDurationBtnChlie:) btnCornerRadius:0];
//    [UILabel setRichLabelText:<#(UILabel *)#> startStr:<#(NSString *)#> endStr:<#(NSString *)#> font:<#(UIFont *)#> color:<#(UIColor *)#>]
//    UILabel * homeLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(self.homeDurationBtn.frame), 0, 40, CGRectGetHeight(self.durationView.frame) / 2) text:@"个月" size:12 textAlignment:NSTextAlignmentLeft];
//    [self.durationView addSubview:homeLabel];
    
//    [self.homeDurationBtn setImage:[UIImage imageNamed:@"home_triangle_off"] forState:UIControlStateNormal];
//    [self.homeDurationBtn setImage:[UIImage imageNamed:@"home_triangle_on"] forState:UIControlStateSelected];
    
//    self.homeDurationBtn.centerY = CGRectGetHeight(self.durationView.frame) / 2;
////    homeLabel.centerY = self.homeDurationBtn.centerY;
//    self.homeDurationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    self.popArr = @[@"1个月",@"2个月",@"3个月",@"4个月",@"5个月",@"6个月",@"7个月",@"8个月",@"9个月",@"10个月",@"11个月",@"12个月"];
//    self.popArr = @[@"1个月",@"2个月",@"3个月",@"4个月",@"5个月",@"6个月",@"12个月"];
    //设置button图右文左
//    [self.homeDurationBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                                  imageTitleSpace:3];
//    self.homeDurationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 1);
    [self.durationView addSubview:self.homeDurationBtn];

    
    
    // 服务时间
    UIView * dateView =  [[UIView alloc]init];
    dateView.frame = CGRectMake(0, CGRectGetMaxY(self.durationView.frame) + 1,  CGRectGetWidth(scrollView.frame), 47);
    dateView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:dateView];
    
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_shijian"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(dateView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"服务时间" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    dateLabel.centerY = CGRectGetHeight(dateView.frame) / 2;
    [dateView addSubview:dateLabel];
    //
    self.dateBtn = [UIButton addRightArrowBtnFrame:CGRectMake(CGRectGetWidth(dateView.frame) * 0.5, 0, CGRectGetWidth(dateView.frame) * 0.5 - 20, CGRectGetHeight(dateView.frame)) title:@" 请选择您的服务时间" color:[UIColor darkGrayColor] imageName:[UIImage imageNamed:@"main_icon_arrow" ] target:self action:@selector(dateBtnChlie:)];
    //设置button图右文左
    [self.dateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                              imageTitleSpace:13];
    [dateView addSubview:self.dateBtn];
    
    //是否宠物
    UIView * petView = [[UIView alloc]init];
    petView.frame = CGRectMake(0, CGRectGetMaxY(dateView.frame) + 1,  CGRectGetWidth(scrollView.frame), 81);
    petView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:petView];
    
    UILabel * petLabel = [[UILabel alloc]init];
    petLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_chongwu"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(petView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"是否有宠物" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [petView addSubview:petLabel];
    
    NSArray *petArr = @[@"大型犬", @"小型犬",@"猫"];
    [self demandToView:petView titleArrty:petArr startY:CGRectGetMaxY(petLabel.frame) + 10 col:kServeContentViewCol defaultBtn:nil startX:34 margin:34 target:self action:@selector(petButtonChlie:)];
    
    //其他需求
    self.otherView = [[UIView alloc]init];
    self.otherView.frame = CGRectMake(0, CGRectGetMaxY(petView.frame) + 1,  CGRectGetWidth(scrollView.frame), 81);
    self.otherView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:self.otherView];
    
    
    UILabel * otherLabel = [[UILabel alloc]init];
    otherLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_qita"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(self.otherView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"其他需求" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [self.otherView addSubview:otherLabel];
    
    self.otherArr = @[@"学历", @"年龄",@"上岗证"];
    self.otherEducationArr = @[@"初中",@"高中",@"大学"];
    self.otherAgeArr = @[@"30~40岁",@"40~45岁",@"45~50岁"];
    self.otherCertificatesArr = @[@"无资格",@"有资格"];
    [self demandToView:self.otherView titleArrty:self.otherArr startY:CGRectGetMaxY(otherLabel.frame) + 10 col:kServeContentViewCol defaultBtn:nil startX:34 margin:34 target:self action:@selector(otherButtonChlie:)];
    
    //联系人
    self.nameChTextFile = [CHTextField addCHTextFileWithLeftImage:@"icon_lianxiren" frame:CGRectMake(0, CGRectGetMaxY(self.otherView.frame) + 1,  CGRectGetWidth(scrollView.frame), 47) placeholder:@"请输入联系人" placeholderLabelFont:6 placeholderTextColor:nil];
    [scrollView addSubview:self.nameChTextFile];
    self.nameChTextFile.textColor = QiCaiShallowColor;
    self.nameChTextFile.placeholderLabelFont = [UIFont systemFontOfSize:12];
    self.nameChTextFile.CHDelegate = self;
    self.nameChTextFile.layer.borderWidth = 0;
    self.nameChTextFile.cHTextFieldType = CHTextFieldTypeName;
    NSString * nameStr = [MYUserDefaults objectForKey:@"name"];
    if (nameStr && ![nameStr isEqualToString:@"default"] && ![nameStr isEqualToString:@""] ) {
        self.nameChTextFile.text = nameStr;
        self.nameChTextFile.userInteractionEnabled = NO;//禁止编辑
    }else{
        self.nameChTextFile.userInteractionEnabled = YES;//禁止编辑
    }
    self.nameChTextFile.font = [UIFont systemFontOfSize:12];
    
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
    

    
    //地址
    UIView * addressView = [[UIView alloc]init];
    addressView.frame = CGRectMake(0, CGRectGetMaxY(self.telephoneChTextFile.frame) + 1,  CGRectGetWidth(scrollView.frame), 47);
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


    //温馨提示
    UIView * reminderView = [[UIView alloc]init];
    reminderView.frame = CGRectMake(0, CGRectGetMaxY(addressView.frame) + 1,  CGRectGetWidth(scrollView.frame), 68.5);
    reminderView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:reminderView];
    
    UILabel * reminderLabel = [[UILabel alloc]init];
    reminderLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"home_wxts"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(reminderView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"温馨提示" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [reminderView addSubview:reminderLabel];
    
    UILabel * reminderContentLabel = [UILabel addLayerLabelWithFrame:CGRectMake(34, CGRectGetMaxY(reminderLabel.frame) , MYScreenW - 43 , 50) text:@"客服会在24小时内与您的电话沟通，遇到节假日顺延一般会在9:00-18:00与您联系，届时请保持手机顺畅！" textColor:[UIColor darkGrayColor] size:9 lineSpacing:3];
    [reminderView addSubview:reminderContentLabel];
    
    [reminderContentLabel setLabelSpace:reminderContentLabel withValue:reminderContentLabel.text withFont:reminderContentLabel.font];
    reminderContentLabel.height = 35;
    reminderContentLabel.width = MYScreenW - 43;
    
    scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY([ scrollView.subviews objectAtIndex:scrollView.subviews.count - 1].frame) + 64 + 33);
    
//    __weak typeof(self) weakSelf = self;
//    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
//        weakSelf.isShow = NO;
//        NSLog(@"点击第%ld个item",index+1);
//        [self.homeDurationBtn setTitle:self.popArr[index] forState:UIControlStateNormal];
//        self.homeDurationStr = [NSString stringWithFormat:@"%ld",index + 1];
////        [self.homeDurationBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
////                                          imageTitleSpace:3];
////        self.homeDurationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 1);
//    }];
    

    
    //立即预定
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即预订" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickMaternityMatronSummit:)];
    [self.view addSubview:maternityMatronsummitBtn];
    maternityMatronsummitBtn.acceptEventInterval = 1;
    
}

/*
 选择男宝宝 女宝宝
 */
- (void)menAndWomenButtonChlie:(UIButton *)btn{
    if (btn == self.menAndWomenBtn) {
        self.menAndWomenBtn.selected = YES;
        if (btn.tag == 1000) {
            self.menBtn.selected = btn.selected;
            self.womenBtn.selected = !btn.selected;
        }else{
            self.menBtn.selected = btn.selected;
            self.womenBtn.selected = !btn.selected;
        }

    }
    else if (btn != self.menAndWomenBtn)
    {
        if (btn != self.menBtn && btn != self.womenBtn) {
            btn.selected = YES;
            self.menAndWomenBtn.selected = NO;
            self.menAndWomenBtn = btn;
            
            if (btn.tag == 1000) {
                self.menBtn.selected = btn.selected;
                self.womenBtn.selected = !btn.selected;
            }else{
                self.menBtn.selected = !btn.selected;
                self.womenBtn.selected = btn.selected;
            }
        }else{
            
        }
       
        

    }
    
    
}
/*
 选择宝宝年龄
 */
- (void)babyAgeButtonChlie:(UIButton *)btn{
    if (btn == self.babyAgeBtn) {
        self.babyAgeBtn.selected = YES;
    }
    else if (btn != self.babyAgeBtn)
    {
        btn.selected = YES;
        self.babyAgeBtn.selected = NO;
        self.babyAgeBtn = btn;
    }
}
///*
// 住家
// */
//- (void)homeButtonChlie:(UIButton *)btn{
//    if (btn == self.homeBtn) {
//        self.homeBtn.selected = YES;
//    }
//    else if (btn != self.homeBtn)
//    {
//        btn.selected = YES;
//        self.homeBtn.selected = NO;
//        self.homeBtn = btn;
//    }
//    
//}
/*
 立即预定
 */
- (void)clickMaternityMatronSummit:(UIButton *)btn{
//    VDLog(@"%@",self.homeOtherEducationStr);
    [self AFNPlaceOrderWith:@"24" btn:btn];
}
/*
 宠物
 */
- (void)petButtonChlie:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected == YES) {
        [self.nannyPetArr addObject:btn.titleLabel.text];
        
        //         NSLog( @"%@",self.petArr);
        
    }else{
        [self.nannyPetArr removeObject:btn.titleLabel.text];
    }
    
    
}

@end
