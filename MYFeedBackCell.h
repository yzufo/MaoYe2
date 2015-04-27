//
//  MYFeedBackCell.h
//  MaoYe
//
//  Created by 易准 on 15/3/31.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYFeedBackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fDContent;
@property (weak, nonatomic) IBOutlet UILabel *fDUser;
@property (strong,nonatomic) NSString *feedMark;
@property (strong,nonatomic) NSString *fDcontent;
@property (strong,nonatomic) NSString *fDuser;
@property (strong,nonatomic) NSString *fDuserID;
@property (strong,nonatomic) NSString *fDFeedBackID;
@property (strong,nonatomic) NSString *fDTime;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTime;

@end
