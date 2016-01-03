//
//  DelegateForwarder.m
//  UIBehavioursExample
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "DelegateForwarder.h"
#import <objc/runtime.h>

NSString *kDelegateMethodOverridenException = @"kDelegateMethodOverridenException";

@interface DelegateForwarder ()
@property (nonatomic, weak) id interceptor;
@property (nonatomic, weak) id forwardDelegate;

@property (nonatomic, assign) id object;
@property (nonatomic, copy) id delegateKeyPath;
@end

@implementation DelegateForwarder

+ (void)forwardMethodsToInterceptor:(id)interceptor forObject:(id)object delegateKeyPath:(NSString *)delegateKeyPath {
    DelegateForwarder *forwarder = objc_getAssociatedObject(interceptor, (__bridge void *)[self class]);
    if (forwarder == nil) {
        forwarder = [[self alloc] init];
        objc_setAssociatedObject(interceptor, (__bridge void *)[self class], forwarder, OBJC_ASSOCIATION_RETAIN);
    }
    forwarder.interceptor = interceptor;
    forwarder.object = object;
    forwarder.delegateKeyPath = delegateKeyPath;
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial;
    [object addObserver:forwarder forKeyPath:delegateKeyPath options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id newDelegate = [change objectForKey:NSKeyValueChangeNewKey];
    if (newDelegate != self) {
        self.forwardDelegate = newDelegate;
        [object setValue:self forKeyPath:keyPath];
    }
}

- (void)dealloc {
    [self.object removeObserver:self forKeyPath:self.delegateKeyPath];
}

#pragma mark - Forward

- (BOOL)respondsToSelector:(SEL)selector {
    BOOL result = [super respondsToSelector:selector];
    result = result ?: [self.interceptor respondsToSelector:selector];
    result = result ?: [self.forwardDelegate respondsToSelector:selector];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    BOOL responded = [super respondsToSelector:invocation.selector];
    if (responded == NO && [self.interceptor respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.interceptor];
    }
    if (responded == NO && [self.forwardDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.forwardDelegate];
    }
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) signature = [self.interceptor methodSignatureForSelector:selector];
    if (!signature) signature = [self.forwardDelegate methodSignatureForSelector:selector];
    return signature;
}

@end
