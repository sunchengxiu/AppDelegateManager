//
//  RCEAppDelegateServiceManager.h
//  AppDelegateServiceManager
//
//  Created by 孙承秀 on 2018/6/13.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol RCEAppDelegateService<UIApplicationDelegate>
@required
- (NSString *)serviceName;
@end
@interface RCEAppDelegateServiceManager : NSObject
+ (instancetype)sharedServiceManager;

/**
 注册子模块

 */
- (void)registerService:(id <RCEAppDelegateService>)service;

/**
 子模块是否可以响应消息

 */
- (BOOL)canResponseToSelector:(SEL)aSelector;

/**
 子模块进行消息转发
 */
- (void)submoduleForwardInvocation:(NSInvocation *)invocation;
@end
