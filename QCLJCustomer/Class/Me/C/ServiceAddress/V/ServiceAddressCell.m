//
//  ServiceAddressCell.m
//  QCLJCustomer
//
//  Created by QCJJ－iOS on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "ServiceAddressCell.h"

#import "Comment.h"

@interface ServiceAddressCell ()
@property (nonatomic,strong) UILabel * addressLabel;


@end
@implementation ServiceAddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        UIImageView * imageVeiw = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
//        imageVeiw.image = [UIImage imageNamed:@"icon_shaofan"];
//        imageVeiw.centerY = self.contentView.height / 2;
//        [self.contentView addSubview:imageVeiw];

        _addressBtn = [UIButton addButtonWithFrame:CGRectMake(15, 0, 15, 15) image:@"me_address_off" highImage:@"me_address_on" backgroundColor:nil Target:self action:nil];
        _addressBtn.centerY = self.contentView.height / 2;
        [self.contentView addSubview:_addressBtn];
        
        _addressLabel = [UILabel addLabelWithFrame:CGRectMake(CGRectGetMaxX(_addressBtn.frame) + 10, 0, CGRectGetWidth(self.contentView.frame) * 0.45, CGRectGetHeight(self.contentView.frame)) text:@"fsdfsfsfsf" size:11 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_addressLabel];
        
        UIButton * editButton = [UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(_addressLabel.frame) + 20, 0, CGRectGetWidth(self.contentView.frame) * 0.14, CGRectGetHeight(self.contentView.frame) * 0.45) ButtonTitle:@"编辑" titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:12] borderColor:QiCaiBackGroundColor backGroundColor:nil Target:self action:@selector(editButtonChlie:) btnCornerRadius:3];
        editButton.centerY = _addressBtn.centerY;
        [self.contentView addSubview:editButton];
        
       self.deleteButton = [UIButton addButtonWithFrame:CGRectMake(CGRectGetMaxX(editButton.frame)+ 10 , 0, CGRectGetWidth(self.contentView.frame) * 0.14, CGRectGetHeight(self.contentView.frame) * 0.45) ButtonTitle:@"删除" titleColor:[UIColor grayColor] titleFont:[UIFont systemFontOfSize:12] borderColor:QiCaiBackGroundColor backGroundColor:nil Target:self action:@selector(deleteButtonChlie:) btnCornerRadius:3];
        self.deleteButton.centerY = _addressBtn.centerY;
        [self.contentView addSubview:self.deleteButton];
        
        
    }
    
    return self;
}
- (void)setServiceAddressMode:(ServiceAddressMode *)serviceAddressMode{
    _serviceAddressMode = serviceAddressMode;
    
    _addressLabel.text = serviceAddressMode.address;
    
    if ([serviceAddressMode.state isEqualToString:@"1"]) {
        _addressBtn.selected = YES;
        [self.deleteButton setTitleColor:UIColorFromRGB(0xe6e6e6) forState:UIControlStateNormal];
        self.deleteButton.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        [self.deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _addressBtn.selected = NO;
    }
}
- (void)editButtonChlie:(UIButton *)btn{
    if ([self.serviceAddressDelegate respondsToSelector:@selector(editAddChlie:)]) {
        btn.tag = self.tag;
        [self.serviceAddressDelegate editAddChlie:btn];
    }
}
- (void)deleteButtonChlie:(UIButton *)btn{
    if ([self.serviceAddressDelegate respondsToSelector:@selector(deleteAddChlie:)]) {
        btn.tag = self.tag;
        [self.serviceAddressDelegate deleteAddChlie:btn];
    }
}
@end
