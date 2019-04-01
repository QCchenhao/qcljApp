//
//  MyShareView.h
//  七彩乐居
//
//  Created by 李大娟 on 16/3/23.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

typedef enum : NSUInteger {
    ShareViewQQ,
    ShareViewQZone,
    ShareViewWeiXin,
    ShareViewWeiXinFriend
} ShareViewType;

#import <UIKit/UIKit.h>
@class ShareView;
@protocol ShareViewDelegate <NSObject>

-(void)shareViewDidClickShareView:(ShareView *)shareView selBtn:(ShareViewType)shareType;

@end

@interface ShareView : UIView

@property (weak, nonatomic) id <ShareViewDelegate> sharedelegate;

/**
 显示shareView
 */
- (void)showShareView;

/**
 关闭shareView
 */
- (void)hiddenShareView;

@end
