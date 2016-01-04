//
//  UIView+AIBehaviour.m
//  
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "UIView+AIBehaviour.h"
#import "AIBehaviour.h"

@implementation UIView (AIBehaviour)

- (void)addBehaviour:(AIBehaviour *)behaviour {
    NSParameterAssert([behaviour isKindOfClass:[AIBehaviour class]]);
    behaviour.view = self;
}

@end
