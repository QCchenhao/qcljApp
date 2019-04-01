//
//  AmapTabeleController.m
//  
//
//  Created by QCJJ－iOS on 16/10/12.
//
//

#import "AmapTabeleController.h"

#import "Comment.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import "POIAnnotation.h"

@interface AmapTabeleController ()
/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *amaps;

@property  NSInteger indexCell;//选中行数

@property (copy, nonatomic)NSString * type;
@end

static NSString *const QCTrainId = @"trainCell";
@implementation AmapTabeleController

- (NSMutableArray *)amaps{
    if (!_amaps) {
        _amaps = [NSMutableArray array];
    }
    return _amaps;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _indexCell = 1000000;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.frame.size.height;
    CGFloat top = -5 ;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;

    self.tableView.tableFooterView = [[UIView alloc] init];//不想让下面的那些空显示
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadNewTopic:(NSArray *)amaps type:(NSString *)type{
    self.type = type;
    [self.amaps removeAllObjects];
    [self.amaps addObjectsFromArray:amaps];
    //刷新
    [self.tableView reloadData];
    
    //取消弹窗
    [CHMBProgressHUD hide];
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.amaps.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中状
//    obj = [[POIAnnotation alloc] initWithPOI:obj];
    if ([self.type isEqualToString:@"001"]) {
        AMapPOI *obj   = self.amaps[indexPath.row];
        NSLog(@"%@",obj.address);
        
        cell.detailTextLabel.text = obj.address;
        cell.textLabel.text = obj.name;
    }else{
        AMapTip *obj   = self.amaps[indexPath.row];
        NSLog(@"%@",obj.address);
        
        cell.detailTextLabel.text = obj.address;
        cell.textLabel.text = obj.name;
    }

    
    cell.imageView.image = [UIImage imageNamed:@"icon_dizhi"];
    cell.detailTextLabel.textColor = QiCaiShallowColor;
    cell.textLabel.textColor = QiCaiDeepColor;
    
    cell.tintColor = QiCaiNavBackGroundColor;
    // 重用机制，如果选中的行正好要重用
    if (_indexCell == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    QCOrderSuccessDetailViewController *orderSuccessDetailVC = [[QCOrderSuccessDetailViewController alloc]init];
//    orderSuccessDetailVC.topic = self.topics[indexPath.row];;
//    [self.navigationController pushViewController:orderSuccessDetailVC animated:YES];
    
    // 取消前一个选中的，就是单选啦
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_indexCell inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndex];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 选中操作
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // 保存选中的
    _indexCell = indexPath.row;
    [tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:.5];
    
    if ([self.type isEqualToString:@"001"]) {
        AMapPOI *obj   = self.amaps[indexPath.row];
        NSLog(@"%@",obj.address);
        
        NSString * addressStr ;
        if ([obj.province isEqualToString:obj.city]) {
            addressStr = [NSString stringWithFormat:@"%@%@%@",obj.city,obj.district,obj.address];
        }else{
            addressStr = [NSString stringWithFormat:@"%@%@%@%@",obj.province,obj.city,obj.district,obj.address];
        }
        
        _AmapIndexBlock ? _AmapIndexBlock(addressStr) : nil;
    }else{
        AMapTip *obj   = self.amaps[indexPath.row];
        NSLog(@"%@",obj.address);
        
        NSString * addressStr = [NSString stringWithFormat:@"%@%@",obj.district,obj.address]; ;
        
        
        _AmapIndexBlock ? _AmapIndexBlock(addressStr) : nil;
    }

    
//    AMapPOI *obj   = self.amaps[indexPath.row];
//    NSLog(@"%@",obj.address);
    
//    NSString * addressStr ;
//    if ([obj.province isEqualToString:obj.city]) {
//        addressStr = [NSString stringWithFormat:@"%@%@%@",obj.city,obj.district,obj.address];
//    }else{
//        addressStr = [NSString stringWithFormat:@"%@%@%@%@",obj.province,obj.city,obj.district,obj.address];
//    }
//
//    _AmapIndexBlock ? _AmapIndexBlock(addressStr) : nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
