//
//  MYSaleDetail.h
//  MaoYe
//
//  Created by 易准 on 15/3/30.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSaleCell.h"
@interface MYSaleDetail : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *proDetail;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *proImage;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (strong,nonatomic) MYSaleCell *myPro;
-(NSTimeInterval)getTime:(NSString *)startEndTime;
@end
