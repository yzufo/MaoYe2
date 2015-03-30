//
//  MYBrandListTableViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYBrandListTableViewController.h"
#import "MYBrandListCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MYItemDetailTableViewController.h"
#import "MYBrandDetailViewController.h"
@interface MYBrandListTableViewController ()

@property(strong,nonatomic) NSDictionary *brandList;
@property(strong,nonatomic) NSMutableArray *myBrand;

@property(copy,nonatomic)NSArray *brandNames;

@end

@implementation MYBrandListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.brandNames = @[@"111",@"222",@"3333",@"444"];
    _brandList = [[NSDictionary alloc]init];
    _myBrand = [[NSMutableArray alloc]init];
    [self getBrandList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getBrandList{
    
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2.设置登录参数
    NSDictionary *dict = @{@"content":@"BrandID"};
    
    //3.请求
    [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        _brandList = responseObject;
        [self GetBrandDetail];
        [self performSelectorOnMainThread:@selector(updateUI)withObject:nil waitUntilDone:YES];
        [NSThread currentThread];
        //  NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

-(void)GetBrandDetail{
    NSArray * tmp = [_brandList objectForKey:@"Brand"];
    
    NSUInteger dicCount = [tmp count];
    
    for(int i=0;i<dicCount;i++)
    {
        NSDictionary *t1 = tmp[i];
        NSArray *brandDetail = [[NSArray alloc]init];
        brandDetail = [t1 objectForKey:[[NSString alloc]initWithFormat:@"%d",i+1]];
        MYBrandListCell *tmpBrand = [[MYBrandListCell alloc]init];
        tmpBrand.brandID = brandDetail[0];
        tmpBrand.name = brandDetail[1];
        tmpBrand.logoPath = brandDetail[2];
        tmpBrand.brandIntroduction = brandDetail[3];
        tmpBrand.logo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tmpBrand.logoPath]]];
        [_myBrand addObject:tmpBrand];
        
    }
    
}
-(void)updateUI{
    [self.tableView reloadData];
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
    
    return _myBrand.count;
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYBrandListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandNameCell" forIndexPath:indexPath];
    MYBrandListCell *tmpBrand = [_myBrand objectAtIndex:indexPath.row];
    cell.brandName.text = tmpBrand.name;
    cell.brandImage.image = tmpBrand.logo;
      return cell;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MYBrandListCell *cell = [_myBrand objectAtIndex:indexPath.row];
    
    if ([segue.identifier isEqualToString:@"ToItemList"]){
        MYItemDetailTableViewController *itemDetailVC = segue.destinationViewController;
        NSDictionary *dict = @{@"content":@"TypeID",@"TypeID":@"*",@"BrandID":cell.brandID};
        itemDetailVC.postString = dict;
    }else{
        MYBrandDetailViewController *brandDetailVC = segue.destinationViewController;
        brandDetailVC.brandDetail  = cell;
    }
}


@end
