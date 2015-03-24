//
//  MYItemListTableViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYItemListTableViewController.h"
#import "AFNetworking.h"
#import "MYItemDetailTableViewController.h"
#import "MYItemCell.h"
@interface MYItemListTableViewController ()

@property(strong,nonatomic)NSDictionary *categoryList;

@property(copy,nonatomic) NSArray *itemCatalog;

@end

@implementation MYItemListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemCatalog = @[@"111",@"222",@"3333",@"444"];
    [self getItemCatalog];
    NSLog(@"%@",_categoryList);
    
    _InsertArry = [[NSMutableArray alloc]init];
    _DeleteArry = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)getItemCatalog{
 
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    //2.设置登录参数
    NSDictionary *dict = @{@"content":@"Categort"};
    
    //3.请求
    [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        _categoryList = responseObject;
        [self GetCategoryDetail];
        [self performSelectorOnMainThread:@selector(updateUI)withObject:nil waitUntilDone:YES];
        NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
-(void)updateUI{
    [self.tableView reloadData];
}
-(void)GetCategoryDetail{
    _TableArry = [[NSMutableArray alloc]init];
    NSArray * tmp = [_categoryList objectForKey:@"Category"];
    
    int dicCount = [tmp count];
    
    for(int i=0;i<dicCount;i++)
    {
        NSDictionary *t1 = tmp[i];
        _itemCatalog = [t1 objectForKey:[[NSString alloc]initWithFormat:@"%d",i+1]];
        
        NSMutableArray *tableArray = [[NSMutableArray alloc]init];
        
        int itemCount = [_itemCatalog count];
        for(int j=1;j<itemCount;j++){
            
            MYItemCell *cell = [[MYItemCell alloc]init];
            cell.Name.text = _itemCatalog[j];
            NSLog(@"%@",cell.Name.text);
            j++;
            cell.ID =_itemCatalog[j];
            cell.ChildArray = nil;
            [tableArray addObject:cell];
            
        }
        
        MYItemCell *cell1 = [[MYItemCell alloc]init];
        cell1.Name.text = _itemCatalog[0];
        cell1.ID = @"";
        cell1.ChildArray = tableArray;
        [_TableArry addObject:cell1];
        
    }
    NSLog(@"%@",_TableArry);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _TableArry.count;
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CatalogNameCell" forIndexPath:indexPath];

   
    // Configure the cell...
    if(indexPath.row<_TableArry.count)
    {
        MYItemCell *tmpcell = [[MYItemCell alloc]init];
        tmpcell = [_TableArry objectAtIndex:indexPath.row ];
        
        cell.textLabel.text = tmpcell.Name.text;
        if(tmpcell.ChildArray.count == 0)
        NSLog(@"%@",tmpcell.Name.text);
        if(tmpcell.ChildArray.count == 0){
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"    %@",tmpcell.Name.text];
            cell.accessoryType = 1;
        }

    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MYItemCell *cell = [_TableArry objectAtIndex:indexPath.row];
    if(cell.ChildArray.count == 0){
        //push进入下一个view
        MYItemDetailTableViewController *itemDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailIdentity"];
        
        //[[MYItemDetailTableViewController alloc] init];
        itemDetailVC.typeID = cell.ID;
        [self.navigationController pushViewController:itemDetailVC animated:YES];
    }else {
        if(!cell.Open)//如果子菜单是关闭的
        {
            NSArray * array =  [self insertOperation:cell];
            if(array.count>0)
                //从视图中添加
                [self.tableView insertRowsAtIndexPaths: array withRowAnimation:UITableViewRowAnimationBottom ];
            
        }
        else//如果子菜单是打开的
        {
            NSArray * array = [self deleteOperation:cell];
            if(array.count>0)
                //从视图中删除
                [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
        }
        
        //  [self.tableView reloadData];
    }
    
}

-(NSArray *) insertOperation:(MYItemCell *)item
{
    [_InsertArry removeAllObjects];//将插入菜单清空
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_TableArry indexOfObject:item] inSection:0];//获取选取的cell的位置
    
    MYItemCell  *child = [[MYItemCell alloc]init];
    //遍历当前选取cell 的子菜单
    for(int i=0;i<item.ChildArray.count;i++)
    {
        child = [item.ChildArray objectAtIndex:i];
        [_TableArry insertObject:child atIndex:path.row + i +1 ];//调用数组函数将其插入其中
        [_InsertArry addObject:child];//放入插入数组中
    }
    item.Open=YES;//设置菜单已经打开
    NSMutableArray *PathArray= [NSMutableArray array];//初始化用于存放位置的数组
    for(MYItemCell *cell in _InsertArry)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_TableArry indexOfObject:cell] inSection:0];
        [PathArray addObject:path];
    }
    return PathArray;
}

-(NSArray *) deleteOperation:(MYItemCell *)item
{
    [_DeleteArry removeAllObjects];//清空删除数组
    MYItemCell *child =[[MYItemCell alloc]init];//子菜单
    for(int i =0;i<item.ChildArray.count;i++)
    {
        child = [item.ChildArray objectAtIndex:i];
        [_DeleteArry addObject:child];//添加到删除数组
    }
    item.Open = NO;//设置子视图关闭
    NSMutableArray *mutableArry = [NSMutableArray array];
    NSMutableIndexSet *set= [NSMutableIndexSet indexSet];//设置用来存放删除的cell的索引
    for(MYItemCell *cell in _DeleteArry)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_TableArry indexOfObject:cell] inSection:0];

        [mutableArry addObject:path];
        [set addIndex:path.row];
    }
    [_TableArry removeObjectsAtIndexes:set];//调用函数来从数组中删除
    return mutableArry;
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


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MYItemCell *cell = [[MYItemCell alloc]init];
    cell = [_TableArry objectAtIndex:indexPath.row];
    if(cell.ChildArray == 0)
    {
        MYItemDetailTableViewController *itemDetailVC = segue.destinationViewController;
        itemDetailVC.typeID = cell.ID;
    }
}*/






@end
