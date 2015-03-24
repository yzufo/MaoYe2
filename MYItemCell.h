//
//  MYItemCell.h
//  MaoYe
//
//  Created by 易准 on 15/3/24.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYItemCell : UITableViewCell

@property (nonatomic,retain) UILabel * Name;
@property (nonatomic,retain) UILabel * Comments;
@property (nonatomic,retain) NSString * ID;
@property (nonatomic,strong) NSArray *ChildArray;//存放子菜单
@property (nonatomic,assign) BOOL  Open;//表示子菜单是否打开


@end
