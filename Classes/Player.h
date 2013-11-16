//
//  Player.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/23/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "PlayerStats.h"
#import "MathChallenge.h"
#import <Foundation/Foundation.h>


@interface Player : NSObject <NSCoding, NSCopying> {
    NSString *name;
	PlayerStats *currentStats;
    Level *level;
}

@property (retain) PlayerStats *currentStats;
@property (retain) NSString *name;
@property (nonatomic,retain) Level *level;

- (id) initWithName: (NSString *) newName 
      andTimePlayed: (int) newTimedPlayed;

- (void) setPlayerName: (NSString*) myName
				 Level: (Level *) mylevel;

- (void) addPlayerStatsForTimeChallenge: (ChallengeGroupType) cType
							   andLevel:(unsigned int) lev
							andBalloons:(unsigned int) hits
								andTime:(unsigned int) timeElapsed
							   andCombo:(unsigned int) combo 
							   andScore:(unsigned int) score;
- (void) addPlayerStatsForLevel: (Level *) level
				  andDifficulty: (ChallengeDifficulty) difficulty
					 andCorrect: (unsigned int) correct
				   andIncorrect: (unsigned int) incorrect
						andTime: (unsigned int) seconds;

- (void) setPlayerLevel:(Level *)myLevel;
- (void) clearStats;
- (void) dealloc;

@end