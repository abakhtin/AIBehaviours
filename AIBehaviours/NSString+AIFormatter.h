//
//  NSString+AIFormatter.h
//  AIBehavioursExample
//
//  Created by Alex Bakhtin on 4/7/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AIFormatter)
- (void)ai_enumerateCharactersUsingBlock:(void (^)(NSString * character, NSUInteger idx, bool *stop))block;
@end
