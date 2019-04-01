//
//  MaternityMatronViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/3.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "MaternityMatronViewController.h"

@interface MaternityMatronViewController ()

//@property (nonatomic,strong)NSMutableArray * maternityMatronArr;//选择的宠物
//@property (weak, nonatomic)UIButton *starBtn;//星级按钮

@property (nonatomic,strong)UILabel * label1;//星级label
@property (nonatomic,strong)UILabel * label2;//星级label
@property (nonatomic,strong)UILabel * label3;//星级label
@property (nonatomic,strong)UILabel * label4;//星级label

@property (nonatomic,strong)NSArray * strLabStrArr1;//
@property (nonatomic,strong)NSArray * strLabStrArr2;//
@property (nonatomic,strong)NSArray * strLabStrArr3;//
@property (nonatomic,strong)NSArray * strLabStrArr4;//

@end

@implementation MaternityMatronViewController
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
//- (NSMutableArray *)maternityMatronArr{
//    if (!_maternityMatronArr) {
//        _maternityMatronArr = [NSMutableArray array];
//    }
//    return _maternityMatronArr;
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
    self.navigationItem.title = @"月嫂";
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
    NSArray *imageArray = @[@"yuesao", @"yanglao", @"peixun"];
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:imageArray placeholderImage:[UIImage imageNamed:@"placeholder"] Target:self];
    [scrollView addSubview:cycleScrollView];
    
    //星级
    UIView * starView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(cycleScrollView.frame) , CGRectGetWidth(scrollView.frame), 91)];
    starView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:starView];
    
    NSArray * starArr = @[@"一星",@"二星",@"三星",@"四星",@"五星"];
    self.starBtn = [self demandToView:starView titleArrty:starArr startY:13 col:5 defaultBtn:nil startX:11 margin:13 target:self action:@selector(starButtonChlie:)];
    
    NSString * orderCount = [NSString stringWithFormat:@"%@份订单",[MYUserDefaults objectForKey:@"orderCount"]];
    _strLabStrArr1 = @[@"一星",@"二星",@"三星",@"四星",@"五星"];
    _strLabStrArr2 = @[@"26个工作日",@"26个工作日",@"26个工作日",@"26个工作日",@"26个工作日"];
    _strLabStrArr3 = @[@"9800元/月起",@"10800元/月起",@"12800元/月起",@"15800元/月起",@"18800元/月起"];
    _strLabStrArr4 = @[orderCount,orderCount,orderCount,orderCount,orderCount];
    
    _label1 = [UILabel addLabelWithFrame:CGRectMake(34, 45, CGRectGetWidth(starView.frame) * 0.4, 20) text:[NSString stringWithFormat:@"月嫂级别：%@",_strLabStrArr1[0]] size:10 textAlignment:NSTextAlignmentLeft];
    [starView addSubview:_label1];
    
    _label2 = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame) + 28, CGRectGetMinY(_label1.frame), CGRectGetWidth(starView.frame) * 0.4, 20) text:[NSString stringWithFormat:@"服务时长：%@",_strLabStrArr2[0]] size:10 textAlignment:NSTextAlignmentLeft];
    [starView addSubview:_label2];
    
    _label3 = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMinX(_label1.frame), CGRectGetMaxY(_label1.frame) + 0, CGRectGetWidth(starView.frame) * 0.4, 20) text:[NSString stringWithFormat:@"服务价格：%@",_strLabStrArr3[0]] size:10 textAlignment:NSTextAlignmentLeft];
    [starView addSubview:_label3];
    
    _label4 = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(_label1.frame) + 28, CGRectGetMinY(_label3.frame), CGRectGetWidth(starView.frame) * 0.4, 20) text:[NSString stringWithFormat:@"服务数量：%@",_strLabStrArr4[0]] size:10 textAlignment:NSTextAlignmentLeft];
    [starView addSubview:_label4];
    
    // 服务时间
    UIView * dateView =  [[UIView alloc]init];
    dateView.frame = CGRectMake(0, CGRectGetMaxY(starView.frame) + 1,  CGRectGetWidth(scrollView.frame), 47);
    dateView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:dateView];
    
    UILabel * dateLabel = [[UILabel alloc]init];
    dateLabel = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"icon_yuchanqi"] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(dateView.frame) * 0.5, 20 )imageFrame:CGRectZero text:@"预产期" textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
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
        self.nameChTextFile.text = [MYUserDefaults objectForKey:@"name"];
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
    
    //立即预定
    UIButton *maternityMatronsummitBtn = [UIButton addZhuFuBtnWithTitle:@"立即预订" rect:CGRectMake(0, MYScreenH - QiCaiZhifuHeight - 54 , MYScreenW, QiCaiZhifuHeight) Target:self action:@selector(clickMaternityMatronSummit:)];
    [self.view addSubview:maternityMatronsummitBtn];
    maternityMatronsummitBtn.acceptEventInterval = 1;

    
}
/*
 星级
 */
- (void)starButtonChlie:(UIButton *)btn{
    if (btn == self.starBtn) {
        self.starBtn.selected = YES;
    }
    else if (btn != self.starBtn)
    {
        btn.selected = YES;
        self.starBtn.selected = NO;
        self.starBtn = btn;
    }
    
    _label1.text = [NSString stringWithFormat:@"月嫂级别：%@",_strLabStrArr1[btn.tag - 1000]];
    _label2.text = [NSString stringWithFormat:@"服务时长：%@",_strLabStrArr2[btn.tag - 1000]];
    _label3.text = [NSString stringWithFormat:@"服务价格：%@",_strLabStrArr3[btn.tag - 1000]];
    _label4.text = [NSString stringWithFormat:@"服务数量：%@",_strLabStrArr4[btn.tag - 1000]];
   

}
/*
 立即预定
 */
- (void)clickMaternityMatronSummit:(UIButton *)btn{
    //    VDLog(@"%@",self.otherEducationStr);
    [self AFNPlaceOrderWith:@"22" btn:btn];
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
