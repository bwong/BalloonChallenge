//
//  GameState.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/28/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "GameState.h"


@implementation GameState
@synthesize isMuted;
@synthesize timePerChallenge;
@synthesize currentDifficulty;

- (id) init {
	return [self initWithNoSound:NO andTimePerChallenge:45];
}
	
- (id) initWithNoSound: (BOOL) muted
 andTimePerChallenge: (int) challengeTime {
	if (self = [super init]) {
		self.isMuted = muted;
		self.timePerChallenge = challengeTime;
	}
	return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.isMuted forKey:@"isMuted"];  
    [encoder encodeInt:self.timePerChallenge forKey:@"timePerChallenge"];  
	[encoder encodeInt:self.currentDifficulty forKey:@"currentDifficulty"];  

}

// Player decoder needed because we're are storing PlayerDatabase
// which is made up of Players
- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
		self.isMuted   = [decoder decodeIntForKey:@"isMuted"];
		self.timePerChallenge   = [decoder decodeIntForKey:@"timePerChallenge"];
		self.currentDifficulty   = [decoder decodeIntForKey:@"currentDifficulty"];
    }
    return self;
}


@end
