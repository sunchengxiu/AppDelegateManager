//
//  RCEAppDelegate.m
//  AppDelegateServiceManager
//
//  Created by 孙承秀 on 2018/6/13.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "RCEAppDelegate.h"
#import <objc/message.h>

@implementation RCEAppDelegate
- (NSArray<NSString *> *)methods{
    static dispatch_once_t onceToken;
    static NSMutableArray *methodList = nil;
    dispatch_once(&onceToken, ^{
        unsigned int count;
        struct objc_method_description *lists = protocol_copyMethodDescriptionList(@protocol(UIApplicationDelegate), NO, YES, &count);
        methodList = [NSMutableArray array];
        for (NSInteger i = 0; i < count; i ++ ) {
            struct objc_method_description method = lists[i];
            SEL selector = method.name;
            [methodList addObject:NSStringFromSelector(selector)];
        }
    });
    return methodList;
}
-(BOOL)respondsToSelector:(SEL)aSelector{
    IMP imp = [self methodForSelector:aSelector];
    BOOL has = imp != nil && imp !=_objc_msgForward;
    if (!has && [[self methods] containsObject:NSStringFromSelector(aSelector)]) {
        has = [[RCEAppDelegateServiceManager sharedServiceManager] canResponseToSelector:aSelector];
    }
    return has;
}
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    [[RCEAppDelegateServiceManager sharedServiceManager] submoduleForwardInvocation:anInvocation];
}
@end
