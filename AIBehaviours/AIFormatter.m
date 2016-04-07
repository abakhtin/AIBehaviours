//
//  AITextFieldNumericFormatter.m
//  
//
//  Created by Alex on 1/4/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "AIFormatter.h"
#import "NSString+AIFormatter.h"
#import <objc/runtime.h>

@interface AIFormatter ()
@end

@implementation AIFormatter

- (instancetype)initWithTemplate:(NSString *)template maskCharacter:(NSString *)mask stubCharacter:(NSString *)stub allowedCharacters:(NSCharacterSet *)allowed {
    if (self = [super init]) {
        self->_formatterTemplate = template;
        self->_allowedCharacters = allowed;
        self->_maskCharacter = mask;
        self->_stubCharacter = stub;
    }
    return self;
}

- (NSString *)formatString:(NSString *)string caretPosition:(UITextPosition **)caretPosition {

    NSString *adaptedString = nil;
    if (self.allowedCharacters) {
        adaptedString = [[string componentsSeparatedByCharactersInSet:[self.allowedCharacters invertedSet]] componentsJoinedByString:@""];
    }
    else {
        adaptedString = string;
    }

    NSString *formattedString = nil;
    if (self.formatterTemplate) {
        __block NSMutableString *mutableFormattedString = [NSMutableString string];
        __block NSUInteger adaptedStringIndex = 0;
        [self.formatterTemplate ai_enumerateCharactersUsingBlock:^(NSString * character, NSUInteger idx, bool *stop) {
            NSString *actualCharacter = nil;
            if (idx < string.length) {
                actualCharacter = [string substringWithRange:NSMakeRange(idx, 1)];
            }

            if ([character isEqualToString:self.maskCharacter]) {
                if (self.stubCharacter) {
                    [mutableFormattedString appendString:self.stubCharacter];
                }
                else if (adaptedStringIndex < adaptedString.length) {
                    [mutableFormattedString appendString:[adaptedString substringWithRange:NSMakeRange(adaptedStringIndex, 1)]];
                    adaptedStringIndex ++;
                }
            }
            else if ([actualCharacter isEqualToString:self.stubCharacter]) {
                [mutableFormattedString appendString:character];
            }

            else {
                [mutableFormattedString appendString:character];
            }
        }];
        formattedString = [mutableFormattedString copy];
    }
    else {
        formattedString = adaptedString;
    }

    return formattedString;
}

@end

@implementation UITextField (AIFormatter)

- (AITextFieldFormattingBehavoiur *)formattingBehavoiur {
    AITextFieldFormattingBehavoiur *existingBehaviour = [AITextFieldFormattingBehavoiur behaviourForView:self];
    if (existingBehaviour == nil) {
        AIFormatter *formatter = [[AIFormatter alloc] init];
        existingBehaviour = [[AITextFieldFormattingBehavoiur alloc] initWithFormatter:formatter];
        [self addBehaviour:existingBehaviour];
    }
    return existingBehaviour;
}

- (AIFormatter *)ai_formatter {
    return (id)self.formattingBehavoiur.formatter;
}

- (void)setOnlyNumbers:(BOOL)onlyNumbers {
    self.ai_formatter.allowedCharacters = [NSCharacterSet decimalDigitCharacterSet];
    objc_setAssociatedObject(self, @selector(onlyNumbers), @(onlyNumbers), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)onlyNumbers {
    return [objc_getAssociatedObject(self, @selector(onlyNumbers)) boolValue];
}

- (void)setFormatterTemplate:(NSString *)template {
    self.ai_formatter.formatterTemplate = template;
    objc_setAssociatedObject(self, @selector(formatterTemplate), template, OBJC_ASSOCIATION_COPY);
}

- (NSString *)formatterTemplate {
    return objc_getAssociatedObject(self, @selector(formatterTemplate));
}

- (void)setMaskCharacter:(NSString *)maskCharacter {
    NSParameterAssert(maskCharacter.length == 1);
    self.ai_formatter.maskCharacter = maskCharacter;
    objc_setAssociatedObject(self, @selector(maskCharacter), maskCharacter, OBJC_ASSOCIATION_COPY);
}

- (NSString *)maskCharacter {
    return objc_getAssociatedObject(self, @selector(maskCharacter));
}

- (void)setStubCharacter:(NSString *)stubCharacter {
    NSParameterAssert(stubCharacter.length == 1);
    self.ai_formatter.stubCharacter = stubCharacter;
    objc_setAssociatedObject(self, @selector(stubCharacter), stubCharacter, OBJC_ASSOCIATION_COPY);
}

- (NSString *)stubCharacter {
    return objc_getAssociatedObject(self, @selector(stubCharacter));
}

@end
