//
//  AITextFieldNumericFormatter.m
//  
//
//  Created by Alex on 1/4/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "AITextFieldNumericFormatter.h"

#import <objc/runtime.h>

@implementation AITextFieldNumericFormatter

- (NSString *)formatString:(NSString *)string {
    NSCharacterSet *nonDecimalSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *formattedString = [[string componentsSeparatedByCharactersInSet:nonDecimalSet] componentsJoinedByString:@""];
    return formattedString;
}

@end

@implementation UITextField (AITextFieldNumericFormatter)

- (void)setOnlyNumbers:(BOOL)onlyNumbers {
    objc_setAssociatedObject(self, @selector(onlyNumbers), @(onlyNumbers), OBJC_ASSOCIATION_ASSIGN);
    AITextFieldNumericFormatter *formatter = [[AITextFieldNumericFormatter alloc] init];
    [self addBehaviour:[[AITextFieldFormattingBehavoiur alloc] initWithFormatter:formatter]];
}

- (BOOL)onlyNumbers {
    return [objc_getAssociatedObject(self, @selector(onlyNumbers)) boolValue];
}

@end
