//
//  TextFieldFormattingBehavoiur.h
//  UIBehavioursExample
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "UIBehaviour.h"

@protocol TextFieldFormatting <NSObject>
- (NSString *)formatString:(NSString *)string;
@end

@interface TextFieldNumericFormatter : NSObject <TextFieldFormatting>
@end

@interface TextFieldFormattingBehavoiur : UIBehaviour
@property (nonatomic, strong) id<TextFieldFormatting> formatter;
@end
