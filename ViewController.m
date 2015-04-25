//
//  ViewController.m
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
#import "MYItemListTableViewController.h"
#import "MYHomePageViewController.h"
#import "MYBrandListTableViewController.h"
#import "MYSALETableViewController.h"
@interface ViewController ()

@property(strong,nonatomic) MYItemListTableViewController *itemListTableVC;
@property(strong,nonatomic) MYHomePageViewController *homePageVC;
@property(strong,nonatomic) MYBrandListTableViewController *brandListTableVC;
@property(strong,nonatomic) MYSALETableViewController *saleTableVC;
@property NSInteger lastSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastSelected = 0;
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    //[leftButton addTarget:self action:@selector(backToBrandList)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;

    
    //初始化侧边菜单
    _sideSlipView = [[MYSideSlipView alloc]initWithSender:self];
    _sideSlipView.backgroundColor = [UIColor redColor];
    
    MenuView *menu = [MenuView menuView];
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
        NSLog(@"click");
        [_sideSlipView hide];
        [self pushViewController:indexPath];
        
    }];
    menu.items = @[@{@"title":@"主页",@"imagename":@"主页"},@{@"title":@"分类",@"imagename":@"分类"},@{@"title":@"品牌",@"imagename":@"品牌"},@{@"title":@"促销",@"imagename":@"出校"}];
    [_sideSlipView setContentView:menu];
    [self.view addSubview:_sideSlipView];
    
    self.homePageVC = [self.storyboard
                               instantiateViewControllerWithIdentifier:
                               @"HomePageIdentity"];
    [self.view insertSubview:self.homePageVC.view atIndex:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(NSIndexPath *) indexPath {
    
    if (indexPath.row == _lastSelected) {
        return;
    }
    if (_lastSelected == 0) {
        [self.homePageVC.view removeFromSuperview];
    }else if (_lastSelected == 1){
        [self.itemListTableVC.view removeFromSuperview];
    }else if (_lastSelected == 2){
        [self.brandListTableVC.view removeFromSuperview];
    }else if (_lastSelected == 3){
        [self.saleTableVC.view removeFromSuperview];
    }
    if(indexPath.row == 0){
        _lastSelected = 0;
        if (!self.homePageVC) {
            self.homePageVC = [self.storyboard
                               instantiateViewControllerWithIdentifier:@"HomePageIdentity"];
        }
        [self.view insertSubview:self.homePageVC.view atIndex:0];
    }else if(indexPath.row == 1){
        _lastSelected = 1;
        if (!self.itemListTableVC) {
            self.itemListTableVC = [self.storyboard
                                    instantiateViewControllerWithIdentifier:@"MYItemListTableIdentity"];
        }
        [self.view insertSubview:self.itemListTableVC.view atIndex:0];
    }else if(indexPath.row == 2){
        _lastSelected = 2;
        if (!self.brandListTableVC) {
            self.brandListTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MYBrandListIdentity"];
        }
        [self.view insertSubview:self.brandListTableVC.view atIndex:0];
    }else if(indexPath.row == 3){
        _lastSelected = 3;
        if (!self.saleTableVC){
            self.saleTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SALEIdentity"];
        }
        [self.view insertSubview:self.saleTableVC.view atIndex:0];
    }
}
- (IBAction)switchTouched:(UIButton *)sender {
    [_sideSlipView switchMenu];
}



@end
