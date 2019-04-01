//
//  ServiceAddressCell.h
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceAddressMode.h"

@protocol ServiceAddressDelegate <NSObject>

- (void)editAddChlie:(UIButton *)btn;
- (void)deleteAddChlie:(UIButton *)btn;
@end

@interface ServiceAddressCell : UITableViewCell

@property (nonatomic,strong)ServiceAddressMode * serviceAddressMode;

@property (weak,nonatomic) id <ServiceAddressDelegate>serviceAddressDelegate;

@property (nonatomic,strong) UIButton * addressBtn;

@property (nonatomic,strong)UIButton * deleteButton;

@end
