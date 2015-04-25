//
//  MYBrandDetailViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/26.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYBrandDetailViewController.h"
#import "UIImageView+AFNetworking.h"
@interface MYBrandDetailViewController ()

@end

@implementation MYBrandDetailViewController

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
    
    _brandImage.image = _brandDetail.logo;
    _brandName.text = _brandDetail.name;
    _brandIntroduction.text = _brandDetail.brandIntroduction;
    // Do any additional setup after loading the view.
}
-(void)backToBrandList
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)init{
    if(self = [super init]){
        _brandDetail = [[MYBrandListCell alloc]init];
    }
    return self;
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
