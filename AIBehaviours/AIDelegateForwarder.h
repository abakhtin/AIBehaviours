//
//  AIDelegateForwarder.h
//
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDelegateMethodOverridenException;

@interface AIDelegateForwarder : NSObject
+ (AIDelegateForwarder *)forwarderForInterceptor:(id)interceptor object:(id)object delegateKeyPath:(NSString *)delegateKeyPath;
- (void)removeInterceptor:(id)interceptor;
- (BOOL)forwardDelegateRespondsToSelector:(SEL)selector;
@end
