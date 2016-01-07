//
//  AIDelegateForwarder.m
//
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "AIDelegateForwarder.h"
#import <objc/runtime.h>

NSString *kDelegateMethodOverridenException = @"kDelegateMethodOverridenException";

@interface AIDelegateForwarder ()
@property (nonatomic, weak) id interceptor;
@property (nonatomic, weak) id forwardDelegate;

@property (nonatomic, weak) id object;
@property (nonatomic, copy) id delegateKeyPath;
@end

@implementation AIDelegateForwarder

+ (AIDelegateForwarder *)forwarderForInterceptor:(id)interceptor object:(id)object delegateKeyPath:(NSString *)delegateKeyPath {
    AIDelegateForwarder *forwarder = objc_getAssociatedObject(interceptor, (__bridge void *)[self class]);
    if (forwarder == nil) {
        forwarder = [[self alloc] init];
        objc_setAssociatedObject(object, (__bridge void *)[self class], forwarder, OBJC_ASSOCIATION_RETAIN);
    }
    forwarder.interceptor = interceptor;
    forwarder.object = object;
    forwarder.delegateKeyPath = delegateKeyPath;
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial;
    [object addObserver:forwarder forKeyPath:delegateKeyPath options:options context:nil];
    return forwarder;
}

- (void)removeInterceptor:(id)interceptor {
    if (self.interceptor == interceptor) {
        self.interceptor = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    id newDelegate = [change objectForKey:NSKeyValueChangeNewKey];
    if (newDelegate != self) {
        self.forwardDelegate = [newDelegate isKindOfClass:[NSNull class]] ? nil : newDelegate;
        [object setValue:self forKeyPath:keyPath];
    }
}

- (void)dealloc {
    [self.object removeObserver:self forKeyPath:self.delegateKeyPath];
}

- (BOOL)forwardDelegateRespondsToSelector:(SEL)selector {
    return [self.forwardDelegate respondsToSelector:selector];
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
