//
//  AIBehaviour.h
//  
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AIBehaviour.h"

@interface AIBehaviour : NSObject
@property (nonatomic, weak) IBOutlet UIView *view;
+ (instancetype)behaviourForView:(UIView *)view;
@end
