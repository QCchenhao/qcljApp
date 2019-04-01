//
//  AboutMeViewcontroller.m
//  QCLJCustomer
//
//  Created by 李大娟 on 16/11/7.
//  Copyright © 2016年 七彩乐居. All rights reserved.
//

#import "AboutMeViewcontroller.h"
#import "Comment.h"
#import "NSString+File.h"

@interface AboutMeViewcontroller()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UITableView *tableView;
@property (strong)NSMutableArray *testData;
@property (strong)NSMutableArray *DetailTestData;

@end
@implementation AboutMeViewcontroller
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QiCaiBackGroundColor;
    
    [self setupUI];
    
}

-(void)setupUI
{
    // 设置导航栏
    self.navigationItem.title = @"关于我们";
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MYScreenW,MYScreenH) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc]init];
    
    tableView.delegate   = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = QiCaiBackGroundColor;
    
    _testData = [NSMutableArray array];
    NSArray *groupA = @[@"微信公众号",@"新浪微博",@"公司网址"];
    [_testData addObject:groupA];
    
    _DetailTestData = [NSMutableArray array];
    NSArray *detailArr = @[@"七彩乐居家政总部",@"七彩乐居总部",@"www.bjleju.com"];
    [_DetailTestData addObject:detailArr];
}

#pragma mark --tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView//设置两段
{
    return _testData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//在当前段里有多少行
{
    NSArray * temp = _testData[section];
    return temp.count;//数组的内容
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell 单元格
{
    static NSString *AbloutMeCellID = @"AbloutMeCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AbloutMeCellID];
    
    //文字
    UILabel * labelCell = [[UILabel alloc]init];
    labelCell.text = _testData[indexPath.section][indexPath.row];
    labelCell.font = QiCai12PFFont;
    labelCell.textColor = QiCaiDeepColor;
    labelCell.frame = CGRectMake(QiCaiMargin * 2, 15, 100, 13);
    labelCell.centerY = cell.centerY;
    [cell addSubview:labelCell];
    
    UILabel *detaiLabelCell = [[UILabel alloc]init];
    detaiLabelCell.text = _DetailTestData[indexPath.section][indexPath.row];
    detaiLabelCell.font = QiCai10PFFont;
    detaiLabelCell.textColor = QiCaiDeepColor;
    detaiLabelCell.textAlignment = NSTextAlignmentRight;
    detaiLabelCell.frame = CGRectMake(CGRectGetMaxX(labelCell.frame), 15, MYScreenW - CGRectGetMaxX(labelCell.frame) - 15, 13);
    detaiLabelCell.centerY = cell.centerY;
    [cell addSubview:detaiLabelCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return QiCaiMargin;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
/*
 分割线移动
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0,10)];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

@end
