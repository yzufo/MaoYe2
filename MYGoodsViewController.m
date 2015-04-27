//
//  MYGoodsViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYGoodsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MYFeedBackTableViewController.h"
#import "AFNetworking.h"
#import "SlidingViewManager.h"
@interface MYGoodsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduction;
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;
@property (strong,nonatomic) UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) NSString *account;
@property (strong,nonatomic) NSString *userID;
@end

@implementation MYGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_wishListSwitch setOn:NO];
    [self subtitleInit];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToBrandList)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 20;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    _goodsName.text = _goodDetail.name;
    _goodsIntroduction.text = _goodDetail.introduction;
    _goodsPrice.text = _goodDetail.price;
    [_goodsView setImageWithURL:[NSURL URLWithString:_goodDetail.imagePath]];
    // NSLog(@"%@",_goodDetail.goodsId);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _account = [[NSString alloc]init];
    _account = [defaults objectForKey:@"name_preference"];
    if(![_account isEqualToString:@""])
        [self getWishList];
    
    // Do any additional setup after loading the view.
}

- (void)getWishList{
    NSString * username = [[NSString alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"name_preference"];
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{@"content":@"SelectWishList",@"UserName":username,@"GoodsID":_goodDetail.goodsId};
    
    //3.请求
    [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        [NSThread currentThread];
        [self getResponse:responseObject];
        NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)getResponse:(NSDictionary *)response{
    NSArray * tmp = [[NSArray alloc] init];
    tmp = [response objectForKey:@"User"];
    if( tmp.count > 1 ){
        [_wishListSwitch setOn:YES];
    }else {
        [_wishListSwitch setOn:NO];
        
    }
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

- (IBAction)switchChanged:(UISwitch *)sender {
    if([_account isEqualToString:@""]){
        [self showAlrt:@"请先前往主页登录!" red:255/255.0 green:0/255.0 blue:0/255.0];
        NSLog(@"没登陆");
        if (_wishListSwitch.on == YES) {
            [_wishListSwitch setOn:NO];
        }else{
            [_wishListSwitch setOn:YES];
        }
        return;
    }
    NSString * username = [[NSString alloc]init];
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"name_preference"];
    if(_wishListSwitch.on == YES){
        // NSLog(@"%@----%@",username,_goodDetail.goodsId);
        
        //2.设置登录参数
        NSDictionary *dict = @{@"content":@"InsertWishList",@"UserName":username,@"GoodsID":_goodDetail.goodsId};
        
        //3.请求
        [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            [NSThread currentThread];
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }else{
        NSDictionary *dict = @{@"content":@"DeleteWishList",@"UserName":username,@"GoodsID":_goodDetail.goodsId};
        [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
            [NSThread currentThread];
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backToBrandList
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MYFeedBackTableViewController *feedBackVC = segue.destinationViewController;
    feedBackVC.goodsID = _goodDetail.goodsId;
}


@end
