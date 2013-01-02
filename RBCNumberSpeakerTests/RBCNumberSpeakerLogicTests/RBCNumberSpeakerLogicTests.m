//
//  RBCNumberSpeakerLogicTests.m
//  RBCNumberSpeakerLogicTests
//
//  Created by Robbie Clarken on 2/01/13.
//
//

#import "RBCNumberSpeakerLogicTests.h"
#import "RBCNumberSpeaker.h"

@interface RBCNumberSpeaker()
@property (nonatomic, strong) NSMutableArray *queue;
- (NSArray *)speakableComponentsQueueFromNumber:(NSUInteger)number;
@end

@implementation RBCNumberSpeakerLogicTests

- (BOOL)arrayOfStrings:(NSArray *)arrayA isEqualTo:(NSArray *)arrayB {
    if ([arrayA count] != [arrayB count]) {
        return NO;
    }
    if ([arrayA count] == 0) {
        return YES;
    }
    for (NSUInteger i = 0; i < [arrayA count]; i++) {
        NSString *stringA = [arrayA objectAtIndex:i];
        NSString *stringB = [arrayB objectAtIndex:i];
        if (![stringA isEqualToString:stringB]) {
            return NO;
        }
    }
    return YES;
}

- (void)testEmptyQueue {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    STAssertTrue([speaker.queue count] == 0, @"Queue should be empty");
}

- (void)testSmallNumber {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:23] isEqualTo:@[@"23"]], @"Correctly decomposes numbers below 100.");
}

- (void)testMultiplesOfOneHundred {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:100] isEqualTo:@[@"100"]], @"Correctly decomposes 100.");
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:500] isEqualTo:@[@"500"]], @"Correctly decomposes 500.");
}

- (void)testNumbersLessThanOneThousand {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    NSArray *answer = @[@"100", @"23"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:123] isEqualTo:answer], @"Correctly decomposes 123.");
    answer = @[@"900", @"90"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:990] isEqualTo:answer], @"Correctly decomposes 990.");
}

- (void)testMultiplesOfOneThousand {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:1000] isEqualTo:@[@"1000"]], @"Correctly decomposes 1000.");
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:3000] isEqualTo:@[@"3000"]], @"Correctly decomposes 3000.");
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:10000] isEqualTo:@[@"10000"]], @"Correctly decomposes 10000.");
}

- (void)testNumbersLessThanTenThousand {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    NSArray *answer = @[@"7000", @"400", @"19"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:7419] isEqualTo:answer], @"Correctly decomposes 7419.");
    answer = @[@"6000", @"200"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:6200] isEqualTo:answer], @"Correctly decomposes 6200.");
}

- (void)testNumbersLessThanOneMillion {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    NSArray *answer = @[@"100", @"37", @"thousand", @"200", @"91"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:137291] isEqualTo:answer], @"Correctly decomposes 137291.");
}

- (void)testMultiplesOfOneMillion {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    NSArray *answer = @[@"1", @"million"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:1000000] isEqualTo:answer], @"Correctly decomposes one million.");
    answer = @[@"800", @"12", @"million"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:812000000] isEqualTo:answer], @"Correctly decomposes 812 million.");
}

- (void)testNumbersLargerThanOneMillion {
    RBCNumberSpeaker *speaker = [[RBCNumberSpeaker alloc] init];
    NSArray *answer = @[@"100", @"23", @"million", @"400", @"56", @"thousand", @"700", @"89"];
    STAssertTrue([self arrayOfStrings:[speaker speakableComponentsQueueFromNumber:123456789] isEqualTo:answer], @"Correctly decomposes 123456789.");
}

@end
