//
//  MYSaleCell.h
//  MaoYe
//
//  Created by 易准 on 15/3/30.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSaleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *saleImage;
@property (nonatomic,strong) NSString *imagePath;
@property (nonatomic,strong) NSString *proName;
@property (nonatomic,strong) NSString *proDetail;
@property (nonatomic,strong) NSString *proStartTime;
@property (nonatomic,strong) NSString *proEndTime;
@property (strong,nonatomic) UIImage *pic;
@end
