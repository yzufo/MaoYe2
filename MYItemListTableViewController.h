//
//  MYItemListTableViewController.h
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYItemCell;
@interface MYItemListTableViewController : UITableViewController
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * TableArry;//要添加的进uitableview的数组，里面存放的是tablecell
@property (nonatomic,strong) NSMutableArray * InsertArry;//中间处理过程数组，用于插入子视图
@property (nonatomic,strong) NSMutableArray * DeleteArry;//中间处理过程数组，用于删除子视图
-(NSArray *) insertOperation:(MYItemCell *)item;//插入视图处理函数
-(NSArray *) deleteOperation:(MYItemCell *) item;//删除视图处理函数

@end
