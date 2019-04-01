//
//  CHMBProgressHUD.m
//  gaodePOI
//
//  Created by QCJJ－iOS on 16/10/13.
//  Copyright © 2016年 QCJJ－iOS. All rights reserved.
//

#import "CHMBProgressHUD.h"
#import "Comment.h"

//#import "CHPopView.h"

@interface CHMBProgressHUD ()<UIGestureRecognizerDelegate>
//{
//    UITapGestureRecognizer *tap;
//}
@property (nonatomic,strong) UITapGestureRecognizer *tap;

@end
@implementation CHMBProgressHUD

#pragma mark - 单例
+(instancetype)shareinstance{
    
    static CHMBProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CHMBProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(CHProgressMode )myMode{
    [self show:msg inView:view mode:myMode customImgView:nil];
}
//#pragma mark - 自定义弹窗
#pragma mark - 根方法--自定义弹窗
+(void)showPopView:(UIView *)view mode:(CHProgressMode )myMode title:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr {

    [[CHMBProgressHUD shareinstance] addGestureInView:view];//添加手势  点击屏幕隐藏
    
    //如果已有弹框，先消失
    if ([CHMBProgressHUD shareinstance].hud != nil) {
        [[CHMBProgressHUD shareinstance].hud hide:YES];
        [CHMBProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [CHMBProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //[YJProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [CHMBProgressHUD shareinstance].hud.color = [UIColor whiteColor];
    //    [CHMBProgressHUD shareinstance].hud.alpha = 0.4;//设置透明度
    [CHMBProgressHUD shareinstance].hud.labelColor = [UIColor blackColor];
    //    [CHMBProgressHUD shareinstance].hud.detailsLabelText = @"dsfd";
    [[CHMBProgressHUD shareinstance].hud setMargin:10];//圆角属性
    [[CHMBProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
//    [CHMBProgressHUD shareinstance].hud.labelText = msg;
    //    [CHMBProgressHUD shareinstance].hud.dimBackground = YES;//渐变层
    [CHMBProgressHUD shareinstance].hud.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
    
    [CHMBProgressHUD shareinstance].hud.labelFont = [UIFont systemFontOfSize:14];
     [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;

    
    switch ((NSInteger)myMode) {
//        case CHProgressModeOnlyText:
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
//            break;
//            
//        case CHProgressModeLoading:
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
//            [CHMBProgressHUD shareinstance].hud.labelColor = [UIColor whiteColor];
//            [CHMBProgressHUD shareinstance].hud.color = [UIColor blackColor];
//            [CHMBProgressHUD shareinstance].hud.backgroundColor = [UIColor clearColor];
//            break;
//            
//            
//            //                    case CHProgressModeCircleLoading:{
//            //                        [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
//            //
//            //                        break;
//            //                    }
        case CHProgressModeSuccess://成功
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            
            [CHMBProgressHUD shareinstance].hud.customView = [self showPopViewWhitImage:@"pop_success" title:title message:message mode:(CHProgressMode )myMode buttonArr:buttonArr ];
            
            break;
        case CHProgressModeFail://失败
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [CHMBProgressHUD shareinstance].hud.customView = [self showPopViewWhitImage:@"pop_fail" title:title message:message mode:(CHProgressMode )myMode buttonArr:buttonArr ];
            
            break;
        case CHProgressModePrompt://提示
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [CHMBProgressHUD shareinstance].hud.customView = [self showPopViewWhitImage:@"pop_prompt" title:title message:message mode:(CHProgressMode )myMode buttonArr:buttonArr];

            
            break;
        case CHProgressModeChoice://选择框
            //            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            
            [CHMBProgressHUD shareinstance].hud.customView = [self showPopViewWhitImage:@"pop_prompt" title:title message:message mode:(CHProgressMode )myMode buttonArr:buttonArr];
            
            
            break;
        case CHProgressModeUpdate://更新
            
            [CHMBProgressHUD shareinstance].hud.customView = [self showPopViewWhitImage:@"pop_update" title:title message:message mode:(CHProgressMode )myMode buttonArr:buttonArr];
            
            
            break;
            
        default:
            break;
    }

    

}
#pragma mark - 根方法--菊花
+(void)show:(NSString *)msg inView:(UIView *)view mode:(CHProgressMode )myMode customImgView:(UIView *)customView{
    
    [[CHMBProgressHUD shareinstance] addGestureInView:view];//添加手势  点击屏幕隐藏
    
    //如果已有弹框，先消失
    if ([CHMBProgressHUD shareinstance].hud != nil) {
        [[CHMBProgressHUD shareinstance].hud hide:YES];
        [CHMBProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    //    [CHMBProgressHUD shareinstance].hud.userInteractionEnabled = NO;//当弹窗出现时可以点击其他方法
    [CHMBProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //[YJProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    
    //是否设置黑色背景，这两句配合使用
    [CHMBProgressHUD shareinstance].hud.color = [UIColor whiteColor];
//    [CHMBProgressHUD shareinstance].hud.alpha = 0.4;//设置透明度
    [CHMBProgressHUD shareinstance].hud.labelColor = [UIColor blackColor];
//    [CHMBProgressHUD shareinstance].hud.detailsLabelText = @"dsfd";
    [[CHMBProgressHUD shareinstance].hud setMargin:10];//圆角属性
    [[CHMBProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [CHMBProgressHUD shareinstance].hud.labelText = msg;
//    [CHMBProgressHUD shareinstance].hud.dimBackground = YES;//渐变层
    [CHMBProgressHUD shareinstance].hud.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];

    [CHMBProgressHUD shareinstance].hud.labelFont = [UIFont systemFontOfSize:14];
    
    
    switch ((NSInteger)myMode) {
        case CHProgressModeOnlyText:
            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;
            
        case CHProgressModeLoading:
            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            [CHMBProgressHUD shareinstance].hud.labelColor = [UIColor whiteColor];
            [CHMBProgressHUD shareinstance].hud.color = [UIColor blackColor];
            [CHMBProgressHUD shareinstance].hud.backgroundColor = [UIColor clearColor];
            break;
       
            
//                    case CHProgressModeCircleLoading:{
//                        [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
//            
//                        break;
//                    }
//        case CHProgressModeSuccess://成功
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
//
//            customView = [self showPopViewWhitImage:@"home_cleaning" title:@"温馨提示" message:@"订单支付成功" buttonArr:@[@"继续支付",@"确定离开"] ];
//            [CHMBProgressHUD shareinstance].hud.customView = customView;
//            
//            break;
//        case CHProgressModeFail://失败
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
//            
//            customView = [self showPopViewWhitImage:@"home_enterpriseService" title:@"温馨提示" message:@"订单支付还未完成，您确定离开吗？" buttonArr:@[@"继续支付",@"确定离开"] ];
//            [CHMBProgressHUD shareinstance].hud.customView = customView;
//            
//            break;
//        case CHProgressModePrompt://提示
//            [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
//            
//            customView = [self showPopViewWhitImage:@"home_storeConsumption" title:@"温馨提示" message:@"订单支付还未完成，您确定离开吗？" buttonArr:@[@"继续支付",@"确定离开"]];
//            [CHMBProgressHUD shareinstance].hud.customView = customView;
//            
//            break;
            
        default:
            break;
    }
    
    

    
}
//左右按钮图片
+ (UIView *)showPopViewWhitImage:(NSString *)imageName title:(NSString *)title message:(NSString *)message mode:(CHProgressMode )myMode buttonArr:(NSArray *)buttonArr{
    
    UIView * contentView =  [[UIView alloc]init];
    
    contentView.backgroundColor = [UIColor whiteColor];
    //    contentView.frame = CGRectMake(0, 0, MYScreenW * 0.8, MYScreenH * 0.322);
    contentView.frame = CGRectMake(0, 0, MYScreenW * 0.8, MYScreenH * 0.27);
    contentView.layer.cornerRadius = CGRectGetWidth(contentView.frame) * 0.03;
    
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 20, 50, 50);
    //    imageView.backgroundColor = [UIColor yellowColor];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.centerX = CGRectGetWidth(contentView.frame) / 2;
    [contentView addSubview:imageView];
    
    //title
    UILabel *titleLabel = [UILabel addLabelWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) , CGRectGetWidth(contentView.frame),27) text:title textColor:[UIColor blackColor] backgroundColor:nil size:14 textAlignment:NSTextAlignmentCenter lineSpacing:0 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
    //    titleLabel.backgroundColor = [UIColor redColor];
    [contentView addSubview:titleLabel];
    
    
    
    //    titleLabel.backgroundColor = [UIColor yellowColor];
    
    //分割线
    if (message && buttonArr.count > 0 ) {
        
        UIView * line = [[UIView alloc]init];
        line.frame = CGRectMake(0, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 05, CGRectGetWidth(contentView.frame), 1);
        line.backgroundColor = QiCaiBackGroundColor;
        [contentView addSubview:line];
        
        //message 内容
        if (message) {
            
            
            if (message.length > 19) {
                UILabel * messageLabel = [UILabel addLabelWithFrame:CGRectMake(0, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 4, CGRectGetWidth(contentView.frame),25) text:message textColor:[UIColor darkGrayColor] backgroundColor:nil size:11 textAlignment:NSTextAlignmentCenter lineSpacing:3 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
                //            messageLabel.backgroundColor = [UIColor yellowColor];
                [contentView addSubview:messageLabel];
                messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
                
                CGSize size = [messageLabel sizeThatFits:CGSizeMake(titleLabel.frame.size.width, MAXFLOAT)];
                messageLabel.frame = CGRectMake(28, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 2].frame) + 10, CGRectGetWidth(contentView.frame) * 0.78,size.height + 3);
            }else{
                UILabel * messageLabel = [UILabel addLabelWithFrame:CGRectMake(0, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 4, CGRectGetWidth(contentView.frame),25) text:message textColor:[UIColor darkGrayColor] backgroundColor:nil size:11 textAlignment:NSTextAlignmentCenter lineSpacing:0 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
                //            messageLabel.backgroundColor = [UIColor yellowColor];
                [contentView addSubview:messageLabel];
            }
            
            
        }
        
        if (buttonArr) {//如果有按钮
            if ( buttonArr.count == 2 && myMode != CHProgressModeUpdate && myMode != CHProgressModeChoice) {//按钮数量为2
                for (NSInteger i = 0; i < buttonArr.count; i++) {
                    if (i == 0) {
                        UIButton * lbt = [UIButton addPopButtonWhiteTitle:buttonArr[i] frame:CGRectMake(20, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 10, (CGRectGetWidth(contentView.frame) - 20 * 2 - 20 ) / 2, 30) titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor whiteColor] layerBorderColor:QiCaiBackGroundColor Target:[CHMBProgressHUD shareinstance] action:@selector(popButtonChlie:)];
                        lbt.tag = i;
                        [contentView addSubview:lbt];
                    }else if(i == 1) {
                        UIButton * rbt = [UIButton addPopButtonWhiteTitle:buttonArr[i] frame:CGRectMake(20 + 10 + (CGRectGetWidth(contentView.frame) - 20 * 2 - 20 ) / 2, CGRectGetMinY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame), (CGRectGetWidth(contentView.frame) - 20 * 2 - 20 ) / 2, 30) titleColor:[UIColor whiteColor] backgroundColor:QiCaiNavBackGroundColor layerBorderColor:QiCaiNavBackGroundColor Target:[CHMBProgressHUD shareinstance] action:@selector(popButtonChlie:)];
                        rbt.tag = i;
                        [contentView addSubview:rbt];
                        
                    }
                    
                }
                
            }else if ( buttonArr && buttonArr.count == 1){//按钮数量为1
                UIButton * rbt = [UIButton addPopButtonWhiteTitle:buttonArr[0] frame:CGRectMake(0, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 8, CGRectGetWidth(contentView.frame) * 0.637, 30) titleColor:[UIColor whiteColor] backgroundColor:QiCaiNavBackGroundColor layerBorderColor:QiCaiNavBackGroundColor Target:[CHMBProgressHUD shareinstance] action:@selector(popButtonChlie:)];
                rbt.tag = 0;
                rbt.centerX = CGRectGetWidth(contentView.frame) / 2;
                [contentView addSubview:rbt];
                
            }else if ( buttonArr.count == 2 && myMode == CHProgressModeUpdate) {//按钮数量为2 为更新
                for (NSInteger i = 0; i < buttonArr.count; i++) {
                    if (i == 0) {
                        UIButton * lbt = [UIButton addPopButtonWhiteTitle:buttonArr[i] frame:CGRectMake(20, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 10, 200, 35) titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor whiteColor] layerBorderColor:QiCaiBackGroundColor Target:[CHMBProgressHUD shareinstance] action:@selector(popButtonChlie:)];
                        lbt.tag = i;
                        [lbt setBackgroundImage:[UIImage imageNamed:@"pop_update_off"] forState:UIControlStateNormal];
                        lbt.centerX = CGRectGetWidth(contentView.frame) / 2;
                        [contentView addSubview:lbt];
                    }else if(i == 1) {
                        UIButton * rbt = [UIButton addPopButtonWhiteTitle:buttonArr[i] frame:CGRectMake(20 + 10 + (CGRectGetWidth(contentView.frame) - 20 * 2 - 20 ) / 2, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 10, 200, 35) titleColor:[UIColor whiteColor] backgroundColor:QiCaiNavBackGroundColor layerBorderColor:QiCaiNavBackGroundColor Target:[CHMBProgressHUD shareinstance] action:@selector(popButtonChlie:)];
                        rbt.tag = i;
                        [rbt setBackgroundImage:[UIImage imageNamed:@"pop_update_on"] forState:UIControlStateNormal];
                        rbt.centerX = CGRectGetWidth(contentView.frame) / 2;
                        [contentView addSubview:rbt];
                        
                    }
                    
                }
                
                UILabel * messageLabel = [UILabel addLabelWithFrame:CGRectMake(0, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 4, CGRectGetWidth(contentView.frame),25) text:@"WIFI环境下更新不到 30 秒哦~" textColor:QiCaiBZTitleColor backgroundColor:nil size:11 textAlignment:NSTextAlignmentCenter lineSpacing:0 layerCornerRadius:0 layerBorderWidth:0 layerBorderColor:nil];
                //            messageLabel.backgroundColor = [UIColor yellowColor];
                [contentView addSubview:messageLabel];
                
            }
            //获取 _contentView上最后一个控件的位置 把_contentView的高度再最后一个的基础上加 20
            contentView.height = CGRectGetMaxY([ contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 17;
            
        }else{//没有按钮
            
        }
        
        
    }else{
        //        contentView.frame = CGRectMake(0, 0, MYScreenW * 0.8, MYScreenH * 0.1);
        
        if (myMode == CHProgressModeChoice) {
            
            UIView * line = [[UIView alloc]init];
            line.frame = CGRectMake(0, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 05, CGRectGetWidth(contentView.frame), 1);
            line.backgroundColor = QiCaiBackGroundColor;
            [contentView addSubview:line];
            
            
            NSInteger col = 3;
            CGFloat startX = 13;//整个九宫格的位置
            CGFloat  margin = 13;
            
            if (buttonArr.count == 2) {
                 col = 2;
                 startX = 21.4;//整个九宫格的位置
                  margin = 8.5;
            }
            
            CGFloat width = (CGRectGetWidth(contentView.frame) - startX * 2 - (col - 1) * margin) / col;
            CGFloat height = 29;
            CGFloat CWstartY = 45;//45;
            CGFloat cenY = CGRectGetMaxY(line.frame)   + (CGRectGetHeight(contentView.frame ) -  CGRectGetMaxY(line.frame) + 18) / 2;
            
            for (NSInteger i = 0; i < buttonArr.count; i++) {
                UIButton * lbt = [UIButton addPopButtonWhiteTitle:buttonArr[i] frame:CGRectMake(20, CGRectGetMaxY([contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 10, (CGRectGetWidth(contentView.frame) - 20 * 2 - 20 ) / 2, 30) titleColor:[UIColor darkGrayColor] backgroundColor:[UIColor whiteColor] layerBorderColor:QiCaiBackGroundColor Target:[CHMBProgressHUD shareinstance] action:@selector(popButtonChlie:)];
                lbt.layer.cornerRadius = 4;
                lbt.width = width;
                lbt.height = height;
                NSInteger row = i / col;//行号
                NSInteger CWcol = i % col;//列号
                lbt.x = startX + (width +  margin) * CWcol;
                lbt.y = CWstartY + (height + 8.5) * row;
                lbt.centerY = cenY;
                
                lbt.tag = i;
                [contentView addSubview:lbt];
                
            }
            //        //获取 _contentView上最后一个控件的位置 把_contentView的高度再最后一个的基础上加 40
            contentView.height = CGRectGetMaxY([ contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 23;
        }else{
            imageView.frame = CGRectMake(0, 30, 51.3, 51.3);
            imageView.centerX = CGRectGetWidth(contentView.frame) / 2;
            titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 12, CGRectGetWidth(contentView.frame),30);
            
            //        //获取 _contentView上最后一个控件的位置 把_contentView的高度再最后一个的基础上加 40
            contentView.height = CGRectGetMaxY([ contentView.subviews objectAtIndex:contentView.subviews.count - 1].frame) + 23;

        }
        
    }
    
    
    //    [ _contentView.subviews objectAtIndex:_contentView.subviews.count];
    
    
    
    //    )CHAlertControllerWithTitle:(NSString *)title  message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle CallBackBlock:(CallBackBlock)block  titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor cancelButtonColor:(UIColor *)cancelButtonColor destructiveButtonColor:(UIColor *)destructiveButtonColor  otherBtnTintColor:(UIColor *)otherBtnTintColor cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherBtnTitles {
    
    
    //    [CHPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    //    [CHPopTool sharedInstance].closeButtonType = ButtonPositionTypeNone;
    //    [[CHPopTool sharedInstance] showWithPresentView:_contentView animated:NO];
    
    [CHMBProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
    [CHMBProgressHUD shareinstance].hud.customView = contentView;
    [CHMBProgressHUD shareinstance].hud.margin = 0;//设置HUD和customerView的边距（默认是20）
    //   [CHMBProgressHUD shareinstance]hud.yOffset = -20.0f; //设置HUD距离中心位置的y偏移（同理也可以设置xOffset）
    
    return contentView;
}
- (void)popButtonChlie:(UIButton *)btn{
//    VDLog(@"popB%ld",(long)btn.tag);
    [CHMBProgressHUD shareinstance].popDelegate ? [[CHMBProgressHUD shareinstance].popDelegate PopButton:btn] : nil;
}
+(void)hide{
    if ([CHMBProgressHUD shareinstance].hud != nil) {
        [[CHMBProgressHUD shareinstance].hud hide:YES];
    }
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:CHProgressModeOnlyText];

    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:2.0];
}

+(void)showMessage:(NSString *)msg {
    
//    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self show:msg inView:view mode:CHProgressModeOnlyText];
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:2.0];
}
+(void)showMessage:(NSString *)msg afterDelayTime:(NSInteger)delay{
    
//    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self show:msg inView:view mode:CHProgressModeOnlyText];
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:delay];
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:CHProgressModeOnlyText];
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:delay];
}

//+(void)showSuccess:(NSString *)msg inview:(UIView *)view{
//    [self show:msg inView:view mode:CHProgressModeSuccess];
//    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:1.0];
//    
//}
#pragma mark - 成功
+(void)showSuccess:(NSString *)msg {
    
//    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModeSuccess title:msg message:nil buttonArr:nil];
//    +(void)showPopView:(NSString *)msg inView:(UIView *)view mode:(CHProgressMode )myMode title:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:2.0];
    
}
#pragma mark - 失败
+(void)showFail:(NSString *)msg {
    
    //    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModeFail title:msg message:nil buttonArr:nil];
    //    +(void)showPopView:(NSString *)msg inView:(UIView *)view mode:(CHProgressMode )myMode title:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:3.0];
    
}
#pragma mark - 提示
+(void)showPrompt:(NSString *)msg {
    
    //    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModePrompt title:msg message:nil buttonArr:nil];
    //    +(void)showPopView:(NSString *)msg inView:(UIView *)view mode:(CHProgressMode )myMode title:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:3.0];
    
}
#pragma mark - 温馨提示带按钮
+ (void)showPromptWithMessage:(NSString *)message buttonArr:(NSArray *)buttonArr{
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:2];
//     UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModePrompt title:@"温馨提示" message:message buttonArr:buttonArr];
    //临时
//    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:3.0];
}
#pragma mark --双按钮
+ (void)showTowBtnWtihTiitle:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr mode:(CHProgressMode )myMode{
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:myMode title:title message:message buttonArr:buttonArr];
    
}
#pragma mark --上下双按钮
+ (void)showUpdateTiitle:(NSString *)title message:(NSString *)message buttonArr:(NSArray *)buttonArr{
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModeUpdate title:title message:message buttonArr:buttonArr];
    
}
#pragma mark --单按钮
+ (void)showOneBtnWtihTiitle:(NSString *)title message:(NSString *)message btnName:(NSString *)btnName mode:(CHProgressMode )myMode{
    
    NSArray * buttonArr = @[btnName];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:myMode title:title message:message buttonArr:buttonArr];
    //临时
//    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:3.0];
    
}

+ (void)showFailOneBtnWtihTiitle:(NSString *)title {
    
    NSArray * buttonArr = @[@"重新下单"];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModeFail title:title message:@"4000-999-001" buttonArr:buttonArr];
    //临时
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:3.0];
    
}
#pragma mark - 选择订单提交
+ (void)showPromptWithTitle:(NSString *)title buttonArr:(NSArray *)buttonArr{
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self showPopView:view mode:CHProgressModeChoice title:title message:nil buttonArr:buttonArr];
    //临时
//    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:5.0];
}
//+(void)showProgress:(NSString *)msg inView:(UIView *)view{
//    [self show:msg inView:view mode:CHProgressModeLoading];
//}
+(void)showProgress:(NSString *)msg {
//    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self show:msg inView:view mode:CHProgressModeLoading];
}


+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = [self setViewToCHN];;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = msg;
    return hud;
    
    
}


+(void)showMsgWithoutView:(NSString *)msg{
//    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//     UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    [self show:msg inView:view mode:CHProgressModeOnlyText];
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:1.0];
    
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];//0意味着无限（默认为0）
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:CHProgressModeCustomAnimation customImgView:showImageView];
    
    //这句话是为了展示几秒，实际要去掉
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:8.0];
    
    
}
+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry{
//    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
//     UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow * view = [self setViewToCHN];
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];//0意味着无限（默认为0）
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:CHProgressModeCustomAnimation customImgView:showImageView];
    
    //这句话是为了展示几秒，实际要去掉
    [[CHMBProgressHUD shareinstance].hud hide:YES afterDelay:8.0];
    
    
}
#pragma mark - 添加手势,触摸屏幕将提示框隐藏
-(void)addGestureInView:(UIView *)view{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheScreen)];
    self.tap.delegate = self;
    [view addGestureRecognizer:self.tap];
    
}
#pragma mark -点击屏幕
-(void)tapTheScreen{
    NSLog(@"点击屏幕");
    [CHMBProgressHUD hide];
    [self.tap removeTarget:nil action:nil];
}
#pragma mark - 解决手势冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[MBProgressHUD class]]) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
+ (UIWindow *)setViewToCHN{
//    UIWindow * view = [[UIApplication sharedApplication].windows objectAtIndex:1];
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    return view;
}
@end
