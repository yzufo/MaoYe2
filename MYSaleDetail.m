//
//  MYSaleDetail.m
//  MaoYe
//
//  Created by 易准 on 15/3/30.
//  Copyright (c) 2015年 易准. All rights reserved.
//

#import "MYSaleDetail.h"
#import "UIImageView+AFNetworking.h"
@interface MYSaleDetail ()

@end

@implementation MYSaleDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _proName.text = _myPro.proName;
    _proDetail.text = _myPro.proDetail;
    _proImage.image = _myPro.pic;
    _notificationSwitch.on = NO;
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"%@", localNotifications);
    
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notiID = noti.userInfo[@"kLocalNotificationID"];
        if ([notiID isEqualToString:_myPro.proName])
            _notificationSwitch.on = YES;
    }
        
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setImage:[UIImage imageNamed:@"Left Reveal Icon.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToSaleList)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = 13;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexSpacer,leftItem, nil,nil]];
    // Do any additional setup after loading the view.
}
    
-(void)backToSaleList
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchChanged:(UISwitch *)sender {
    if(_notificationSwitch.on == YES){
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        if(notification){
            NSDate *currentDate   = [NSDate date];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            NSTimeInterval cha = [self getTime:_myPro.proStartTime];
            if(cha < 0)
                 return;
            notification.fireDate = [currentDate dateByAddingTimeInterval:cha];
            // 设置重复间隔
            //  notification.repeatInterval = kCFCalendarUnitDay;
            notification.alertBody   = @"Wake up, man";
            notification.alertAction = NSLocalizedString(@"起床了", nil);
            // 通知提示音 使用默认的
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            // 设置应用程序右上角的提醒个数
            notification.applicationIconBadgeNumber++;
            // 设定通知的userInfo，用来标识该通知
            NSMutableDictionary *aUserInfo = [[NSMutableDictionary alloc] init];
            aUserInfo[@"kLocalNotificationID"] = _myPro.proName;
            notification.userInfo = aUserInfo;
            
            // 将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
        }
    }else {
        for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString *notiID = noti.userInfo[@"kLocalNotificationID"];
            if ([notiID isEqualToString:_myPro.proName]) {
                noti.applicationIconBadgeNumber--;
                [[UIApplication sharedApplication] cancelLocalNotification:noti];
                return;
            }
        }
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"Application did receive local notifications");
    
    // 取消某个特定的本地通知
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notiID = noti.userInfo[@"kLocalNotificationID"];
        NSString *receiveNotiID = notification.userInfo[@"kLocalNotificationID"];
        if ([notiID isEqualToString:receiveNotiID]) {
            notification.applicationIconBadgeNumber--;
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            return;
        }
    }
}

-(NSTimeInterval)getTime:(NSString *)startEndTime{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    NSDate *d=[date dateFromString:startEndTime];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=late-now;
    timeString = [NSString stringWithFormat:@"%f", cha];
    NSLog(@"%f",cha);
    return cha;
    
}

-(id)init{
    if(self = [super init]){
     //   _brandDetail = [[MYBrandListCell alloc]init];
    }
    return self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
