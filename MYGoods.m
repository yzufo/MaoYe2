//
//  MYGoods.m
//  MaoYe
//
//  Created by 易准 on 15/3/24.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYGoods.h"

@implementation MYGoods

-(id)init{
    if(self = [super init]){
        _name = [[NSString alloc]init];
        _price = [[NSString alloc]init];
        _imagePath = [[NSString alloc]init];
        _introduction = [[NSString alloc]init];
        _brandID = [[NSString alloc]init];
        _goodsId = [[NSString alloc]init];
    
    }
    return self;
}

@end
