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

@interface MYGoodsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsIntroduction;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end

@implementation MYGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToBrandList)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 13;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    _goodsName.text = _goodDetail.name;
    _goodsIntroduction.text = _goodDetail.introduction;
    _goodsPrice.text = _goodDetail.price;
    [_goodsView setImageWithURL:[NSURL URLWithString:_goodDetail.imagePath]];
    NSLog(@"%@",_goodDetail.name);
    // Do any additional setup after loading the view.
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
