//
//  GiftCardViewController.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/4.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "UITextField+extent.h"


@implementation UITextField (extent)
/**
 快速创建
 */
+(UITextField *)addTextFieldWithFrame:(CGRect)rect textFieldDelegate:(id)target contentView:(UIView *)contentView textFieldFont:(UIFont *)font backGroundColor:(UIColor *)color attributedPlaceholder:(NSString *)palceTitle palceHolderTitleColor:(UIColor *)palceHolderTitleColor textFieldBorderColor:(UIColor *)textFieldBorderColor borderWidth:(CGFloat)borderWidth
{
    UITextField *preDepositTextField = [[UITextField alloc]init];
    preDepositTextField.frame = rect;
    preDepositTextField.delegate = target;
    [contentView addSubview:preDepositTextField];
    preDepositTextField.font = font;
    preDepositTextField.backgroundColor = color;
    preDepositTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",palceTitle] attributes:@{NSForegroundColorAttributeName: palceHolderTitleColor}];
    preDepositTextField.layer.borderColor = textFieldBorderColor.CGColor;
    preDepositTextField.layer.borderWidth = borderWidth;
//    preDepositTextField.clearsOnBeginEditing = YES;
    return preDepositTextField;
}
@end
