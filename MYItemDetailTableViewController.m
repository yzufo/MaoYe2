//
//  MYItemDetailTableViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYItemDetailTableViewController.h"
#import "AFNetworking.h"
#import "MYGoodsDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "MYGoodsViewController.h"

@interface MYItemDetailTableViewController ()

@property(copy,nonatomic) NSArray *goodsDetail;
@property(strong,nonatomic) NSDictionary *goodsList;
@property(strong,nonatomic) NSMutableArray *myGoods;

@end

@implementation MYItemDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myGoods = [[NSMutableArray alloc]init];
    _goodsList = [[NSDictionary alloc]init];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToBrandList)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 13;
   
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    
    
    self.goodsDetail = @[@"111",@"222",@"3333",@"444"];
    [self getItemList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getItemList{
    
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2.设置登录参数
    //NSDictionary *dict = @{@"content":@"TypeID",@"TypeID":_typeID};
    
    //3.请求
    [manager POST:urlString parameters:_postString success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        _goodsList = responseObject;
        NSLog(@"POST --> %@",responseObject);
        [self GetGoodsDetail];
        [self performSelectorOnMainThread:@selector(updateUI)withObject:nil waitUntilDone:YES];
        [NSThread currentThread];
      //  NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MYGoodsViewController *goodsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsViewIndetity"];
    MYGoodsDetailCell *tmpGoods = [_myGoods objectAtIndex:indexPath.row];
    goodsVC.goodDetail = tmpGoods;
    //[[MYItemDetailTableViewController alloc] init];
    //NSDictionary *dict = @{@"content":@"TypeID",@"TypeID":cell.ID};
    //itemDetailVC.postString = dict;
    [self.navigationController pushViewController:goodsVC animated:YES];

}

-(void)GetGoodsDetail{
    NSArray * tmp = [_goodsList objectForKey:@"Goods"];
    NSUInteger dicCount = [tmp count];
    
    for(int i=0;i<dicCount;i++)
    {
        NSDictionary *t1 = tmp[i];
        _goodsDetail = [t1 objectForKey:[[NSString alloc]initWithFormat:@"%d",i+1]];
        MYGoodsDetailCell *tmpGoods = [[MYGoodsDetailCell alloc]init];
        tmpGoods.name = _goodsDetail[0];
        tmpGoods.goodsId = _goodsDetail[1];
        tmpGoods.brandID = _goodsDetail[2];
        tmpGoods.imagePath = _goodsDetail[3];
        tmpGoods.price = _goodsDetail[4];
        tmpGoods.introduction = _goodsDetail[5];
        tmpGoods.pic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpGoods.imagePath]]];
        [_myGoods addObject:tmpGoods];
      
    }

}
-(void)updateUI{
    [self.tableView reloadData];
}

-(void)backToBrandList
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _myGoods.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    MYGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailCell" forIndexPath:indexPath];
    MYGoodsDetailCell *tmpGoods = [_myGoods objectAtIndex:indexPath.row];
    cell.goodsName.text = tmpGoods.name;

    cell.goodsImage.image = tmpGoods.pic;
    return cell;
    

}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
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
