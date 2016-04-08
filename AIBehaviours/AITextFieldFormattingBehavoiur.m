//
//  AITextFieldFormattingBehavoiur.m
//
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "AITextFieldFormattingBehavoiur.h"
#import "AIDelegateForwarder.h"

@interface AITextFieldFormattingBehavoiur ()
@property (nonatomic, weak) AIDelegateForwarder *forwarder;
@end

@interface AITextFieldFormattingBehavoiur () <UITextFieldDelegate>
@property (nonatomic, weak) UITextField *view;
@end

@implementation AITextFieldFormattingBehavoiur
@dynamic view;

- (instancetype)initWithFormatter:(id<AITextFieldFormatting>)formatter {
    if (self = [super init]) {
        self->_formatter = formatter;
    }
    return self;
}

- (void)setView:(UITextField *)view {
    NSParameterAssert([view isKindOfClass:[UITextField class]]);
    [super setView:view];

    self.forwarder = [AIDelegateForwarder forwarderForInterceptor:self object:view delegateKeyPath:@"delegate"];
}

#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.forwarder forwardDelegateRespondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSString *reason = [NSString stringWithFormat:@"%@ uses %@ selector but it is overriden by forwardDelegate.",
                            self.class, NSStringFromSelector(@selector(textField:shouldChangeCharactersInRange:replacementString:))];
        [[NSException exceptionWithName:kDelegateMethodOverridenException reason:reason userInfo:nil] raise];
    }

    NSInteger adjustCursorIndex = 0;
    textField.text = [self.formatter formatString:textField.text range:range replacementString:string adjustCursorIndex:&adjustCursorIndex];

    UITextPosition *caretPosition = [textField positionFromPosition:textField.beginningOfDocument offset:range.location + adjustCursorIndex];
    textField.selectedTextRange = [textField textRangeFromPosition:caretPosition toPosition:caretPosition];

    return NO;
}

@end
