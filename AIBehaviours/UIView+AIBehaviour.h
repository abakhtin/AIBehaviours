//
//  UIView+AIBehaviour.h
//
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AIBehaviour;

@interface UIView (AIBehaviour)
- (void)addBehaviour:(AIBehaviour *)behaviour;
@end
