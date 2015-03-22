//
//  ViewController.h
//  MaoYe
//
//  Created by 易准 on 15/3/22.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSideSlipView.h"
@interface ViewController : UIViewController
{
     MYSideSlipView *_sideSlipView;
}
- (IBAction)switchTouched:(UIButton *)sender;


@end

