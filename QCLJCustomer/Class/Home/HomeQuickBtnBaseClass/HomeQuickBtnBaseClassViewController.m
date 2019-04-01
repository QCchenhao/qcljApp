//
//  HomeQuickBtnBaseClassViewController.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/1.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "HomeQuickBtnBaseClassViewController.h"
#import "CHMBProgressHUD.h"
#import "OrderViewController.h"

#import "GaodePOIViewController.h"

@interface HomeQuickBtnBaseClassViewController ()<PopDelegate,UIGestureRecognizerDelegate>

@end

@implementation HomeQuickBtnBaseClassViewController
- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    //    CGRectGetWidth(self.view.frame)-80 + 2
    _showView = [[SQMenuShowView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.homeDurationBtn.frame),CGRectGetMaxY(self.durationView.frame) - CGRectGetMinY(self.homeDurationBtn.frame),CGRectGetWidth(self.homeDurationBtn.frame),0) items:self.popArr
                                               showPoint:(CGPoint){CGRectGetWidth(self.view.frame) - 5,10}];
    _showView.sq_backGroundColor = QiCaiBackGroundColor;
    //添加手势
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noShowViewTapGesture)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    [self.scrollView addSubview:_showView];
    VDLog(@"%f",CGRectGetMaxY(self.durationView.frame));
    return _showView;
}
- (void)noShowViewTapGesture{
    self.isShow = NO;
    [self.showView dismissView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if (![touch.view isKindOfClass:[SQMenuShowView class]]) {
        self.isShow = NO;
        [self.showView dismissView];
        return NO;
    }
    return YES;
}

- (NSMutableArray *)nannyPetArr{
    if (!_nannyPetArr) {
        _nannyPetArr = [NSMutableArray array];
    }
    return _nannyPetArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"Main_public_left" action:@selector(back) target:self];

}
- ( UILabel *)addSlider:(UIView *)sliderVeiw labelImage:(NSString *)labelImage titleLabelText:(NSString *)titleLabelText showLabel:(NSString *)showLabelText endStrRichLabel:(NSString * )endStrRichLabel sliderArr:(NSArray *)sliderArr unit:(NSString *)unit {

    
    UILabel * label = [[UILabel alloc]init];
    label = [UILabel addLeftImageAndLabelWithImgeName:[UIImage imageNamed:labelImage] interval:3 frame:CGRectMake(10, 10, CGRectGetWidth(sliderVeiw.frame) * 0.5, CGRectGetHeight(sliderVeiw.frame) / 4) imageFrame:CGRectZero text:titleLabelText textColor:[UIColor blackColor] backgroundColor:nil size:12 textAlignment:NSTextAlignmentLeft];
    [sliderVeiw addSubview:label];
    
    UILabel * showLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetWidth(sliderVeiw.frame)  * 0.65 - 21.4, 10, CGRectGetWidth(sliderVeiw.frame) * 0.35, CGRectGetHeight(sliderVeiw.frame) / 4) text:showLabelText size:13 textAlignment:NSTextAlignmentRight];
    [sliderVeiw addSubview:showLabel];
    
    [UILabel setRichLabelText:showLabel startStr:nil endStr:endStrRichLabel font:showLabel.font color:QiCaiNavBackGroundColor];


    JLDoubleSlider* slider = [[JLDoubleSlider alloc]initWithFrame:CGRectMake(CGRectGetWidth(sliderVeiw.frame) * 0.134 , CGRectGetMaxY(label.frame),CGRectGetWidth(sliderVeiw.frame) * 0.8, CGRectGetHeight(sliderVeiw.frame) - CGRectGetMaxY(label.frame)) jointArr:sliderArr unit:unit];
    
     NSRange range = [endStrRichLabel rangeOfString:@"m²"];
    
    if (range.location != NSNotFound) {
        self.minHouseNum = sliderArr[0];
        self.maxHouseNum = sliderArr[sliderArr.count - 1];
    }else {
        self.minPriceNum = sliderArr[0];
        self.maxPriceNum = sliderArr[sliderArr.count - 1];
    }

    
    slider.sliderBlock = ^(NSString * currentMinValue, NSString * currentMaxValue){
        if (unit) {
            showLabel.text = [NSString stringWithFormat:@"%@~%@%@%@",currentMinValue,currentMaxValue,unit,endStrRichLabel];
        }else{
            showLabel.text = [NSString stringWithFormat:@"%@~%@%@",currentMinValue,currentMaxValue,endStrRichLabel];
        }
        
        [UILabel setRichLabelText:showLabel startStr:nil endStr:endStrRichLabel font:showLabel.font color:QiCaiNavBackGroundColor];


       

        if (range.location != NSNotFound) {
            self.minHouseNum = currentMinValue;
            self.maxHouseNum = currentMaxValue;
        }else {
            self.minPriceNum = currentMinValue;
            self.maxPriceNum = currentMaxValue;

        }
    };
    [sliderVeiw addSubview:slider];
    return showLabel;
}
- (UIButton * )demandToView:(UIView *)bacView titleArrty:(NSArray *)titleArrty startY:(CGFloat)startY col:(NSInteger)col defaultBtn:(UIButton *)defaultBtn startX:(CGFloat)startX margin:(CGFloat)margin target:(id)target action:(SEL)action{

    
//    CGFloat startX = 34;//整个九宫格的位置
//    CGFloat  margin = 34;
    CGFloat width = (MYScreenW - startX - (col - 1) * margin - 8.5) / col;
    CGFloat height = 29;
    CGFloat CWstartY = startY ;//45;
    //    NSArray * titleArrty = @[@"学历",@"星座",@"属相",@"好评率",@"培训经历",@"证件"];
    for (int i = 0; i < titleArrty.count; i++) {
        UIButton *meView = [[UIButton alloc]init];
        
        
        if ( i == 0) {
            if ([titleArrty[0] isEqualToString:@"住家"] || [titleArrty[0] isEqualToString:@"一星"] || [titleArrty[0] isEqualToString:@"男宝宝"] || [titleArrty[0] isEqualToString:@"1~6个月"]) {
                meView.selected = YES;
                defaultBtn = meView;
            }
            
        }else if (i == titleArrty.count - 1){
            if ([titleArrty[titleArrty.count - 1] isEqualToString:@"中性"]){
                meView.selected = YES;
                defaultBtn = meView;
            }
        }
        meView.width = width;
        meView.height = height;
        NSInteger row = i / col;//行号
        NSInteger CWcol = i % col;//列号
        meView.x = startX + (width +  margin) * CWcol;
        meView.y = CWstartY + (height + 8.5) * row;
        
        [meView setTitle:titleArrty[i] forState:UIControlStateNormal];
        [meView.titleLabel setFont:[UIFont systemFontOfSize:10]];
        

        
        [meView setBackgroundImage:[UIImage imageWithName:@"home_radio_off"] forState:UIControlStateNormal];
        [meView setBackgroundImage:[UIImage imageWithName:@"home_radio_on"] forState:UIControlStateSelected];
       
        
//        if (titleArrty.count == 2) {
//            
//        }else{
//            [meView setBackgroundImage:[UIImage imageNamed:@"home_radio_off"] forState:UIControlStateNormal];
//            [meView setBackgroundImage:[UIImage imageNamed:@"home_radio_on"] forState:UIControlStateSelected];
//        }
        meView.tag = i + 1000;
        
        [meView setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [meView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [bacView addSubview:meView];
    }
//    UIButton * leftMsgBg = (UIButton *)[bacView viewWithTag:1000];
    

    return defaultBtn;
}




/*
 服务时间
 */
- (void)dateBtnChlie:(UIButton *)btn{
    
//    self.isShow = NO;
//    [self.showView dismissView];
    
    /** 自定义日期选择器 */
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:self.view.frame];
    //距离当前日期的年份差（设置最大可选日期）
    datePickVC.maxYear = -2;
    //设置最小可选日期(年分差)
    datePickVC.minYear = 0;
//    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor =  QiCaiNavBackGroundColor;
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
        [self.dateBtn setTitle:selectDate forState:UIControlStateNormal];
        [self.dateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                      imageTitleSpace:13];
        self.homeDateStr = selectDate;
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
}

/*
 服务地址
 */
- (void)addressBtnChlie:(UIButton *)btn{
    
    //    [btn setTitle:@"fdfd" forState:UIControlStateNormal];
    //    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
    //                         imageTitleSpace:13];
    
    __weak typeof(self) weakSelf = self;
    if ([MYUserDefaults objectForKey:@"userId"]) {//登录
        
        NSString * addressStr  = [MYUserDefaults objectForKey:@"addressId"];
        if (([addressStr isEqualToString:@""] || [addressStr isEqualToString:@"default"]) || [self.addressLabel.text isEqualToString:@"请选择服务地址"]) {
            
            GaodePOIViewController * detailsVC = [[GaodePOIViewController alloc]init];
            [CHMBProgressHUD showProgress:nil];
            detailsVC.isHomeorder = @"201";
            detailsVC.GaodePOIBlock = ^(NSString * address , NSString * adderssID){
                weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@",address];
                weakSelf.homeAddressId = adderssID;
            };
            
            [weakSelf.navigationController pushViewController:detailsVC animated:YES];

            
        }else{
            ServiceAddressViewController * serviceAddVC = [[ServiceAddressViewController alloc]init];
            [serviceAddVC returnAddText:^(NSString *address ,NSString *adderssID) {
                
                weakSelf.homeAddressId = adderssID;
                weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@",address];
            }];
            [weakSelf.navigationController pushViewController:serviceAddVC animated:YES];
        }
        
    }else{
        
        GaodePOIViewController * detailsVC = [[GaodePOIViewController alloc]init];
        [CHMBProgressHUD showProgress:nil];
        detailsVC.isHomeorder = @"200";
        detailsVC.GaodePOIBlock = ^(NSString * address  , NSString * adderssID){
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@",address];
        };
        
        [weakSelf.navigationController pushViewController:detailsVC animated:YES];

    }
    

   

}

/*
 其他
 */
- (void)otherButtonChlie:(UIButton *)btn{
    
    if (btn.selected == YES) {
        
        btn.selected = NO;
        [btn setTitle:self.otherArr[btn.tag - 1000] forState:UIControlStateNormal];
        ;
        self.otherInder = nil;
        switch (btn.tag - 1000) {
            case 0:
                self.homeOtherEducationStr = nil;
                break;
            case 1:
                self.homeOtherAgeStr = nil;
                break;
            case 2:
                self.homeOtherCertificatesStr = nil;
                break;
                
            default:
                break;
        }
        
    }else{
        
        self.otherInder = btn.tag;
        switch (btn.tag) {
            case 1000 + 0:
                [CHMBProgressHUD showPromptWithTitle:@"选择学历" buttonArr:self.otherEducationArr];
                
                break;
            case 1000 + 1:
                [CHMBProgressHUD showPromptWithTitle:@"选择年龄" buttonArr:self.otherAgeArr];
                break;
            case 1000 + 2:
                [CHMBProgressHUD showPromptWithTitle:@"上岗资格证" buttonArr:self.otherCertificatesArr];
                break;
                
            default:
                break;
        }
        
    }
    
//    [CHMBProgressHUD shareinstance].popDelegate = self;
}
#pragma mark - popDelegate--弹窗代理方法
- (void)PopButton:(UIButton *)PopButton{
    
    NSString * temp = PopButton.titleLabel.text;
    if ([temp isEqualToString:@"确定"]) {
         [self.navigationController popViewControllerAnimated:YES];
    }else if ([temp isEqualToString:@"继续下单"]){
        
    }else {//出现是否退出的弹框
        if (self.otherInder) {
            
            UIButton * leftMsgBg = (UIButton *)[self.otherView viewWithTag:self.otherInder];
            
            VDLog(@"%@",leftMsgBg.titleLabel.text);
            
            leftMsgBg.selected = !leftMsgBg.selected;
            
            switch (leftMsgBg.tag) {
                case 1000 + 0:
                    
                    self.homeOtherEducationStr = self.otherEducationArr[PopButton.tag];
                    [leftMsgBg setTitle:self.homeOtherEducationStr forState:UIControlStateNormal];
                    
                    break;
                case 1000 + 1:
                    
                    self.homeOtherAgeStr = self.otherAgeArr[PopButton.tag];
                    [leftMsgBg setTitle:self.homeOtherAgeStr forState:UIControlStateNormal];
                    
                    break;
                case 1000 + 2:
                    
                    self.homeOtherCertificatesStr = self.otherCertificatesArr[PopButton.tag];
                    [leftMsgBg setTitle:self.homeOtherCertificatesStr forState:UIControlStateNormal];
                    if ([self.homeOtherCertificatesStr isEqualToString:@"无资格"]) {
                        self.homeOtherCertificatesStr = @"无";
                    }else{
                        self.homeOtherCertificatesStr = @"有";
                    }
                    break;
                    
                default:
                    break;
            }
            
            VDLog(@"%@%@%@",self.homeOtherEducationStr,self.homeOtherAgeStr,self.homeOtherCertificatesStr);
            
        }

    }
    [CHMBProgressHUD hide];
    
}
/*
 住家
 */
- (void)homeButtonChlie:(UIButton *)btn{
    if (btn == self.homeBtn) {
        self.homeBtn.selected = YES;
    }
    else if (btn != self.homeBtn)
    {
        btn.selected = YES;
        self.homeBtn.selected = NO;
        self.homeBtn = btn;
    }
    
}
/*
 服务时长
 */
- (void)homeDurationBtnChlie:(UIButton *)btn{
    
    self.isShow = !self.isShow;
    
    btn.selected = self.isShow;

    if (self.isShow) {
        [self.showView showView];
        
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[btn convertRect: btn.bounds toView:window];
        int offset = rect.origin.y + 62 - (self.view.frame.size.height - 170.0);//键盘高度216
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if (offset > 0) {
                [self.scrollView setContentOffset:CGPointMake(0,200) animated:YES];
            }
            
        } completion:^(BOOL finished) {
            //        _scrollView.contentSize = scrSize;
        }];

        
    }else{
        [self.showView dismissView];
    }
    
    
    
    
}

///*
// 口味
// */
//- (void)flavorButtonChlie:(UIButton *)btn{
//    if (btn == self.homeFlavorBtn1) {
//        self.homeFlavorBtn1.selected = YES;
//    }
//    else if (btn != self.homeFlavorBtn1)
//    {
//        btn.selected = YES;
//        self.homeFlavorBtn1.selected = NO;
//        self.homeFlavorBtn1 = btn;
//    }
//}
///*
// 宠物
// */
//- (void)petButtonChlie:(UIButton *)btn{
//    
//    btn.selected = !btn.selected;
//    
//    if (btn.selected == YES) {
//        [self.nannyPetArr addObject:btn.titleLabel.text];
//        
//        //         NSLog( @"%@",self.petArr);
//        
//    }else{
//        [self.nannyPetArr removeObject:btn.titleLabel.text];
//    }
//    
//    
//}
- (void)AFNPlaceOrderWith:(NSString *)orderType btn:(UIButton *)btn{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    self.homeOrderType = orderType;//服务类型
    
    params[@"orderType"] = self.homeOrderType;//订单类型 保姆 *
   
    //月嫂
    if ([self.homeOrderType isEqualToString:@"22"]){
        params[@"smoney"] = [NSString stringWithFormat:@"%ld",self.starBtn.tag - 1000 + 1];//星级
    }
    //育儿嫂
    if ([self.homeOrderType isEqualToString:@"24"]){

        params[@"babySex"] = self.menAndWomenBtn.titleLabel.text;
        params[@"babyAge"] = self.babyAgeBtn.titleLabel.text;
    }
    //保姆
    if ([self.homeOrderType isEqualToString:@"25"]){
        params[@"house"] = self.homeSliderHouseLabel.text;//住房大小* 没有传0
//        params[@"mprice"] = self.homeSliderPriceLabel.text;//心理价位
        params[@"mprice"] = [NSString stringWithFormat:@"%@-%@",self.minPriceNum,self.maxPriceNum];
        if (self.homeFlavorBtn1.titleLabel.text.length > 0 ) {
            params[@"eat"] = self.homeFlavorBtn1.titleLabel.text;//口味
        }else{
            [CHMBProgressHUD showPrompt:@"请选择烧饭口味"];
            return;
        }
        
    }else{

    }
    //育儿嫂 保姆 共有项
    if ([self.homeOrderType isEqualToString:@"24"] || [self.homeOrderType isEqualToString:@"25"]) { // 24 25 类型有住家选项 和 服务时长选项
        NSString * ishome;
        if ([self.homeBtn.titleLabel.text isEqualToString:@"住家"]) {
            ishome = @"1";
        }else{
            ishome = @"0";
        }
        params[@"ishome"] = ishome;//是否住家
        
        params[@"smins"] = self.homeDurationStr;//服务时长
        
//        params[@"mprice"] = self.homeSliderPriceLabel.text;//心理价位*
        params[@"mprice"] = [NSString stringWithFormat:@"%@-%@",self.minPriceNum,self.maxPriceNum];

        
    }else{
        
    }
    
    //保洁套餐
    if ([self.homeOrderType isEqualToString:@"40"]) {
        params[@"count"] = self.cleaningServiceNuber;//套餐数量*
        params[@"stype"] = @"1";
    }
    
    //企业服务
    if ([self.homeOrderType isEqualToString:@"41"]) {
        if (self.enterpriseTextField.text.length > 0) {
            params[@"companyName"] = self.enterpriseTextField.text;//套餐数量*
        }else{
            [CHMBProgressHUD showPrompt:@"请输入企业名称"];
            return;
        }
        NSString * temp ;
        if ([self.homeDurationBtn.titleLabel.text isEqualToString:@"包月保洁"]) {
            temp = @"104";//包月保洁
        }else{
            temp = @"105";//劳务派遣
        }
        params[@"stype"] = temp;
    }
    
    //服务时间
    if (self.homeDateStr) {
        params[@"stime"] = self.homeDateStr;//服务时间（月嫂对应的就是预产期）
    }else{
        [self.dateBtn.titleLabel setTextColor:QiCaiNavBackGroundColor];
        [CHMBProgressHUD showPrompt:@"请选择您的服务时间"];
        return;
    }
    
    NSString *petStr;
    if (self.nannyPetArr.count > 0) {
        petStr = [self.nannyPetArr componentsJoinedByString:@" "];
        params[@"pet"] = petStr;//宠物
    }
    
    NSString * name = [MYUserDefaults objectForKey:@"name"];
    if ([name isEqualToString:@"default"]) {
        
        if (self.nameChTextFile.text.length > 0) {
            if ( [NSString checkUserName:self.nameChTextFile.text]) {
                params[@"name"] = self.nameChTextFile.text;//联系人
            }else{
                [CHMBProgressHUD showPrompt:@"请输入正确联系人"];
                return;
            }
        }else{
            [CHMBProgressHUD showPrompt:@"请输入联系人"];
            return;
        }
        
    }
    
    //
    NSString * URLStr;
    NSString * userIdStr = [MYUserDefaults objectForKey:@"userId"];
    if (userIdStr) {
        
        params[@"userId"] = userIdStr;// *
        
        self.homeAddressId = [MYUserDefaults objectForKey:@"addressId"];
        if (self.homeAddressId && ![self.homeAddressId isEqualToString:@""]) {
            params[@"addressId"] = self.homeAddressId;//常用地址
        }else{
            [CHMBProgressHUD showPrompt:@"请选择服务地址"];
            return;
        }
        
        URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=saveSerOrder",kQICAIHttp];
        
    }else{//未登录
        
        //未登录下单接口
        URLStr=  [NSString stringWithFormat:@"%@/serOrderAction.do?method=loginAndSaveSerOrder",kQICAIHttp];
        params[@"userType"] = @"1";//0 阿姨 1雇主 2 经销商
        
        //请输入联系人
        if ( [NSString checkUserName:self.nameChTextFile.text]) {
            params[@"name"] = self.nameChTextFile.text;
        }else{
            [CHMBProgressHUD showPrompt:@"请输入联系人"];
            return;
        }
        //请输入正确手机号
        if ( [NSString checkMobile:self.telephoneChTextFile.text]) {
            params[@"mob"] = self.telephoneChTextFile.text;
        }else{
            [CHMBProgressHUD showPrompt:@"请输入正确手机号"];
            return;
        }
        
        //请选择服务地址
        if (self.addressLabel.text.length > 0 && ![self.addressLabel.text isEqualToString:@"请选择服务地址"]) {
            
            params[@"address"] = self.addressLabel.text;
        }else{
            [CHMBProgressHUD showPrompt:@"请选择服务地址"];
            return;
        }
        
    }
    
    params[@"edu"] = self.homeOtherEducationStr;
    params[@"age"] = self.homeOtherAgeStr;
    params[@"paper"] = self.homeOtherCertificatesStr;
    
    //设定5秒
    btn.acceptEventInterval = 5;
    
    [CHMBProgressHUD showProgress:nil];
    
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @3]) {
            
            VDLog(@"参数错误");
            
        }else if ([responseObject[@"message"]  isEqual: @0])
        {
            
            [CHMBProgressHUD showSuccess:@"订单提交成功"];
            
//            [self.navigationController popToRootViewControllerAnimated:YES];

            if (userIdStr) {
                
                [MYUserDefaults setObject:self.nameChTextFile.text forKey:@"name"];
                [MYUserDefaults setObject:self.addressLabel.text forKey:@"address"];
                [MYUserDefaults setObject:self.homeAddressId forKey:@"addressId"];
                [MYUserDefaults synchronize];
            }
            if (self.returnHomeBlock != nil) {
                self.returnHomeBlock();
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            VDLog(@"重新登录");
            __weak typeof(self) weakSelf = self;
            ThirdPartyLoginViewController * thirdPartyVC = [[ThirdPartyLoginViewController alloc]init];
            thirdPartyVC.teleNuber = self.telephoneChTextFile.text;
            [thirdPartyVC returnText:^(UIImage *ueseImage, NSString *nameStr, NSString *mobStr, NSString *adderss) {
                if (nameStr) {
                    weakSelf.nameChTextFile.text = nameStr;
                    weakSelf.nameChTextFile.userInteractionEnabled = NO;//禁止编辑
                }
                //当未登录状态下可以输入地址
                if ([MYUserDefaults objectForKey:@"userId"]) {
                    weakSelf.addressTEmpView.hidden = NO;
//                    self.addressTextField.hidden = YES;
                }
                
                weakSelf.telephoneChTextFile.text = mobStr;

                //提交地址
                if ([weakSelf.addressLabel.text isEqualToString:adderss]) {
                    weakSelf.homeAddressId = [MYUserDefaults objectForKey:@"addressId"];
                }else{
                    [weakSelf setAddress:weakSelf.addressLabel.text];
                }
                
                weakSelf.telephoneChTextFile.userInteractionEnabled = NO;//禁止编辑
            }];
            [weakSelf.navigationController pushViewController:thirdPartyVC animated:YES];
            
        }
    } failure:^(NSError * _Nonnull error) {
        
        [CHMBProgressHUD showFail:@"网络失败，请稍后再试"];
    }];
        
}
- (void)setAddress:(NSString *)adderss{

    NSString * userIdStr = [MYUserDefaults objectForKey:@"userId"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = userIdStr;// *
    params[@"address"] = adderss;

    NSString * URLStr = [NSString stringWithFormat:@"%@/addressAction.do?method=saveAddresses",kQICAIHttp];;
    [[HttpRequest sharedInstance] post_Internet_general_getWithTarget:self tableView:nil modelArr:nil url:URLStr params:params success:^(id  _Nullable responseObject) {
        if ([responseObject[@"message"]  isEqual: @0]) //0 成功
        {
            [MYUserDefaults setObject:adderss forKey:@"address"];
            [MYUserDefaults setObject:responseObject[@"id"] forKey:@"addressId"];
            [MYUserDefaults synchronize];
            
             self.homeAddressId = [MYUserDefaults objectForKey:@"addressId"];
            
        }else if ([responseObject[@"message"]  isEqual: @4])//4重新登录
        {
            
        }else if ([responseObject[@"message"]  isEqual: @2]) {
            
            
        }
    } failure:nil];
}
//#pragma mark --PopDelegate代理方法
//- (void)PopButton:( NSInteger)PopButtonIndex{
//    
//    [CHMBProgressHUD hide];
//    VDLog(@"popView按钮个数===%ld",PopButtonIndex);
//}

-(void)back
{
    [CHMBProgressHUD showPromptWithMessage:@"订单快要完成了，您确定离开吗？" buttonArr:@[@"确定",@"继续下单"]];
        [CHMBProgressHUD shareinstance].popDelegate = self;
}
- (void)dealloc
{
    self.returnKeyHandler = nil;
}
@end
