//
//  MYFeedBackCell.m
//  MaoYe
//
//  Created by 易准 on 15/3/31.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYFeedBackCell.h"

@implementation MYFeedBackCell

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
        _feedMark = [[NSString alloc]init];
        _fDuser = [[NSString alloc]init];
        _fDcontent = [[NSString alloc]init];
        _fDuserID = [[NSString alloc]init];
        _fDFeedBackID = [[NSString alloc]init];
    }
    return self;
}
@end
