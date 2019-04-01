//
//  ShareView.m
//  DDoctorUser
//
//  Created by 蔡士林 on 15/10/11.
//  Copyright © 2015年 alex. All rights reserved.
//
#define kShareMargin 30
#define kShareCellMargin 10
#define kShareCol 4
#define kShareCellW 60
#import "Comment.h"

#import "ShareView.h"


@interface ShareView ()
@property (strong, nonatomic) NSMutableArray *btnArr;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *coverBtn;
@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        UIButton *coverBtn = [[UIButton alloc]init];
        [self addSubview:coverBtn];
        coverBtn.backgroundColor =  [UIColor blackColor];
        coverBtn.alpha = 0.5;
        self.coverBtn = coverBtn;
        [coverBtn addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
        [self setUpShareBtnView];
    }
    return self;
}

- (void)setUpShareBtnView
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self addSubview:bgView];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [self.bgView addSubview:cancelBtn];
    cancelBtn.layer.borderColor = [UIColor grayColor].CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 4;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = QiCai14PFFont;
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenShareView) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn = cancelBtn;
    
    [self addBtn:@"Member_share_qq" andShareType:ShareViewQQ];
    [self addBtn:@"Member_share_qqZone" andShareType:ShareViewQZone];
    [self addBtn:@"Member_share_WeiXin" andShareType:ShareViewWeiXin];
    [self addBtn:@"Member_share_wxFriend" andShareType:ShareViewWeiXinFriend];
    
}

- (void)addBtn:(NSString *)imageNam andShareType:(ShareViewType)type
{
    UIButton *btn =[[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:imageNam] forState:UIControlStateNormal];
    btn.tag = type;
    [btn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnArr addObject:btn];
    [self.bgView addSubview:btn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverBtn.frame = self.bounds;

    NSInteger count = self.btnArr.count;
    NSInteger maxRow   = count % kShareCol ? (count / kShareCol) + 1 : (count / kShareCol);
    
    CGFloat bgViewW  = (kShareCol * kShareCellW) + (kShareCol - 1) * kShareCellMargin + kShareMargin * 2;
    CGFloat bgViewH  = kShareMargin * 2 + (kShareCellMargin + kShareCellW) * maxRow + 35;
    CGFloat bgViewY  = MYScreenH - bgViewH - 40;
    CGFloat bgViewX  = (MYScreenW - bgViewW) / 2;
     
    self.bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    
    for (int i = 0; i < count; i ++) {
        UIButton *btn = self.btnArr[i];
        
        int row = i / kShareCol;
        int col = i % kShareCol;
        CGFloat btnX = kShareMargin + col * (kShareCellW + kShareCellMargin);
        CGFloat btnY = kShareMargin + row * (kShareCellMargin + kShareCellW);
        btn.frame = CGRectMake(btnX, btnY, kShareCellW, kShareCellW);
    }
    
    self.cancelBtn.frame = CGRectMake((bgViewW - 200) / 2, bgViewH - kShareCellMargin - 35, 200, 35);
    
}

- (void)showShareView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)hiddenShareView
{
    self.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickShareBtn:(UIButton *)shareBtn
{
    NSLog(@"%ld",shareBtn.tag);
    if ([self.sharedelegate respondsToSelector:@selector(shareViewDidClickShareView:selBtn:)]) {
        [self.sharedelegate shareViewDidClickShareView:self selBtn:shareBtn.tag];
    }
    [self hiddenShareView];
}

@end