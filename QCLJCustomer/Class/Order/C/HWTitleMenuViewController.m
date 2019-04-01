//
//  HWTitleMenuViewController.m
//  黑马微博2期
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWTitleMenuViewController.h"

#import "Comment.h"

@interface HWTitleMenuViewController ()

@property (nonatomic,strong)NSMutableArray * titleMenus;
@end

@implementation HWTitleMenuViewController
- (NSMutableArray *)titleMenus{
    if (!_titleMenus) {
        _titleMenus = [NSMutableArray array];
    }
    return _titleMenus;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    

    
}
- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    [self.titleMenus addObjectsFromArray:_titleArr];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleMenus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.textColor = QiCaiDeepColor;
    cell.textLabel.font = QiCaiDetailTitle12Font;
    cell.textLabel.text = self.titleMenus[indexPath.row];
    
    [cell setTintColor:QiCaiNavBackGroundColor];
    // 重用机制，如果选中的行正好要重用
    if (_indexTitleMenu == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    QCOrderSuccessDetailViewController *orderSuccessDetailVC = [[QCOrderSuccessDetailViewController alloc]init];
    //    orderSuccessDetailVC.topic = self.topics[indexPath.row];
    //
    //
    //    [self.navigationController pushViewController:orderSuccessDetailVC animated:YES];
    
    // 取消前一个选中的，就是单选啦
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_indexTitleMenu inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 选中操作
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // 保存选中的
    _indexTitleMenu = indexPath.row;
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
    
    if ([self.titleMenuDelegate respondsToSelector:@selector(ClickBtnTitleMenuBtn:)]) {
        [self.titleMenuDelegate ClickBtnTitleMenuBtn:_indexTitleMenu];
    }
}
@end
