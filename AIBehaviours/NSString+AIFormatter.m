//
//  NSString+AIFormatter.m
//  AIBehavioursExample
//
//  Created by Alex Bakhtin on 4/7/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import "NSString+AIFormatter.h"

@implementation NSString (AIFormatter)

- (void)ai_enumerateCharactersUsingBlock:(void (^)(NSString *character, NSUInteger idx, bool *stop))block {
    bool stop = NO;
    for(NSUInteger i = 0; i < self.length && !stop; i++) {
        NSString * character = [self substringWithRange:NSMakeRange(i, 1)];
        block(character, i, &stop);
    }
}

@end
