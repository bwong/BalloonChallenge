//
//  TimeChallengeStats.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 7/16/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "TimeChallengeStats.h"


@implementation TimeChallengeStats
@synthesize maxNumBalloons, maxTimeSeconds, maxLevels, totalSecondsPlayed, highScore, maxCombo;

- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
        self.maxTimeSeconds = [decoder decodeIntForKey:@"maxTimeSeconds"];
        self.maxNumBalloons = [decoder decodeIntForKey:@"maxNumBalloons"];
        self.maxLevels = [decoder decodeIntForKey:@"maxLevels"];
        self.totalSecondsPlayed = [decoder decodeIntForKey:@"totalSecondsPlayed"];
        self.highScore = [decoder decodeIntForKey:@"highScore"];
        self.maxCombo = [decoder decodeIntForKey:@"maxCombo"];
	}
    return self;
}

+(id) statsWithTime:(unsigned int) time
		andBalloons:(unsigned int) balloons 
		  andLevels:(unsigned int) levels
		   andScore:(unsigned int) score
		   andCombo:(unsigned int) combo {
	TimeChallengeStats *tcs = [[TimeChallengeStats alloc] init];
	[tcs autorelease];
	tcs.maxTimeSeconds = time;
	tcs.maxNumBalloons = balloons;
	tcs.maxLevels = levels;
	tcs.highScore = score;
	tcs.maxCombo = combo;
	return tcs;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt: maxTimeSeconds forKey:@"maxTimeSeconds"];  
    [encoder encodeInt: maxNumBalloons forKey:@"maxNumBalloons"];  
    [encoder encodeInt: maxLevels forKey:@"maxLevels"];  
    [encoder encodeInt: totalSecondsPlayed forKey:@"totalSecondsPlayed"];  
    [encoder encodeInt: highScore forKey:@"highScore"];  
    [encoder encodeInt: maxCombo forKey:@"maxCombo"];  

}

- (id) copyWithZone:(NSZone *)zone {
	TimeChallengeStats *copy = [[[self class] allocWithZone:zone] init];
	copy.maxLevels = self.maxLevels;
	copy.maxNumBalloons = self.maxNumBalloons;
	copy.maxTimeSeconds = self.maxTimeSeconds;
	copy.totalSecondsPlayed = self.totalSecondsPlayed;
	copy.highScore = self.highScore;
	copy.maxCombo = self.maxCombo;
	return copy;
}

@end
