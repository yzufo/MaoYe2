//
//  MYBrandDetailViewController.h
//  MaoYe
//
//  Created by 易准 on 15/3/26.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBrandListCell.h"
@interface MYBrandDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *brandIntroduction;
@property (strong,nonatomic) MYBrandListCell *brandDetail;
@end
