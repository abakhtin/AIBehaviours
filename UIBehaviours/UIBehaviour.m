//
//  UIBehaviour.m
//  UIBehavioursExample
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "UIBehaviour.h"
#import <objc/runtime.h>

@implementation UIBehaviour

- (void)setView:(UIView *)view {
    _view = view;
    UIBehaviour *behaviour = objc_getAssociatedObject(view, (__bridge void *)[self class]);
    if (behaviour == nil) {
        objc_setAssociatedObject(view, (__bridge void *)[self class], self, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
