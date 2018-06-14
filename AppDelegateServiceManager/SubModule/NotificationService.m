//
//  NotificationService.m
//  AppDelegateServiceManager
//
//  Created by 孙承秀 on 2018/6/13.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "NotificationService.h"

@implementation NotificationService
RCE_REGISTER_SERVICE_NAME(NotificationService);
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"我是notification");
    return YES;
}
@end
