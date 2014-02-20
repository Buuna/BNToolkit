//
//  BNTestTest.m
//  BNToolkit
//
//  Created by William Qi on 20/02/2014.
//  Copyright (c) 2014 Buuna Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "BNUtil.h"

@interface BNUtilTest : XCTestCase

@end

@implementation BNUtilTest
static const int loopRandomCases = 5000;
- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testRandomDoubles
{
    const double maxDouble = 50.;
    for(int i = 0; i < loopRandomCases; ++i){
        expect(BNRandDouble(maxDouble)).beInTheRangeOf(0., 50.);
    }
}

-(void)testRandomInts{
    const int maxInt = 75;
    for(int i = 0; i < loopRandomCases; ++i){
        expect(BNRandInt(maxInt)).beInTheRangeOf(0, 75);
    }
}

-(void)testRandomNumberDifferentFromNumber{
    const int existing = 424;
    for(int i = 0; i < loopRandomCases; ++i){
        expect(BNRandomNumberDifferentFromNumber(500, existing) == existing).beFalsy();
    }
}

-(void)testArrayRemoveLastObject{
    NSArray * testArray = @[@5, @6, @7, @9, @10];
    NSArray * resultArray = BNArrayArrayByRemovingLastObject(testArray);
    
    expect(resultArray.count).equal(testArray.count - 1);
    expect(resultArray.lastObject).equal(@9);
    
    NSMutableArray * largerArray = [NSMutableArray new];
    for (int i = 0; i < loopRandomCases; i++) {
        [largerArray addObject:@(BNRandInt(100000))];
    }
    NSArray * resultLargerArray = BNArrayArrayByRemovingLastObject(largerArray);
    expect(resultLargerArray.count).equal(largerArray.count - 1);
    expect(resultLargerArray.lastObject).equal(largerArray[largerArray.count - 2]);
}

-(void)testBNArrayIndexOfBestObject{
    NSArray * testArray = @[@2, @7, @1, @9, @9, @6, @23, @7, @12];
    NSComparator comparator = ^NSComparisonResult (id obj1, id obj2){
        int num1 = [obj1 intValue];
        int num2 = [obj2 intValue];
        
        if(num1 < num2) return NSOrderedAscending;
        if(num1 > num2) return NSOrderedDescending;
        
        return NSOrderedSame;
    };
    
    NSUInteger largestNumberIndex = BNArrayIndexOfBestObjectUsingComparator(testArray, comparator);
    
    expect(largestNumberIndex).equal(6);
}

-(void) testStringByRemovingCharactersInSet{
    NSString * string = @"vawenveariobvjnmawocnmwawpoaekcfopwjamkzcz,;aqojfw";
    NSCharacterSet * set = [NSCharacterSet lowercaseLetterCharacterSet];
    NSString * resulting = BNStringStringByRemovingCharactersInSet(string, set);
    
    expect(resulting).equal(@",;");
}

-(void) testRemovingLeadingAndTrailingSpacesEmpty{
    NSString * empty = @"                   ";
    NSString * notEmpty = @"  sadas   ";
    NSString * noSpaces = @"mlckakcla";
    NSString * leadSpaces = @"    adjadad";
    NSString * trailingSpaces= @"asadsad  ";
    NSString * singleSpaces = @" ";
    
    expect(BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(empty)).beTruthy();
    expect(BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(notEmpty)).beFalsy();
    expect(BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(noSpaces)).beFalsy();
    expect(BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(leadSpaces)).beFalsy();
    expect(BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(trailingSpaces)).beFalsy();
    expect(BNStringIsStringByRemovingLeadingAndTrailingSpacesEmpty(singleSpaces)).beTruthy();
}

-(void) testRemoveSuffixes{
    NSString * full = @"greatest";
    NSString * suffix = @"est";
    NSString * fullDualSuffixCase = @"greatestest";
    NSString * suffixNotPresent = @"asda";
    
    expect(BNStringByRemovingSuffix(full, suffix)).equal(@"great");
    expect(BNStringByRemovingSuffix(full, fullDualSuffixCase)).equal(@"greatest");
    expect(BNStringByRemovingSuffix(full, suffixNotPresent)).equal(@"greatest");
}

-(void) testValidEmail{
    NSString * valid = @"example@example.com";
    NSString * invalid = @"exampleexample.com";
    NSString * invalid2 = @"example@examplecom";
    NSString * typo = @"example@example..com";
    NSString * typo2 = @"example@example.";
    
    expect(BNStringIsValidEmail(valid)).beTruthy();
    expect(BNStringIsValidEmail(invalid)).beFalsy();
    expect(BNStringIsValidEmail(invalid2)).beFalsy();
    expect(BNStringIsValidEmail(typo)).beFalsy();
    expect(BNStringIsValidEmail(typo2)).beFalsy();
    
}

-(void) testUUID{
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"\\A[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}\\Z"
                                              options:NSRegularExpressionAnchorsMatchLines
                                                error:nil];
    NSString * uuid = BNUUID();
    NSLog(uuid);
    
    NSUInteger matches = [regex numberOfMatchesInString:uuid options:0 range:NSMakeRange(0, [uuid length])];
    
    expect(matches).equal(1);
}
@end
