//
//  AIBehaviour.m
//  
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "AIBehaviour.h"
#import <objc/runtime.h>

@implementation AIBehaviour

- (void)setView:(UIView *)view {
    _view = view;
    AIBehaviour *behaviour = objc_getAssociatedObject(view, (__bridge void *)[self class]);
    if (behaviour == nil) {
        objc_setAssociatedObject(view, (__bridge void *)[self class], self, OBJC_ASSOCIATION_RETAIN);
    }
}

+ (instancetype)behaviourForView:(UIView *)view {
    return objc_getAssociatedObject(view, (__bridge void *)[self class]);
}

@end
