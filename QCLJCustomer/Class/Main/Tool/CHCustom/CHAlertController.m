//
//  CHAlertController.m
//  自定义弹窗字体颜色
//
//  Created by QCJJ－iOS on 16/10/20.
//  Copyright © 2016年 QCJJ－iOS. All rights reserved.
//

#import "CHAlertController.h"

#import <objc/runtime.h>

#define  CHLAlertShowTime 2.0

@interface CHAlertController ()

@end

@implementation CHAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ==== 封装方法最全 ======
+(instancetype)CHAlertControllerWithTitle:(NSString *)title  message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle CallBackBlock:(CallBackBlock)block  titleColor:(UIColor *)titleColor messageColor:(UIColor *)messageColor cancelButtonColor:(UIColor *)cancelButtonColor destructiveButtonColor:(UIColor *)destructiveButtonColor  otherBtnTintColor:(UIColor *)otherBtnTintColor cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherBtnTitles {
    
    CHAlertController *  chAlertController =  [CHAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle ];

//    chAlertController.view.backgroundColor = [UIColor whiteColor];
//    chAlertController.view.layer.cornerRadius = 10;
//    chAlertController.view.tintColor = [UIColor yellowColor];
    
//    chAlertController.view.
    //index下标用于block返回
    NSInteger index = 0;
    
    //“警示”样式的按钮是用在可能会改变或删除数据的操作上。因此用了红色的醒目标识来警示用户。
    if (destructiveBtnTitle) {
        UIColor * btnColor  = nil;
        if (destructiveButtonColor) {
            btnColor = destructiveButtonColor;
        }
        [chAlertController addButtonWithTitle:destructiveBtnTitle textColor:btnColor style:UIAlertActionStyleDestructive CallBackBlock:(CallBackBlock)block btnIndex:index];
        index++;
    }
    
    //UIAlertActionStyleCancel Cancel 类型
    if (cancelBtnTitle) {
        
        UIColor * btnColor  = nil;
        if (cancelButtonColor) {
            btnColor = cancelButtonColor;
        }
        
        [chAlertController addButtonWithTitle:cancelBtnTitle textColor:btnColor style:UIAlertActionStyleCancel CallBackBlock:(CallBackBlock)block btnIndex:index];
        index++;
    }
    
    
    
    
    //otherBtnTitles参数便利
    if (otherBtnTitles) {
        
        for (NSString * str in otherBtnTitles) {
            UIColor * btnColor  = nil;
            if (otherBtnTintColor) {
                btnColor = otherBtnTintColor;
            }
            [chAlertController addButtonWithTitle:str textColor:btnColor style:UIAlertActionStyleDefault CallBackBlock:(CallBackBlock)block btnIndex:index];
            index ++;

        }
        
//        va_list args;
//        va_start(args, otherBtnTitles); // scan for arguments after firstObject.
//        
//        for (NSString * str = otherBtnTitles; str != nil; str = va_arg(args,NSString * )) {
//            
//            UIColor * btnColor  = nil;
//            if (otherBtnTintColor) {
//                btnColor = otherBtnTintColor;
//            }
//            [chAlertController addButtonWithTitle:str textColor:btnColor style:UIAlertActionStyleDefault CallBackBlock:(CallBackBlock)block btnIndex:index];
//            index ++;
//        }
//        va_end(args);
        
    }
    
    //这里统一设置各个按钮的颜色
    if (otherBtnTintColor) {
        chAlertController.tintColor = otherBtnTintColor;
    }
    //设置标题title的颜色
    if (titleColor) {
        chAlertController.titleColor = titleColor;
    }
    //设置信息的颜色
    if (messageColor) {
        chAlertController.messageColor = messageColor;
    }

    
    [[chAlertController getCurrentVC] presentViewController:chAlertController animated:YES completion:nil];
    
    //如果没有按钮，自动延迟消失
    if (!cancelBtnTitle.length && !destructiveBtnTitle.length && !otherBtnTitles.count) {
        //此时self指本类
        [self performSelector:@selector(dismissAlertController:) withObject:chAlertController afterDelay:CHLAlertShowTime];
    }
    
    return chAlertController;
}
#pragma mark ==== 封装方法--系统默认颜色 ======
+(instancetype)CHAlertControllerWithTitle:(NSString *)title  message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle CallBackBlock:(CallBackBlock)block cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSArray *)otherBtnTitles {

    return [self CHAlertControllerWithTitle:title message:message preferredStyle:preferredStyle CallBackBlock:block titleColor:nil messageColor:nil cancelButtonColor:nil destructiveButtonColor:nil otherBtnTintColor:nil cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:otherBtnTitles];
    
}
#pragma mark ==== 封装方法--系统默认颜色--中间显示--双按钮 ======
+(instancetype)CHAlertControllerWithTitle:(NSString *)title  message:(NSString *)message CallBackBlock:(CallBackBlock)block cancelButtonTitle:(NSString *)cancelBtnTitle destructiveButtonTitle:(NSString *)destructiveBtnTitle{
    return [self CHAlertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert CallBackBlock:block cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:destructiveBtnTitle otherButtonTitles:nil];
}
#pragma mark - 点击事件
+ (void)dismissAlertController:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 私有方法->
#pragma mark - 获取当前屏幕显示的ViewController
//获取当前屏幕显示的ViewController
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
        
    }else{
        result = window.rootViewController;
    }
    
    return result;
}
#pragma mark - 按钮封装
- (void)addButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor style:(UIAlertActionStyle)style CallBackBlock:(CallBackBlock)block btnIndex:(NSInteger)btnIndex{
    CHAlertAction * chAlertAction = [CHAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(btnIndex);
        }
    }];
    

//    //chAlertAction添加图片
//    UIImage *accessoryImage = [UIImage imageNamed:@"Main_navigationBar_home_on"];
//    accessoryImage = [accessoryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [chAlertAction setValue:accessoryImage forKey:@"image"];
    
    
    //单独修改一个按钮的颜色
    if (textColor) {
        chAlertAction.textColor = textColor;
    }
    [self addAction:chAlertAction];
    
    
   
//    unsigned int numIvars; //成员变量个数
////    Ivar *vars = class_copyIvarList(NSClassFromString(@"UIAlertAction"), &numIvars);
//    Ivar *vars = class_copyIvarList([UIAlertAction class], &numIvars);
//    
//    NSString *keyname =nil;
//    NSString *keytype=nil;
//    for(int i = 0; i < numIvars; i++) {
//        Ivar thisIvar = vars[i];
//        keyname = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
//        NSLog(@"variable name :%@", keyname);
//        keytype = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
//        NSLog(@"variable type :%@", keytype);
//        NSLog(@"\n");
//        
//        //Add image 这里可以给button添加图片
//        UIImage *accessoryImage = [UIImage imageNamed:@"home_enterpriseService"];
//        accessoryImage = [accessoryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [chAlertAction setValue:[UIColor orangeColor] forKey:@"_imageTintColor"];
//    }
//    free(vars);
//    
//    
//    Method *meth = class_copyMethodList(NSClassFromString(@"UIView"), &numIvars);
//    //Method *meth = class_copyMethodList([UIView class], &numIvars);
//    
//    for(int i = 0; i < numIvars; i++) {
//        Method thisIvar = meth[i];
//        
//        SEL sel = method_getName(thisIvar);
//        const char *name = sel_getName(sel);
//        
//        NSLog(@"zp method :%s", name);
//        NSLog(@"\n");
//    }
//    free(meth);


}
#pragma mark - 按钮统一颜色
- (void)setTintColor:(UIColor *)tintColor{
    
    _tintColor = tintColor;
    
    //按钮统一颜色
    for (CHAlertAction *action in self.actions) {
        if (!action.textColor) {
            
            //当 style 类型为 UIAlertActionStyleDestructive 和 UIAlertActionStyleCancel 时，不设置颜色
            if (action.style == UIAlertActionStyleDestructive || action.style == UIAlertActionStyleCancel) {

            }else{
                action.textColor = self.tintColor;
            }
        }
        
    }
}
#pragma mark - 标题颜色
- (void)setTitleColor:(UIColor *)titleColor{
    
    _titleColor = titleColor;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        //标题颜色
        if ([ivarName isEqualToString:@"_attributedTitle"] && self.title && self.titleColor) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.titleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
            [self setValue:attr forKey:@"attributedTitle"];
        }
        
    }
    
}
#pragma mark - 描述内容颜色
- (void)setMessageColor:(UIColor *)messageColor{
    
    _messageColor = messageColor;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertController class], &count);
    for(int i = 0;i < count;i ++){
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        //描述颜色
        if ([ivarName isEqualToString:@"_attributedMessage"] && self.message && self.messageColor) {
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.message attributes:@{NSForegroundColorAttributeName:self.messageColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
            [self setValue:attr forKey:@"attributedMessage"];
        }
    }
    
    
    
}
@end

#pragma mark - 自定义 AlertAction
@implementation CHAlertAction

#pragma mark - 按钮标题的字体颜色
-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UIAlertAction class], &count);
    for(int i =0;i < count;i ++){
        
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            
            [self setValue:textColor forKey:@"titleTextColor"];
        }
    }
}

@end

