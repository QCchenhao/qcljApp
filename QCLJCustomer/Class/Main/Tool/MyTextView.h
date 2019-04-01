//
//  MyTextView.h
//  七彩乐居
//
//  Created by 李大娟 on 16/3/22.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView

@property(nonatomic,copy) NSString *placeHoledr;
@property (strong, nonatomic)  UIColor *placeHoledrColor;
@property (strong, nonatomic)  UILabel *placeLabel;

@end
