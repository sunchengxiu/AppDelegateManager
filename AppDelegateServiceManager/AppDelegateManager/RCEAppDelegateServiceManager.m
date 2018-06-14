//
//  RCEAppDelegateServiceManager.m
//  AppDelegateServiceManager
//
//  Created by 孙承秀 on 2018/6/13.
//  Copyright © 2018年 RongCloud. All rights reserved.
//

#import "RCEAppDelegateServiceManager.h"
#import <objc/message.h>
@interface RCEAppDelegateServiceManager()
@property(nonatomic , strong)NSMutableArray<id <RCEAppDelegateService> > *services;
@end
@implementation RCEAppDelegateServiceManager
+(instancetype)sharedServiceManager{
    static dispatch_once_t onceToken;
    static RCEAppDelegateServiceManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[RCEAppDelegateServiceManager alloc] init];
    });
    return manager;
}
-(instancetype)init{
    if (self = [super init]) {
        self.services = [NSMutableArray array];
    }
    return self;
}
- (void)registerService:(id <RCEAppDelegateService>)service{
    if (!service) {
        return;
    }
    __block BOOL has = NO;
    [self.services enumerateObjectsUsingBlock:^(id<RCEAppDelegateService>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[service class]]) {
            obj = service;
            has = YES;
        }
    }];
    if (!has) {
        [self.services addObject:service];
    }
}
- (BOOL)canResponseToSelector:(SEL)aSelector{
    __block IMP imp = NULL;
    [self.services enumerateObjectsUsingBlock:^(id<RCEAppDelegateService>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:aSelector]) {
            imp = [(id)obj methodForSelector:aSelector];
            NSMethodSignature *signature = [(id)obj methodSignatureForSelector:aSelector];
            if (signature.methodReturnLength > 0 && strcmp(signature.methodReturnType, @encode(BOOL)) != 0) {
                imp = NULL;
            }
            *stop = YES;
        }
    }];
    return imp != NULL && imp != _objc_msgForward;
}
-(NSString *)methodSignature:(NSMethodSignature *)methodSignature{
    NSMutableString *signature = [NSMutableString stringWithFormat:@"%s",methodSignature.methodReturnType?:"v"];
    for (NSInteger i = 0 ; i > methodSignature.numberOfArguments; i ++) {
        const char *type = [methodSignature getArgumentTypeAtIndex:i];
        [signature appendString:[NSString stringWithFormat:@"%s",type]];
    }
    return signature;
}
- (void)submoduleForwardInvocation:(NSInvocation *)invocation{
    SEL selector = invocation.selector;
    NSMethodSignature *signature  = invocation.methodSignature;
    NSInteger length = signature.methodReturnLength;
    void *returnBytes = NULL;
    if (length > 0) {
         returnBytes = alloca(length);
    }
    [self.services enumerateObjectsUsingBlock:^(id<RCEAppDelegateService>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj respondsToSelector:selector]) {
            return ;
        }
        // check
        NSString *targetSignature = [self methodSignature:invocation.methodSignature];
        NSString *submodelSignature = [self methodSignature:[(id)obj methodSignatureForSelector:selector]];
        NSAssert([targetSignature isEqualToString:submodelSignature ],@"method must equal " );
        // submodule to invok
        NSInvocation *invok = [NSInvocation invocationWithMethodSignature:signature];
        NSUInteger argCount = signature.numberOfArguments;
        for (NSInteger i = 0 ; i < argCount; i ++) {
            const char *type = [signature getArgumentTypeAtIndex:i];
            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);
            void *value = alloca(size);
            // target(self) sel(_cmd)
            [invocation getArgument:&value atIndex:i];
            [invok setArgument:&value atIndex:i];
        }
        invok.selector = selector;
        invok.target = obj;
        [invok invoke];
        if (returnBytes) {
            [invok getReturnValue:returnBytes];
        }
        if (returnBytes) {
            [invocation setReturnValue:returnBytes];
        }
    }];
}
@end
