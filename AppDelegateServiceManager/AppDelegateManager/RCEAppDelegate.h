//
//  RCEAppDelegate.h
//  AppDelegateServiceManager
//
//  Created by 孙承秀 on 2018/6/13.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCEAppDelegateServiceManager.h"

#define RCE_REGISTER_SERVICE_NAME(name) \
+(void)load{\
[[RCEAppDelegateServiceManager sharedServiceManager] registerService:[self new]];\
}\
-(NSString *)serviceName{\
return @#name;\
}

@interface RCEAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end
