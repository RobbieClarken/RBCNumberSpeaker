//
//  RBCNumberSpeaker.h
//  RBCNumberSpeakerTests
//
//  Created by Robbie Clarken on 2/01/13.
//
//

#import <Foundation/Foundation.h>

@interface RBCNumberSpeaker : NSObject

+ (RBCNumberSpeaker *)sharedNumberSpeaker;
- (void)speakNumber:(NSUInteger)number;

@end
