//
//  MYFeedBackTableViewController.h
//  MaoYe
//
//  Created by 易准 on 15/3/31.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYFeedBackTableViewController : UITableViewController

@property(strong,nonatomic) NSString *goodsID;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTime;
@property (strong,nonatomic) NSString *backMark;
@end
