//
//  TextFieldFormattingBehavoiur.m
//  UIBehavioursExample
//
//  Created by Alex on 1/3/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "TextFieldFormattingBehavoiur.h"
#import "DelegateForwarder.h"

@implementation TextFieldNumericFormatter

- (NSString *)formatString:(NSString *)string {
    NSCharacterSet *nonDecimalSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *formattedString = [[string componentsSeparatedByCharactersInSet:nonDecimalSet] componentsJoinedByString:@""];
    return formattedString;
}

@end


@interface TextFieldFormattingBehavoiur () <UITextFieldDelegate>
@property (nonatomic, weak) UITextField *view;
@end

@implementation TextFieldFormattingBehavoiur
@dynamic view;

- (void)setView:(UITextField *)view {
    NSParameterAssert([view isKindOfClass:[UITextField class]]);
    [super setView:view];
    [DelegateForwarder forwardMethodsToInterceptor:self forObject:view delegateKeyPath:@"delegate"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSString *reason = [NSString stringWithFormat:@"%@ uses %@ selector but it is overriden by %@ (delegate)",
                            self.class, NSStringFromSelector(@selector(textField:shouldChangeCharactersInRange:replacementString:)), textField.delegate];
        [[NSException exceptionWithName:kDelegateMethodOverridenException reason:reason userInfo:nil] raise];
    }
    
    UITextRange *selectedTextRange = textField.selectedTextRange;
    textField.text = [self.formatter formatString:textField.text];
    textField.selectedTextRange = selectedTextRange;

    return NO;
}

@end
