//
//  AITextFieldNumericFormatter.h
//  
//
//  Created by Alex on 1/4/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITextFieldFormattingBehavoiur.h"

@interface AITextFieldNumericFormatter : NSObject <AITextFieldFormatting>

@end

@interface UITextField (AITextFieldNumericFormatter)
@property (nonatomic, assign) IBInspectable BOOL onlyNumbers;
@end
