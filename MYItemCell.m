//
//  MYItemCell.m
//  MaoYe
//
//  Created by 易准 on 15/3/24.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYItemCell.h"

@implementation MYItemCell

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
        _Name = [[UILabel alloc] init];
        _Name.frame= CGRectMake(100, 0, 50, 30);
        [self.contentView addSubview:_Name];//将控件插入uitablviewecell
        _Comments = [[UILabel alloc]init];
        _Comments.frame = CGRectMake(60, 0, 50, 30);
        [self.contentView addSubview:_Comments];//将控件插入uitablviewecell
        _Open=false;//默认子控件是关闭的
    }
    return self;
}
@end
