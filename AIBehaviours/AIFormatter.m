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

- (NSString *)changeString:(NSString *)originalString range:(NSRange)range replacementString:(NSString *)replacementString adjustCursorIndex:(NSInteger *)adjustCursorIndex {
    NSString *formattedString = nil;
    __block NSInteger adjustIndex = 0;

    if (self.formatterTemplate) {
        NSString *resultString = [originalString stringByReplacingCharactersInRange:range withString:replacementString];
        NSString *adaptedResultString = resultString;
        if (self.allowedCharacters) {
            NSMutableCharacterSet *allowedCharactersAndStub = [self.allowedCharacters mutableCopy];
            [allowedCharactersAndStub addCharactersInString:self.stubCharacter];
            NSString *adaptedResultString = [[resultString componentsSeparatedByCharactersInSet:[allowedCharactersAndStub invertedSet]] componentsJoinedByString:@""];

            NSString *adaptedOriginal = [[originalString componentsSeparatedByCharactersInSet:[allowedCharactersAndStub invertedSet]] componentsJoinedByString:@""];
            adjustIndex += (adaptedResultString.length - adaptedOriginal.length);
        }

        __block NSUInteger maskIndex = 0;
        __block NSMutableString *mutableFormattedString = [NSMutableString string];

        [self.formatterTemplate ai_enumerateCharactersUsingBlock:^(NSString * character, NSUInteger idx, bool *stop) {
            if ([character isEqualToString:self.maskCharacter]) {
                if (maskIndex < adaptedResultString.length) {
                    [mutableFormattedString appendString:[adaptedResultString substringWithRange:NSMakeRange(maskIndex, 1)]];
                    maskIndex ++;
                }
                else if (self.stubCharacter) {
                    [mutableFormattedString appendString:self.stubCharacter];
                }
            }
            else {
                [mutableFormattedString appendString:character];
                if (range.location == idx && replacementString.length == 0) {
                    adjustIndex --;
                }
                else if (range.location == idx && replacementString.length > 0) {
                    adjustIndex ++;
                }
            }
        }];
        formattedString = [mutableFormattedString copy];
    }
    else if (self.allowedCharacters) {
        NSString *resultString = [originalString stringByReplacingCharactersInRange:range withString:replacementString];
        NSString *adaptedResultString = [[resultString componentsSeparatedByCharactersInSet:[self.allowedCharacters invertedSet]] componentsJoinedByString:@""];
        formattedString = adaptedResultString;
    }

    if (adjustIndex < 0) adjustIndex += range.length;

    if (adjustCursorIndex) *adjustCursorIndex = adjustIndex;
    return formattedString;
}

- (NSString *)enteredStringFromString:(NSString *)string {
    NSMutableString *enteredString = [NSMutableString string];
    __block NSUInteger spacesCounter = 0;
    [self.formatterTemplate ai_enumerateCharactersUsingBlock:^(NSString * templateCharacter, NSUInteger idx, bool *stop) {
        NSString *characterInString = [string ai_characterAtIndex:idx];
        if ([templateCharacter isEqualToString:self.maskCharacter] && characterInString && [characterInString isEqualToString:self.stubCharacter] == NO) {
            for (NSUInteger i = 0; i < spacesCounter; i++) [enteredString appendString:@" "];
            [enteredString appendString:characterInString];
        }
        else if ([templateCharacter isEqualToString:self.maskCharacter] && characterInString) {
            spacesCounter ++;
        }
    }];
    return enteredString;
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
