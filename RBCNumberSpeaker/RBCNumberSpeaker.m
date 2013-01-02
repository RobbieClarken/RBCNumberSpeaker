//
//  RBCNumberSpeaker.m
//  RBCNumberSpeakerTests
//
//  Created by Robbie Clarken on 2/01/13.
//
//

#import "RBCNumberSpeaker.h"
#import <AVFoundation/AVFoundation.h>

@interface RBCNumberSpeaker () <AVAudioPlayerDelegate> {
    BOOL playing;
}
@property (strong, nonatomic) AVAudioPlayer *player;
- (NSArray *)speakableComponentsQueueFromNumber:(NSUInteger)number;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
@property (strong, nonatomic) NSMutableArray *queue;
@end

@implementation RBCNumberSpeaker

+ (RBCNumberSpeaker *)sharedNumberSpeaker {
    static RBCNumberSpeaker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.queue = [NSMutableArray array];
    playing = NO;
    return self;
}

- (void)speakNumber:(NSUInteger)number {
    [self.queue addObjectsFromArray:[self speakableComponentsQueueFromNumber:number]];
    if (!playing) {
        playing = YES;
        [self playNextInQueue];
    }
}

#define kOneHundred  100
#define kOneThousand 1000
#define kTenThousand 10000
#define kOneMillion  1000000

- (NSArray *)speakableComponentsQueueFromNumber:(NSUInteger)number {
    NSMutableArray *array = [NSMutableArray array];
    if (number <= kOneHundred) {
        [array addObject:[NSString stringWithFormat:@"%u", number]];
        return array;
    }
    if (number <= kOneThousand && (number % kOneHundred) == 0) {
        [array addObject:[NSString stringWithFormat:@"%u", number]];
        return array;
    }
    if (number < kOneThousand) {
        NSUInteger firstComponent = number - (number % kOneHundred);
        [array addObject:[NSString stringWithFormat:@"%u", firstComponent]];
        [array addObjectsFromArray:[self speakableComponentsQueueFromNumber:(number - firstComponent)]];
        return array;
    }
    if (number <= kTenThousand && number % kOneThousand == 0) {
        [array addObject:[NSString stringWithFormat:@"%u", number]];
        return array;
    }
    if (number < kTenThousand) {
        NSUInteger firstComponent = number - (number % kOneThousand);
        [array addObject:[NSString stringWithFormat:@"%u", firstComponent]];
        [array addObjectsFromArray:[self speakableComponentsQueueFromNumber:(number - firstComponent)]];
        return array;
    }
    if (number < kOneMillion) {
        NSUInteger firstComponent = (NSUInteger)number/kOneThousand ;
        NSUInteger residual = number % kOneThousand;
        [array addObjectsFromArray:[self speakableComponentsQueueFromNumber:firstComponent]];
        [array addObject:@"thousand"];
        if (residual != 0) {
            [array addObjectsFromArray:[self speakableComponentsQueueFromNumber:residual]];
        }
        return array;
    }
    NSUInteger firstComponent = (NSUInteger)number/kOneMillion ;
    NSUInteger residual = number % kOneMillion;
    [array addObjectsFromArray:[self speakableComponentsQueueFromNumber:firstComponent]];
    [array addObject:@"million"];
    if (residual != 0) {
        [array addObjectsFromArray:[self speakableComponentsQueueFromNumber:residual]];
    }
    return array;
}

- (void)playNextInQueue {
    if ([self.queue count]) {
        NSString *basename = [self.queue objectAtIndex:0];
        [self.queue removeObjectAtIndex:0];
        NSString *path = [[NSBundle mainBundle] pathForResource:basename ofType:@"wav"];
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            NSURL *url = [NSURL fileURLWithPath:path];
            NSError *error = nil;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            self.player.delegate = self;
            self.player.volume = 1.0;
            if (error) {
                NSLog(@"Error playing %@: %@", basename, [error description]);
            }
            // TODO: Handler error
            [self.player play];
        } else {
            NSLog(@"%@ file doesn't exist", basename);
        }
    } else {
        [self.player stop];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        playing = NO;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self playNextInQueue];
}

@end
