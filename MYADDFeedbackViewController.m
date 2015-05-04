//
//  MYADDFeedbackViewController.m
//  MaoYe
//
//  Created by 易准 on 15/4/27.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYADDFeedbackViewController.h"
#import "AFNetworking.h"
#import "MYFeedBackTableViewController.h"
@interface MYADDFeedbackViewController ()
@property (strong,nonatomic) NSString *account;
@property (strong,nonatomic) NSString *userID;
@property(nonatomic,strong) UITextField *firstField;
@end

@implementation MYADDFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _wordCount.text = @"250";
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 20;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _account = [[NSString alloc]init];
    _account = [defaults objectForKey:@"name_preference"];
    if([_fdview isEqualToString:@""])
    {
        if(![_account isEqualToString:@""]){
            [self getUserID];
        }
    }else{
        _feedbackField.editable = NO;
        _submitButton.hidden = YES;
        _lackword.hidden = YES;
        _wordCount.hidden = YES;
        _notewrite.text = _userName;
        _feedbackField.text = _fdview;
        
        
    }
    
    // Do any additional setup after loading the view.
}


-(void)getUserID{
    NSString * username = [[NSString alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    username = [defaults objectForKey:@"name_preference"];
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{@"content":@"GETUSERID",@"UserName":_account};
    //3.请求
    [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [self getResponse:responseObject];
        NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(void)getResponse:(NSDictionary *)response{
    NSArray * tmp = [[NSArray alloc] init];
    tmp = [response objectForKey:@"User"];
    NSDictionary *t1 = tmp[1];
    NSArray *userDetail = [t1 objectForKey:@"2"];
    _userID = userDetail[0];
    NSLog(@"%@",_userID);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    
}
- (IBAction)submitFeedback:(UIButton *)sender {
    NSLog(@"%@",_feedbackField.text);
    [_feedbackField resignFirstResponder];
    [self insertReview];
}
-(void)insertReview{
    NSString  *urlString = @"http://localhost/3.23/getinfo.php";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{@"content":@"insertReview",@"Review":_feedbackField.text,@"UserID":_userID,@"goodsID":_goodsID};
    //3.请求
    [manager POST:urlString parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        MYFeedBackTableViewController *feedBackVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        //使用popToViewController返回并传值到上一页面
        NSLog(@"%@",responseObject);
        feedBackVC.backMark = @"112321";
        [self.navigationController popToViewController:feedBackVC animated:true];
        NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //不允许继续输入
    if (range.location > 250) {
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    _wordCount.text = [NSString stringWithFormat:@"%d",250 - _feedbackField.text.length];
    
    NSLog(@"%@",_wordCount.text);
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
