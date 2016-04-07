//
//  AITextFieldNumericFormatter.h
//  
//
//  Created by Alex on 1/4/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AITextFieldFormattingBehavoiur.h"

@interface AIFormatter : NSObject <AITextFieldFormatting>
- (instancetype)initWithTemplate:(NSString *)formattingTemplate maskCharacter:(NSString *)mask stubCharacter:(NSString *)stub allowedCharacters:(NSCharacterSet *)allowed;
@property (nonatomic, strong) NSCharacterSet *allowedCharacters;
@property (nonatomic, copy) NSString *formatterTemplate;
@property (nonatomic, copy) NSString *maskCharacter;
@property (nonatomic, copy) NSString *stubCharacter;
@end

@interface UITextField (AIFormatter)
@property (nonatomic, assign) IBInspectable BOOL onlyNumbers;
@property (nonatomic, copy) IBInspectable NSString *formatterTemplate;
@property (nonatomic, copy) IBInspectable NSString *maskCharacter;
@property (nonatomic, copy) IBInspectable NSString *stubCharacter;
@end
