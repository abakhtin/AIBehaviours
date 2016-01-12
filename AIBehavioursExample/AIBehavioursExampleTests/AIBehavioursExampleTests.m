//
//  AIBehavioursExampleTests.m
//  AIBehavioursExampleTests
//
//  Created by Alex on 1/7/16.
//  Copyright © 2016 Alex Bakhtin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AITextFieldNumericFormatter.h"

@interface AIBehavioursExampleTests : XCTestCase
@property (nonatomic, strong) UITextField *textField;
@end

@implementation AIBehavioursExampleTests

- (void)setUp {
    [super setUp];
    self.textField.onlyNumbers = YES;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialFormatting {
    self.textField.text = @"1";
    NSAssert([self.textField.text isEqualToString:@"1"], @"Initial value test failed");
    
    self.textField.text = @"1A";
    NSAssert([self.textField.text isEqualToString:@"1"], @"Initial value test failed");

    self.textField.text = @"A1";
    NSAssert([self.textField.text isEqualToString:@"1"], @"Initial value test failed");

    self.textField.text = @"A1A";
    NSAssert([self.textField.text isEqualToString:@"1"], @"Initial value test failed");
    
    self.textField.text = @"A1A1A";
    NSAssert([self.textField.text isEqualToString:@"11"], @"Initial value test failed");
}

- (void)testCursorPositionSavingOnTextSetting {
    UITextRange *textRange = self.textField.selectedTextRange;
    self.textField.text = @"A1A1A";
    NSAssert([self.textField.text isEqualToString:@"11"], @"Initial value test failed");
}

- (void)testPerformanceExample {
    [self measureBlock:^{
    }];
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
    }
    return _textField;
}

@end
