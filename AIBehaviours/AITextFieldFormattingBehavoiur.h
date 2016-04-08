//
//  AITextFieldFormattingBehavoiur.h
//  
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "AIBehaviour.h"

@protocol AITextFieldFormatting <NSObject>
- (NSString *)formatString:(NSString *)originalString range:(NSRange)range replacementString:(NSString *)replacementString adjustCursorIndex:(NSInteger *)adjustCursorIndex;
@end

@interface AITextFieldFormattingBehavoiur : AIBehaviour
- (instancetype)initWithFormatter:(id<AITextFieldFormatting>)formatter;
@property (nonatomic, strong) IBOutlet id<AITextFieldFormatting> formatter;
@end
