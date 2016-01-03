//
//  DelegateForwarder.h
//  UIBehavioursExample
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kDelegateMethodOverridenException;

@interface DelegateForwarder : NSObject
+ (void)forwardMethodsToInterceptor:(id)interceptor forObject:(id)object delegateKeyPath:(NSString *)delegateKeyPath;
@end
