//
//  GKitDemo_Tests.m
//  GKitDemo Tests
//
//  Created by Hua Cao on 13-11-6.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GCore.h"

@interface GCoreTests : XCTestCase

@end

@implementation GCoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMacros {
    //
    GPRINTSeparator(@"DEBUG");
    [self _testMacrosDebug];
    //
    GPRINTSeparator(@"UI");
    [self _testMacrosUI];
}

- (void)_testMacrosDebug {
    //
    GPRINT(@"%@", @"Hello World");
    
    //
    GPRINTMethodName();
    
    //
    NSError * error = [NSError errorWithDomain:@"TestDomain"
                                          code:0
                                      userInfo:@{@"String":@"TEST",
                                                 @"Number":@1.23,
                                                 @"Array":@[@"1",@"2",@"3"],
                                                 @"Date":[NSDate date]}];
    GPRINTError(error);
    
    //
    GASSERT(1==1);
    GASSERT(1==2);
}

- (void)_testMacrosUI {
}

@end