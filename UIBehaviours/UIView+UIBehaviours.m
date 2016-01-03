//
//  UIView+UIBehaviours.m
//  UIBehavioursExample
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "UIView+UIBehaviours.h"
#import "UIBehaviour.h"

@implementation UIView (UIBehaviours)

- (void)addBehaviour:(UIBehaviour *)behaviour {
    NSParameterAssert([behaviour isKindOfClass:[UIBehaviour class]]);
    behaviour.view = self;
}

@end
