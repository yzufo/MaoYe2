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
#import "SlidingViewManager.h"
#import "MYADDFeedbackViewController.h"

@interface MYFeedBackTableViewController ()

@property(strong,nonatomic) NSDictionary *feedBackList;
@property(strong,nonatomic) NSMutableArray *myFeedBack;
@property (strong,nonatomic) UILabel *subtitleLabel;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [[NSString alloc]init];
    account = [defaults objectForKey:@"name_preference"];
    if([account isEqualToString:@""])
    {
        _pushButton.hidden = YES;
        [self showAlrt:@"请登陆后发表评论！" red:0/255.0 green:0/255.0 blue:255/255.0];
        
    }else{
        _pushButton.hidden = NO;
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged:back:) forControlEvents:UIControlEventValueChanged];
}
- (void)RefreshViewControlEventValueChanged:(id)sender back:(BOOL)back{
    
    if (self.refreshControl.refreshing || back == YES) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
        
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0.5];
    }
}

-(void)handleData{
    NSLog(@"refreshed");
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    _myFeedBack = [[NSMutableArray alloc]init];
    [self getFeedBAckList];
}

-(void)subtitleInit{
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
    _subtitleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.f];
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleLabel.frame = CGRectMake(10,10,300,30);
    
}

-(void)showAlrt:(NSString *)showString red:(float)red green:(float)green blue:(float)blue{
    
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    notificationView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    _subtitleLabel.text = showString;
    [notificationView addSubview:_subtitleLabel];
    SlidingViewManager *svm = [[SlidingViewManager alloc] initWithInnerView:notificationView containerView:self.view];
    [svm slideViewIn];
    
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
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
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
        NSDate *d=[date dateFromString:_fDDetail[4]];
        tmpFD.fDTime = [date stringFromDate:d];
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
    cell.feedbackTime.text = tmp.fDTime;
    // Configure the cell...
    
    return cell;
}
-(void)viewDidAppear:(BOOL)animated{
    if(![_backMark isEqualToString:@""])
      [self RefreshViewControlEventValueChanged:NULL back:YES];
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
     MYADDFeedbackViewController *addFeedbackVC = segue.destinationViewController;
     addFeedbackVC.goodsID = _goodsID;
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end
