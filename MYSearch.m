//
//  MYSearch.m
//  MaoYe
//
//  Created by 易准 on 15/4/25.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYSearch.h"
#import "MYItemDetailTableViewController.h"
#import "MYBrandListTableViewController.h"
@interface MYSearch ()
@property (weak, nonatomic) IBOutlet UITextField *searchText;

@end

@implementation MYSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToBrandList)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 20;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    // Do any additional setup after loading the view.
}
- (IBAction)backgroundTap:(id)sender {
    [self.searchText resignFirstResponder];
}

-(void)backToBrandList
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DoneEditing:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchBrand"]){
        MYBrandListTableViewController *brandVC = segue.destinationViewController;
        NSDictionary *dict = @{@"content":@"SearchBrand",@"TypeID":_searchText.text};
        brandVC.postString = dict;
    }
    else{
        MYItemDetailTableViewController *itemVC = segue.destinationViewController;
        NSDictionary *dict = @{@"content":@"SearchItem",@"TypeID":_searchText.text};
        itemVC.postString = dict;
    }
}


@end
