//
//  MYFeedBackTableViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/31.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYFeedBackTableViewController.h"
#import "AFNetworking.h"
#import "MYFeedBackCell.h"

@interface MYFeedBackTableViewController ()

@property(strong,nonatomic) NSDictionary *feedBackList;
@property(strong,nonatomic) NSMutableArray *myFeedBack;

@end

@implementation MYFeedBackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTo)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 20;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    
    _feedBackList = [[NSDictionary alloc]init];
    _myFeedBack = [[NSMutableArray alloc]init];
    [self getFeedBAckList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getFeedBAckList{
    
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2.设置登录参数
    NSDictionary *dict = @{@"content":@"FeedBack",@"GoodsID":_goodsID};
    
    //3.请求
    [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        _feedBackList = responseObject;
        //NSLog(@"POST --> %@",responseObject);
        [self GetFeedBackDetail];
        [self performSelectorOnMainThread:@selector(updateUI)withObject:nil waitUntilDone:YES];
        [NSThread currentThread];
        //  NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

-(void)GetFeedBackDetail{
    NSArray * tmp = [_feedBackList objectForKey:@"FeedBack"];
    NSUInteger dicCount = [tmp count];
    
    for(int i=1;i<dicCount;i++)
    {
        NSDictionary *t1 = tmp[i];
        NSArray *_fDDetail = [[NSArray alloc]init];
        _fDDetail = [t1 objectForKey:[[NSString alloc]initWithFormat:@"%d",i+1]];
        MYFeedBackCell *tmpFD = [[MYFeedBackCell alloc]init];
        tmpFD.fDuser = _fDDetail[0];
        tmpFD.fDcontent = _fDDetail[1];
        tmpFD.fDuserID = _fDDetail[2];
        tmpFD.fDFeedBackID = _fDDetail[3];
        [_myFeedBack addObject:tmpFD];
        
    }
    
}

-(void)updateUI{
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)backTo
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
    return _myFeedBack.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MYFeedBackCell" forIndexPath:indexPath];
    MYFeedBackCell *tmp = [_myFeedBack objectAtIndex:indexPath.row];
    cell.fDContent.text = tmp.fDcontent;
    cell.fDUser.text = tmp.fDuser;
    // Configure the cell...
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
