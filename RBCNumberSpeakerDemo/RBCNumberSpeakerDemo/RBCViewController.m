//
//  RBCViewController.m
//  RBCNumberSpeakerDemo
//
//  Created by Robbie Clarken on 2/01/13.
//  Copyright (c) 2013 Robbie Clarken. All rights reserved.
//

#import "RBCViewController.h"
#import "RBCNumberSpeaker.h"
#import <AVFoundation/AVFoundation.h>

@interface RBCViewController () {
    RBCNumberSpeaker *numberSpeaker;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation RBCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [self.textField becomeFirstResponder];
    numberSpeaker = [[RBCNumberSpeaker alloc] init];
}

- (IBAction)speakButtonPressed:(UIButton *)sender {
    if ([self.textField.text length] == 0) {
        return;
    }
    [numberSpeaker speakNumber:[self.textField.text intValue]];
}

@end
