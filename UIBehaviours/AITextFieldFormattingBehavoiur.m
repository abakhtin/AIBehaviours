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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.forwarder forwardDelegateRespondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSString *reason = [NSString stringWithFormat:@"%@ uses %@ selector but it is overriden by forwardDelegate.",
                            self.class, NSStringFromSelector(@selector(textField:shouldChangeCharactersInRange:replacementString:))];
        [[NSException exceptionWithName:kDelegateMethodOverridenException reason:reason userInfo:nil] raise];
    }
    
    UITextRange *selectedTextRange = textField.selectedTextRange;
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = [self.formatter formatString:resultString];
    textField.selectedTextRange = selectedTextRange;
    return NO;
}

@end
