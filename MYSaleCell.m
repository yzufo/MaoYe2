//
//  MYSaleCell.m
//  MaoYe
//
//  Created by 易准 on 15/3/30.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYSaleCell.h"

@implementation MYSaleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)init
{
    if(self = [super init])
    {
        _proName  = [[NSString alloc] init];
        _proDetail  = [[NSString alloc] init];
        _proStartTime  = [[NSString alloc] init];
        _proEndTime  = [[NSString alloc] init];
        _pic = [[UIImage alloc]init];
    }
    return self;
}
@end
