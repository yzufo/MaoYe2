//
//  MYADDFeedbackViewController.h
//  MaoYe
//
//  Created by 易准 on 15/4/27.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PropagateDelegate <NSObject>

@required
-(void)propagateToValue:(NSString *)result;

@end

@interface MYADDFeedbackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *notewrite;
@property (weak, nonatomic) IBOutlet UILabel *lackword;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextView *feedbackField;
@property(nonatomic,assign) id<PropagateDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *wordCount;
@property (strong,nonatomic) NSString *goodsID;
@property (strong,nonatomic) NSString *fdview;
@property (strong,nonatomic) NSString *userName;
@end
