//
//  AmapTabeleController.h
//  
//
//  Created by QCJJ－iOS on 16/10/12.
//
//

#import <UIKit/UIKit.h>

@interface AmapTabeleController : UITableViewController

/** 地址的回调*/
@property (nonatomic, copy) void(^AmapIndexBlock)(NSString *address);

/** 帖子数据 */
-(void)loadNewTopic:(NSArray *)amaps type:(NSString *)type;
@end
