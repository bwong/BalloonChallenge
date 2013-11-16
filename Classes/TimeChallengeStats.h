//
//  TimeChallengeStats.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 7/16/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeChallengeStats : NSObject <NSCoding, NSCopying> {
	unsigned int maxNumBalloons;
	unsigned int maxTimeSeconds;
	unsigned int maxLevels;
	unsigned int totalSecondsPlayed;
	unsigned int highScore;
	unsigned int maxCombo;
	
}

@property (nonatomic) unsigned int maxNumBalloons;
@property (nonatomic) unsigned int maxTimeSeconds;
@property (nonatomic) unsigned int maxLevels;
@property (nonatomic) unsigned int totalSecondsPlayed;
@property (nonatomic) unsigned int highScore;
@property (nonatomic) unsigned int maxCombo;

+(id) statsWithTime:(unsigned int) time
		andBalloons:(unsigned int) balloons 
		  andLevels:(unsigned int) levels
		   andScore:(unsigned int) score
		   andCombo:(unsigned int)combo;

@end
