//
//  RootWindow.m
//  AppDelegateServiceManager
//
//  Created by 孙承秀 on 2018/6/13.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "RootWindow.h"
#import "ViewController.h"
@implementation RootWindow
RCE_REGISTER_SERVICE_NAME(RootWindow)
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.delegate.window = window;
    
    ViewController* dvc = [[ViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:dvc];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    return YES;
}
@end
