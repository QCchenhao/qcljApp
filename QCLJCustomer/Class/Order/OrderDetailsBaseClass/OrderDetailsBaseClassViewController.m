//
//  OrderDetailsBaseClassViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/6.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "OrderDetailsBaseClassViewController.h"

#import "QiCaiTabBarController.h"//

#import "OrderPayViewController.h"//订单支付
//#import "StorePayViewController.h"//门店缴费支付
#import "OrderCancelViewController.h"//取消订单


@interface OrderDetailsBaseClassViewController ()

@end

@implementation OrderDetailsBaseClassViewController
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 创建订单状态View
- (UIView *)addOrderTypeIndex:(NSInteger )index imageArr:(NSArray *)imageArr highImageArr:(NSArray *)highImageArr titleArr:(NSArray *)titleArr{
    //订单状态
    UIView * orderTypeView = [[UIView alloc]init];
    orderTypeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 68);
    orderTypeView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:orderTypeView];
    
    //    NSArray * imageArr = @[@"me_address_off",@"me_address_off",@"me_address_off"];
    //    NSArray * highImageArr = @[@"me_address_on",@"me_address_on",@"me_address_on"];
    //    NSArray * titleArr = @[@"提交订单",@"匹配人员",@"上门服务"];
    
    //    NSInteger index = 0;

    NSInteger col;
    CGFloat startX ;
    if (imageArr.count == 2) {
        col = 2;
        startX = MYScreenW * 0.284;//MYScreenW * 0.27
    }else{
        col = 3;
        startX = MYScreenW * 0.15;
    }
//    CGFloat startX = 34;
    CGFloat startY = 0;
//    NSInteger col = 3;
    CGFloat margin = 40;
    
    CGFloat width = (MYScreenW - startX * 2 - (col - 1) * margin ) / col;
    CGFloat height = CGRectGetHeight(orderTypeView.frame);
    CGFloat CWstartY = startY ;//45;
    
    
    
    
    for (NSInteger i = 0; i < imageArr.count; i++) {
        UIButton * button = [UIButton addButtonWithFrame:CGRectZero image:imageArr[i] highImage:highImageArr[i] backgroundColor:nil Target:nil action:nil];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:QiCaiDetailTitle12Font];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:QiCaiNavBackGroundColor forState:UIControlStateSelected];
        [orderTypeView addSubview:button];
        
        button.width = width;
        button.height = height;
        NSInteger row = i / col;//行号
        NSInteger CWcol = i % col;//列号
        button.x = startX + (width +  margin) * CWcol;
        button.y = CWstartY + (height + 8.5) * row;
        
        //设置button图上文下
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:0];
        UIButton * button2;
        if (i != titleArr.count - 1) {
            button2 = [UIButton addButtonWithFrame:CGRectZero image:@"details_process_arrow_off" highImage:@"details_process_arrow_on" backgroundColor:nil Target:nil action:nil];
            [orderTypeView addSubview:button2];
            button2.frame = CGRectMake(CGRectGetMaxX(button.frame) + 5, CGRectGetMinY(button.imageView.frame), margin - 10,20);
            button2.centerY = button.imageView.centerY;
            
        }
        if (i < index) {
            if (i < (index - 1)) {
                button2.selected = YES;
            }
            button.selected = YES;
        }

        
    }
    return orderTypeView;
}
#pragma mark - 创建订单信息View
- (UIView *)informationViewToY:(CGFloat)viewY Arr1:(NSArray *)labelArr1 Arr2:(NSArray *)labelArr2{
    
    //订单信息
    UIView * informationView = [[UIView alloc]init];
    informationView.frame = CGRectMake(0,viewY , CGRectGetWidth(self.scrollView.frame), 140);
    informationView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:informationView];
    
    for (NSInteger i = 0; i < labelArr1.count; i++) {
        
        CGRect labelRect = CGRectMake(15,6 + i * 21, CGRectGetWidth(informationView.frame) * 0.20, 20);
        UILabel * label1 = [UILabel addLabelWithFrame:labelRect text:labelArr1[i] size:12 textAlignment:NSTextAlignmentLeft];
        
//        label1.backgroundColor = [UIColor yellowColor];
        [informationView addSubview:label1];
        
        NSArray * arr  = labelArr2[i];
        
        for (NSInteger j = 0; j < arr.count; j++) {
            
            NSString * labelText2 = arr[j];
            
            UILabel * label2;
            CGRect labelRect2;
            /**
             处理地址的
             */
            if (i == labelArr2.count - 1) {
                
                // 指定我要以这个大小的字体显示
                NSDictionary *attributeDict = @{NSFontAttributeName : [UIFont systemFontOfSize:11]};
                // 最大范围
                CGSize maxSize = CGSizeMake(CGRectGetWidth(informationView.frame) * 0.72, MAXFLOAT);
                // 就是地址的size
                NSString *str = labelText2;
                CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
                labelRect2 = CGRectMake(CGRectGetMaxX(label1.frame) + 55  * j, CGRectGetMinY(label1.frame), CGRectGetWidth(informationView.frame) * 0.72, size.height);

            }else
            {
                labelRect2 = CGRectMake(CGRectGetMaxX(label1.frame) + 55  * j, CGRectGetMinY(label1.frame), labelText2.length * 15, 20 );
                
            }
            label2  = [UILabel addLayerLabelWithFrame:labelRect2 text:labelText2 textColor:QiCaiDeepColor size:11 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
            label2.centerY = label1.centerY;
                       
            label2.textAlignment = NSTextAlignmentLeft;
            if ((i == 1 || i == 2 || i == 3) && j == 0) {
                label2.textColor = QiCaiNavBackGroundColor;
                if (labelArr1.count == 5 && i == 3) {
                    label2.textColor = QiCaiDeepColor;
                }
                if ([label1.text isEqualToString:@"企业名称："]) {
                    label2.textColor = QiCaiDeepColor;
                }
            }
            informationView.height = CGRectGetMaxY(label2.frame) + 8;
            [informationView addSubview:label2];
        }
        
        
    }
    return informationView;
}

#pragma mark - 创建筛选条件View
- (UIView *)screenViewToY:(CGFloat)viewY orderType:(NSString *)orderType detailsModel:(DetailsModel*)detailsModel{
    //筛选条件   CGRectGetMaxY(informationView.frame) + 5
    UIView * screenView = [[UIView alloc]init];
    screenView.frame = CGRectMake(0,viewY , CGRectGetWidth(self.scrollView.frame), 124);
    screenView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:screenView];
    
    UILabel * label = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"details_screen"] interval:3 frame:CGRectMake(15
                                                                                                                                   , 8.5, CGRectGetWidth(screenView.frame) * 0.3, 20) imageFrame:CGRectZero text:@"筛选条件" textColor:QiCaiShallowColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [screenView addSubview:label];
    
    NSString * educationStr = [NSString stringWithFormat:@"%@学历：",orderType];
    NSString * ageStr = [NSString stringWithFormat:@"%@年龄：",orderType];
    
    NSArray *screenArr1 = @[educationStr,ageStr, @"上岗资格证：",@"是否有宠物："];
    
    NSMutableArray * screenArr2 = [self setArrStr:detailsModel.acondition];
    if (!detailsModel.pet  || [detailsModel.pet isEqualToString:@""] ||[detailsModel.pet isEqualToString:@"default"] ||[detailsModel.pet isEqualToString:@"null"] ) {
        detailsModel.pet = @"无";
    }
    [screenArr2 addObject:detailsModel.pet];
    
    for (NSInteger i = 0;i < screenArr1.count; i++) {
        CGRect labelRect = CGRectMake(30,CGRectGetMaxY(label.frame)  + i * 21, CGRectGetWidth(screenView.frame) * 0.85, 25);
        NSString * temp = [NSString stringWithFormat:@"%@  %@",screenArr1[i],screenArr2[i]];
        UILabel * label1 = [UILabel addLabelWithFrame:labelRect text:temp size:12 textAlignment:NSTextAlignmentLeft];
        
        [screenView addSubview:label1];
        
    }
    return screenView;
}
#pragma mark - 创建温馨提示View
- (UIView *)promptViewToY:(CGFloat)viewY title:(NSString *)title message:(NSString*)message{
    //温馨提示
    UIView * promptView = [[UIView alloc]init];
    promptView.frame = CGRectMake(0,viewY , CGRectGetWidth(self.scrollView.frame), 124);//124
    promptView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:promptView];
    
    UILabel * label = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:@"home_wxts"] interval:3 frame:CGRectMake(15, 8.5, CGRectGetWidth(promptView.frame) * 0.3, 20) imageFrame:CGRectZero text:@"温馨提示" textColor:QiCaiShallowColor backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [promptView addSubview:label];
    
    UIButton * button  =[UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(promptView.frame) * 0.615, CGRectGetHeight(label.frame)) image:@"details_upper_on" highImage:@"details_upper_off" backgroundColor:nil Target:self action:@selector(promptBtnChlie:)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [promptView addSubview:button];
    
    self.titleLabel = [UILabel addLayerLabelWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame) + 5, CGRectGetWidth(promptView.frame) * 0.85, 50) text:title textColor:QiCaiShallowColor size:10 lineSpacing:4];
    [promptView addSubview:self.titleLabel];
    
    self.messageLabel = [UILabel addLayerLabelWithFrame:CGRectMake(30, CGRectGetMaxY(self.titleLabel.frame) + 8.5, CGRectGetWidth(promptView.frame) * 0.75, 50) text:message textColor:QiCaiBZTitleColor size:8.5 lineSpacing:4];
    [promptView addSubview:self.messageLabel];
    return promptView;
}
#pragma mark -     //订单价格
- (UIView *)orderPriceViewToY:(CGFloat)viewY oneArr:(NSArray *)oneArr twoArr:(NSArray *)twoArr{
    
    //订单价格
    UIView * orderPriceView = [[UIView alloc]init];
    orderPriceView.frame = CGRectMake(0,viewY, CGRectGetWidth(self.scrollView.frame), 80);//124
    orderPriceView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:orderPriceView];
    
    for (NSInteger i = 0; i < oneArr.count;  i++) {
        
        CGRect labelOneRect = CGRectMake(15,6 + i * 21, CGRectGetWidth(orderPriceView.frame) * 0.20, 20);
        
        UILabel * onelabel = [UILabel addLabelWithFrame:labelOneRect text:oneArr[i] size:12 textAlignment:NSTextAlignmentLeft];
        [orderPriceView addSubview:onelabel];
        
        CGRect labelTwoRect = CGRectMake(CGRectGetMaxX(onelabel.frame),6 + i * 21, CGRectGetWidth(orderPriceView.frame) * 0.23, 20);
        UILabel * lableTwoLable = [UILabel addLabelWithFrame:labelTwoRect text:twoArr[i] size:12 textAlignment:NSTextAlignmentRight];

        [orderPriceView addSubview:lableTwoLable];
    }
    
    orderPriceView.height = CGRectGetMaxY([ orderPriceView.subviews objectAtIndex:orderPriceView.subviews.count - 1].frame) + 10;
    
    return orderPriceView;
}
#pragma mark - 创建取消订单View
- (UIView *)cancelViewAndBtnWithView:(UIView *)view{
    
//    self.orderID = orderID;
    UIView * btnView = [[UIView alloc]init];
    btnView.frame= CGRectMake(-1, MYScreenH - 44 - NavigationBarHeight - 20, MYScreenW + 1, 44);
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.layer.borderColor = QiCaiBackGroundColor.CGColor;
    btnView.layer.borderWidth = 1;
    [view addSubview:btnView];
    
    CGRect btnRect = CGRectMake(0, 0, CGRectGetWidth(btnView.frame) * 0.4, CGRectGetHeight(btnView.frame) * 0.6);
    UIButton * promptBtn = [UIButton addButtonWithFrame:btnRect ButtonTitle:@"取消订单" titleColor:QiCaiNavBackGroundColor titleFont:QiCaiDetailTitle10Font borderColor:QiCaiBackGroundColor backGroundColor:[UIColor whiteColor] Target:self action:@selector(cancelBtnChlie:) btnCornerRadius:CGRectGetHeight(btnRect) / 2];
    promptBtn.centerY = btnView.height / 2;
    promptBtn.centerX = btnView.width /4 * 3;
    [btnView addSubview:promptBtn];
    
    return btnView;
}
#pragma mark - 筛选订单信息数组
- (NSString *)setOrderInformationArrWithModel:(DetailsModel *)model stateStr:(NSString *)stateStr labelArr1:(NSMutableArray *)labelArr11 labelArr2:(NSMutableArray *)labelArr22 {
    NSArray *labelArr1;
    NSArray * labelArr2;
    
    NSString *  orderType;
    //arr1服务类型
    NSMutableArray * arr1 ;
    if (model.econdition) {
        arr1 = [self setArrStr:model.econdition];
        
    }
    if (!arr1) {
        arr1 = [NSMutableArray array];
    }
    
    NSString *ishome ;
    if (model.ishome == 1) {
        ishome = @"住家";
    }else{
        ishome = @"不住家";
    }
    //arr1服务类型
    NSMutableArray * arr2 = [NSMutableArray array];
    [arr2 addObject:ishome];
    if (model.mprice) {
        NSString * temp = [NSString stringWithFormat:@"%@K/月",model.mprice];
        [arr2 addObject:temp];
    }else{
        VDLog(@"心理价位为空");
    }
    if (model.smins) {
        NSString * smindStr = [NSString stringWithFormat:@"%@个月",model.smins];
        [arr2 addObject:smindStr];
    }else{
        VDLog(@"服务时长为空");
    }
    NSString *smoneyStr;
    if (model.smoney) {
        
        switch (model.smoney) {
            case 1:
                smoneyStr = @"一星";
                break;
            case 2:
                smoneyStr = @"二星";
                break;
            case 3:
                smoneyStr = @"三星";
                break;
            case 4:
                smoneyStr = @"四星";
                break;
            case 5:
                smoneyStr = @"五星";
                break;
                
                
            default:
                 smoneyStr = @"不限";
                break;
        }
    }
    NSString * spriceStr ;
    NSString * priceStr;
    NSString * einsuStr;
    
    spriceStr = [NSString stringWithFormat:@"%.2f元",model.sprice];
    priceStr = [NSString stringWithFormat:@"%.2f元",model.price];
    einsuStr = [NSString stringWithFormat:@"%.2f元",model.einsu];
    
    switch (model.stid) {
        case OrderMaternityMatron:
            orderType = @"月嫂";
            //arr1服务类型
            
            [arr1 insertObject:orderType atIndex:0];
            [arr1 addObject:smoneyStr];
            labelArr1 = @[@"订单编号：",@"订单状态：",@"服务类型：",@"服务时间：",@"服务地点："];
            [labelArr11 addObjectsFromArray:labelArr1];
            
            labelArr2 = @[@[model.snum],
                          @[stateStr],
                          arr1,
                          @[model.stime],
                          @[model.address]];
            [labelArr22 addObjectsFromArray:labelArr2];
            break;
        case OrderPaorental:
            orderType = @"育儿嫂";
            
            //arr1服务类型
            [arr1 insertObject:orderType atIndex:0];
            
            labelArr1 = @[@"订单编号：",@"订单状态：",@"服务类型：",@"服务方式：",@"服务时间：",@"服务地点："];
            [labelArr11 addObjectsFromArray:labelArr1];
            
            labelArr2 = @[@[model.snum],
                          @[stateStr],
                          arr1,
                          arr2,
                          @[model.stime],
                          @[model.address]];
            [labelArr22 addObjectsFromArray:labelArr2];
            break;
        case OrderNammy:
            orderType = @"保姆";
            //arr1服务类型
            [arr1 insertObject:orderType atIndex:0];
            
            labelArr1 = @[@"订单编号：",@"订单状态：",@"服务类型：",@"服务方式：",@"服务时间：",@"服务地点："];
            [labelArr11 addObjectsFromArray:labelArr1];
            
            labelArr2 = @[@[model.snum],
                          @[stateStr],
                          arr1,
                          arr2,
                          @[model.stime],
                          @[model.address]];
            [labelArr22 addObjectsFromArray:labelArr2];
            break;
        case OrderPackage:
            orderType = @"家政套餐";
            //arr1服务类型
            arr1 = [NSMutableArray array];
            [arr1 insertObject:orderType atIndex:0];
            if ([model.stype isEqualToString:@"1"]) {
                [arr1 addObject:@"保洁套餐"];
            }else {
                [arr1 addObject:model.stype];
            }
            
            
            labelArr1 = @[@"订单编号：",@"订单状态：",@"服务类型："
                          ,@"套餐费用：",@"服务时间：",@"服务地点："];
            [labelArr11 addObjectsFromArray:labelArr1];
            priceStr = [NSString stringWithFormat:@"%2.f元/套（%@套）",model.price,model.count];
            labelArr2 = @[@[model.snum],
                          @[stateStr],
                          arr1,
                          @[priceStr],
                          @[model.stime],
                          @[model.address]];
            [labelArr22 addObjectsFromArray:labelArr2];
            
            break;
        case OrderEnterpriseService:
            orderType = @"企业服务";
            
            
            //arr1服务类型
            arr1 = [NSMutableArray array];
            [arr1 insertObject:orderType atIndex:0];
            if ([model.stype isEqualToString:@"1"]) {
                [arr1 addObject:@"保洁套餐"];
            }else if ([model.stype isEqualToString:@"104"]){
                [arr1 addObject:@"包月保洁"];
            }else if ([model.stype isEqualToString:@"105"]){
                [arr1 addObject:@"劳务派遣"];
            }
            
            labelArr1 = @[@"订单编号：",@"订单状态：",@"服务类型：",@"企业名称：",@"服务时间：",@"服务地点："];
            [labelArr11 addObjectsFromArray:labelArr1];
            
            labelArr2 = @[@[model.snum],
                          @[stateStr],
                          arr1,
                          @[model.companyname],
                          @[model.stime],
                          @[model.address]];
            [labelArr22 addObjectsFromArray:labelArr2];
            break;
        case OrderStorePayment:
            orderType = @"门店缴费";
            
            labelArr1 = @[@"订单编号：",@"订单状态：",@"服务类型：",@"缴费金额：",@"应付金额："];
            [labelArr11 addObjectsFromArray:labelArr1];
            
            labelArr2 = @[@[model.snum],
                          @[stateStr],
                          @[orderType],
                          @[spriceStr],
                          @[spriceStr]];
            [labelArr22 addObjectsFromArray:labelArr2];
            
            break;
                default:
            break;
    }
    return orderType;
}
#pragma mark - 支付界面UI创建
- (UIButton *)addImageAndLabe:(UIView*)view Frame:(CGRect)frame ImageName:(NSString *)imageName TitleText1:(NSString *)titleText1 TitleText2:(NSString *)titleText2 ButtonImageName:(NSString *)btnImageName ButtonImageHigeName:(NSString *)btnImageHigeName Target:(id)target action:(SEL)action lastBtn:(UIButton *)lastBtn ButtonTag:(NSInteger)btnTag
{
    //1
    UIView * tempView = [[UIView alloc]init];
    tempView.frame = frame;
    tempView.backgroundColor = [UIColor whiteColor];
    [view addSubview:tempView];
    
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:imageName];
    //    [imageView imageToNamed:imageName];
    imageView.frame = CGRectMake(kTitleMargin, (CGRectGetHeight(tempView.frame)- CGRectGetHeight(tempView.frame)/ 3 *2) / 2, CGRectGetHeight(tempView.frame) * 0.4, CGRectGetHeight(tempView.frame) * 0.4);

    imageView.centerY = CGRectGetHeight(tempView.frame) / 2;
    [tempView addSubview:imageView];
    
    CGRect labelRect1 = CGRectMake(CGRectGetMaxX(imageView.frame) + QiCaiMargin, CGRectGetMinY(imageView.frame) , MYScreenW * 0.2 ,  CGRectGetHeight(tempView.frame )* 0.3);
    UILabel * labe1 = [UILabel addLabelWithFrame:labelRect1 text:titleText1 size:12 textAlignment:NSTextAlignmentLeft];
    labe1.centerY = CGRectGetHeight(tempView.frame) * 0.33;
    [tempView addSubview:labe1];
    
    CGRect labelRect2 = CGRectMake(CGRectGetMaxX(imageView.frame) + QiCaiMargin, CGRectGetMaxY(labelRect1) , MYScreenW / 2,   CGRectGetHeight(tempView.frame )* 0.15);
    UILabel * labe2 =[UILabel addLabelWithFrame:labelRect2 text:titleText2 size:10 textAlignment:NSTextAlignmentLeft];
    [tempView addSubview:labe2];
    
    UIButton * button = [[UIButton alloc]init];
    button.frame = CGRectMake(MYScreenW - 3 * kTitleMargin, CGRectGetHeight(tempView.frame)/ 2,  CGRectGetHeight(tempView.frame), CGRectGetHeight(tempView.frame));
    button.imageView.image = [UIImage imageNamed:btnImageName];
    //    [button.imageView imageToNamed:btnImageName];
    [button setImage:[UIImage imageNamed:btnImageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:btnImageHigeName] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag = btnTag;
    button.centerY = imageView.centerY;
    [tempView addSubview:button];
    
    if (btnTag == 1) {
        lastBtn = button;
        lastBtn.selected = YES;
        
        UIButton * imagBtn = [UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(labe1.frame), 0, 22, 13) image:@"order_pay_tag_recommend" highImage:@"order_pay_tag_recommend" backgroundColor:nil Target:nil action:nil];
        imagBtn.centerY = labe1.centerY;
        [tempView addSubview:imagBtn];
        
    }
    //    if (btnTag == 2) {
    //        button.selected = YES;
    //        self.huiyuankaBtn = button;
    //    }
    UIView * oneDerline = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(labe1.frame), CGRectGetHeight(tempView.frame) - 1,CGRectGetMaxX(button.frame) - CGRectGetMinX(labe1.frame), 1)];
    oneDerline.backgroundColor = QiCaiBackGroundColor;
    [tempView addSubview:oneDerline];
    
    return button;
    
}
- (void)btnChile:(UIButton *)btn{
    
    if (btn == self.lastBtn) {
//        self.lastBtn.selected = ! self.lastBtn.selected;
    }
    else if (btn != self.lastBtn)
    {
        btn.selected = YES;
        self.lastBtn.selected = NO;
        self.lastBtn = btn;
    }
    
}
/*
 立即预定
 */
#pragma mark - 立即预定
- (void)payBtnChile{
    
    if (self.detailsModel.sprice  == 0.0  && [self.payModel.amount floatValue] == 0.0) {
        [CHMBProgressHUD showFail:@"订单数据错误，请联系 4000-999-001"];
        return;
    }
        //菊花
        [CHMBProgressHUD showProgress:nil];

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString * type;
        switch (self.payModel.payType ) {
            case payForMemCard:
                type = @"payForMemCard";
                params[@"iscard"] = self.payModel.iscard ? self.payModel.iscard : @"0";//是否使用会员卡 没有传0
                params[@"coupon"] = self.payModel.coupon ? self.payModel.coupon : @"0";//优惠券ID 没有传0
                params[@"payTypeId"] = self.payModel.stid;//充值-充值卡id
                break;
            case paymentOrder:
                type = @"paymentOrder";
                //临时
                params[@"iscard"] = self.payModel.iscard ? self.payModel.iscard : @"0";//是否使用会员卡 没有传0
                params[@"coupon"] = self.payModel.coupon ? self.payModel.coupon : @"0";//优惠券ID 没有传0
                params[@"orderId"] = self.payModel.stid;//订单id
                
                break;
            case payForOrder:
                type = @"payForOrder";
                params[@"iscard"] = self.payModel.iscard ? self.payModel.iscard : @"0";//是否使用会员卡 没有传0
                params[@"coupon"] = self.payModel.coupon ? self.payModel.coupon : @"0";//优惠券ID 没有传0
                params[@"orderId"] = self.payModel.stid;//订单id
                break;
                
            default:
                break;
        }
        
        NSString *userId = [MYUserDefaults objectForKey:@"userId"];
        params[@"userId"] = userId;
        params[@"type"] = type;// 缴费类型
        params[@"money"] = self.payModel.amount;//支付金额
        
        
        VDLog(@"%@",params);
        
        if (self.lastBtn.tag == 1) {
            
            VDLog(@"微信");
            
            //调用微信
            [self weixinPayToParameters:params];
        }else if (self.lastBtn.tag == 2) {
            
            VDLog(@"支付宝");
            
            //调用支付宝
            [self zhifubaoPayToParameters:params];
            VDLog(@"%@",self.payModel.amount);
        }else if (self.lastBtn.tag == 3) {
            
            VDLog(@"会员卡支付");
            
            //调用会员卡支付
            [self huiyuanPayToParameters:params];
            VDLog(@"%@",self.payModel.amount);
        }
}
#pragma mark - 微信支付
- (void)weixinPayToParameters:(id)params{
    
    NSString * urlString = [NSString stringWithFormat:@"%@/sendWXPay.do?",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:urlString params:params success:^(id  _Nullable responseObject) {
        NSLog(@"成功 ＝＝＝%@",responseObject);
        
        if ([responseObject[@"message"] isEqual: @0]) {
            NSMutableDictionary *dict = responseObject[@"content"];
            if(dict != nil){
                NSMutableString *retcode = [dict objectForKey:@"retcode"];
                if (retcode.intValue == 0){
                
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    //                    return @"";
                }else{
                    //                                        return [dict objectForKey:@"retmsg"];
                }
            }else{
                //                                return @"服务器返回错误，未获取到json对象";
            }
        }else{
            //                        return @"服务器返回错误";
        }

    } failure:nil];
    
}
#pragma mark - 支付宝支付
- (void)zhifubaoPayToParameters:(id)params{

    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/sendZFBPay.do?",kQICAIHttp];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"message"]  isEqual: @0])
        {
            VDLog(@"成功");
            
            
            Order *order = [[Order alloc] init];
            order = [Order mj_objectWithKeyValues:responseObject[@"content"]];
            NSString *appScheme = @"qcljToZhifubaoSchemes";
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            NSString * signedString = responseObject[@"content"][@"sign"];
            NSString *orderString = nil;
            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                           orderSpec, signedString, @"RSA"];
            NSLog(@"orderString = %@",orderString);
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
                if ([resultDic[@"resultStatus"] intValue]==9000) {
                    //进入充值列表页面
                    VDLog(@"支付宝支付成功");
                    [CHMBProgressHUD showSuccess:@"支付成功"];
                     __weak typeof(self) weakSelf = self;
                    if (weakSelf.returnOrderBlock != nil) {
                        weakSelf.returnOrderBlock();
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    return ;
                }else if ([resultDic[@"resultStatus"] intValue]==6001) {
                    [CHMBProgressHUD showPrompt:@"您已取消支付！"];
                }else if ([resultDic[@"resultStatus"] intValue]==6002) {
                    [CHMBProgressHUD showFail:@"网络连接出错！"];
                }else if ([resultDic[@"resultStatus"] intValue]==8000) {
                    [CHMBProgressHUD showFail:@"支付结果确认中"];
                }
                else{
                    NSString *resultMes = resultDic[@"memo"];
                    resultMes = (resultMes.length<=0?@"支付宝支付失败":resultMes);
                    NSLog(@"%@",resultMes);
                    
                    [CHMBProgressHUD showFail:@"支付失败"];
                }
                
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        
            
            //支付结果错误码：
            /*9000:订单支付成功
             *8000:正在处理中（"支付结果确认中"）  代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
             *4000:订单支付失败
             *6001:用户中途取消
             *6002:网络连接出错  */
            
        }else if ([responseObject[@"message"]  isEqual: @3]) {
            VDLog(@"支付宝-金额错误");
        }else if ([responseObject[@"message"]  isEqual: @4]) {
            VDLog(@"支付宝-已注册未登录");
            ThirdPartyLoginViewController * thirdPartyVC = [[ThirdPartyLoginViewController alloc]init];
            thirdPartyVC.teleNuber = self.payModel.mob;
            
            [self.navigationController pushViewController:thirdPartyVC animated:YES];
        }

    } failure:nil];
    

}
#pragma mark - 会员支付
- (void)huiyuanPayToParameters:(id)parameters{
//    memCardAction.do?method=payWithMemCard&
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/memCardAction.do?method=payWithMemCard",kQICAIHttp];
    
    if (self.detailsModel.stid == 42) {
        parameters[@"type"] = @"payment";// 缴费类型 快速缴费传
    }else{
        parameters[@"type"] = @"order";// 缴费类型 订单支付
    }
    if (self.payModel.couponLogId) {
        parameters[@"couponLogId"] = self.payModel.couponLogId;//优惠券ID
    }
    parameters[@"iscard"] = nil;//是否使用会员卡 没有传0
    //    params[@"orderId"] = self.payModel.stid;//订单编号
     [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:parameters success:^(id  _Nullable responseObject) {
         
         
         if ([responseObject[@"message"]  isEqual: @0])
         {
             VDLog(@"会员卡支付成功");
             [CHMBProgressHUD showSuccess:@"会员卡支付成功！"];
             
             //添加通知，微信成功
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHuiyuankaChangeSuccess" object:nil];
             
//              __weak typeof(self) weakSelf = self;
//             if (weakSelf.returnOrderBlock != nil) {
//                 weakSelf.returnOrderBlock();
//             }
//             [self.navigationController popToRootViewControllerAnimated:YES];
             
         }else if ([responseObject[@"message"]  isEqual: @1]) {
             VDLog(@"会员卡-不足");
             [CHMBProgressHUD showPrompt:@"会员卡余额不足"];
         }else if ([responseObject[@"message"]  isEqual: @2]) {
             VDLog(@"会员卡-订单状态错误>4");
             [CHMBProgressHUD showPrompt:@"订单状态错误"];
         }else if ([responseObject[@"message"]  isEqual: @3]) {
             VDLog(@"会员卡-线程错误");
             [CHMBProgressHUD showPrompt:@"线程错误"];
         }else if ([responseObject[@"message"]  isEqual: @4]) {
             VDLog(@"会员卡-优惠券ID错误");
             [CHMBProgressHUD showPrompt:@"优惠券ID错误"];
         }else if ([responseObject[@"message"]  isEqual: @5]) {
             VDLog(@"会员卡-优惠券已经被使用过了");
             [CHMBProgressHUD showPrompt:@"优惠券已经被使用过了"];
         }else if ([responseObject[@"message"]  isEqual: @6]) {
             VDLog(@"会员卡-优惠券已过期");
         [CHMBProgressHUD showPrompt:@"优惠券已过期"];
         }

     } failure:nil];
}
/**
 *  支付宝URl回调
 */

#pragma mark - 支付宝URl回调
- (BOOL)addAlipayOpenURL:(NSURL *)url{
    /**
     9000 订单支付成功 8000 正在处理中 4000 订单支付失败 6001 用户中途取消 6002 网络连接出错
     */
    //*支付宝
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"返回数值%@",resultDic[@"resultStatus"]);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                 __weak typeof(self) weakSelf = self;
//                if (weakSelf.returnOrderBlock != nil) {
//                    weakSelf.returnOrderBlock();
//                }
                //添加通知，支付宝成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAlipayChangeSuccess" object:nil];
                
                [CHMBProgressHUD showSuccess:@"支付成功"];
                
            }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
                [CHMBProgressHUD showFail:@"网络连接出错"];
                //                        [HUDprompt showErrorWithTitle:@"网络连接出错"];
            }else{
                [CHMBProgressHUD showPrompt:@"您已取消"];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

#pragma mark - 微信登录授权后回调
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[PayResp class]]){
        //        PayResp*response = (PayResp*)resp;
//        __weak typeof(self) weakSelf = self;
        switch(resp.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                VDLog(@"微信支付成功");
                [CHMBProgressHUD showSuccess:@"微信支付成功"];
                
                //添加通知，微信成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserWeiXinChangeSuccess" object:nil];
                
//                if (weakSelf.returnOrderBlock != nil) {
//                    weakSelf.returnOrderBlock();
//                }
//                [self.navigationController popToRootViewControllerAnimated:YES];
                //    QiCaiTabBarController *tableViewVC = [[QiCaiTabBarController alloc]init];
                //    //    tableViewVC.selectedIndex = 1;
                //    [self.navigationController pushViewController:tableViewVC animated:YES];
                break;
            case WXErrCodeUserCancel:
            {
                //                [SVProgressHUD showErrorWithStatus:@"您已经取消支付"];
                NSLog(@"微信用户取消支付: %d",resp.errCode);
                 [CHMBProgressHUD showFail:@"已取消微信支付"];
                break;
            }
            default:
                [CHMBProgressHUD showFail:@"微信支付失败"];
                NSLog(@"微信支付失败，retcode=%d",resp.errCode);
                break;
        }
        
    }
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    //    SendAuthResp *aresp = (SendAuthResp *)resp;
    //    if (aresp.errCode== 0) {
    //        NSString *code = aresp.code;
    //        NSDictionary *dic = @{@"code":code};
    //    }
    
}
#pragma mark - 把字符串根据","分割成数组
- (NSMutableArray *)setArrStr:(NSString *)arrStr{
    
    //arr1服务类型
    NSArray *econditionArr = [arrStr componentsSeparatedByString:@","];
    NSMutableArray * arr1 = [NSMutableArray array];
    //arr1服务类型
    //    [arr1 addObject:orderType];
    [arr1 addObjectsFromArray:econditionArr];
    
    return arr1;
    
}

#pragma mark - 温馨提示文字现隐触发方法
- (void)promptBtnChlie:(UIButton *)btn{
    btn.tag = !btn.tag;
    if (btn.tag == 0) {
       [UIView animateWithDuration:0.3 animations:^{
           self.messageLabel.y = CGRectGetMaxY(self.titleLabel.frame) + 8.5;
       } completion:^(BOOL finished) {
           self.titleLabel.hidden = NO;
       }];
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
             self.messageLabel.y = CGRectGetMinY(self.titleLabel.frame);
            self.titleLabel.hidden = YES;
        }];
        
       
    }
    btn.selected = btn.tag;
    
}
#pragma mark - 取消订单触发方法
- (void)cancelBtnChlie:(UIButton *)btn{
    
    //取消页面
    OrderCancelViewController * orderCancelVC = [[OrderCancelViewController alloc]init];
    /**
     *  block回调
     */
    [orderCancelVC returnOrderList:^{
        __weak typeof(self) weakSelf = self;
        if (weakSelf.returnOrderBlock != nil) {
            weakSelf.returnOrderBlock();
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    orderCancelVC.orderModel = self.orderModel;
    [self.navigationController pushViewController:orderCancelVC animated:YES];
    
//
}
//付款成功
#pragma mark --付款成功
- (void)successBtnChlie:(UIButton *)btn{
    [CHMBProgressHUD showSuccess:@"您已付款成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
//确认支付
#pragma mark --确认支付
- (void)payBtnChlie:(UIButton *)btn{
    
//    if (self.detailsModel.sprice  == 0.0) {
//        [CHMBProgressHUD showFail:@"订单数据错误，请联系 4000-999-001"];
//        return;
//    }
//    //传值支付模型初始值
    NSDictionary *dic = @{
                          @"couponLogId" : @"0",
                          @"stid" : self.orderModel.orderId,
                          @"amount" : [NSString stringWithFormat:@"%.2f",self.detailsModel.sprice],
                          };

        OrderPayViewController *myCityVC = [[OrderPayViewController alloc]init];
        /**
         *  block回调
         */
        [myCityVC returnOrderList:^{
            __weak typeof(self) weakSelf = self;
            if (weakSelf.returnOrderBlock != nil) {
                weakSelf.returnOrderBlock();
            }
        }];
        myCityVC.detailsModel = self.detailsModel;
        myCityVC.payModel = [PayModel mj_objectWithKeyValues:dic];
        [self.navigationController pushViewController:myCityVC animated:YES];

//    }
}
//确认验收
#pragma mark --确认验收
- (void)acceptanceBtnChlie:(UIButton *)btn{
//    serOrderAction.do?method=clientAcceptanceOrder&sid=&orderId=
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=clientAcceptanceOrder",kQICAIHttp];
    NSLog(@"%@",URLStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSString *userId = [MYUserDefaults objectForKey:@"userId"];
    if (params) {
        params[@"userId"] = userId;
        params[@"orderId"] = self.detailsModel.orderId;
    }
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0])
        {
            __weak typeof(self) weakSelf = self;
            if (weakSelf.returnOrderBlock != nil) {
                weakSelf.returnOrderBlock();
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [CHMBProgressHUD showSuccess:@"验收成功"];
            
            VDLog(@"确认验收");
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            [CHMBProgressHUD showFail:@"验收失败，请稍后尝试"];
            VDLog(@"参数错误");
        }
    } failure:nil];

}
//服务评价
#pragma mark --服务评价
-(void)evaluateBtnChlie:(UIButton *)btn{
    
    NSString * URLStr=  [NSString stringWithFormat:@"%@/commentAction.do?method=saveComment",kQICAIHttp];
    NSLog(@"%@",URLStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *userId = [MYUserDefaults objectForKey:@"userId"];

    params[@"userId"] = userId;
    params[@"orderId"] = self.detailsModel.orderId;
    if (self.content.text.length > 0) {
        params[@"content"] = self.content.text;// 评论内容
    }else{
        [CHMBProgressHUD showPrompt:@"请输入评价内容"];
        return;
    }
    
    params[@"level"] = [NSString stringWithFormat:@"%ld",(long)self.level];//星级
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0])
        {
            [CHMBProgressHUD showSuccess:@"评论成功"];
             __weak typeof(self) weakSelf = self;
            if (weakSelf.returnOrderBlock != nil) {
                weakSelf.returnOrderBlock();
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            VDLog(@"评论成功");
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            VDLog(@"参数错误");
        }else if ([responseObject[@"message"]  isEqual: @4]) {
            
            VDLog(@"重新登录");
        }
    } failure:nil];
}

#pragma mark - 星级回调
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    NSLog(@"%f",starRateView.scorePercent * 5);
    self.level = starRateView.scorePercent * 5;
}
#pragma mark - UITextView Delegate --隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
