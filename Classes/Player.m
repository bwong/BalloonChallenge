//
//  Player.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "Player.h"
#import "TimeChallengeStats.h"


@implementation Player

@synthesize name;
@synthesize level;
@synthesize currentStats;



// Player encoder needed because we're are storing PlayerDatabase
// which is made up of Players
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: self.name forKey:@"name"];
    [encoder encodeObject:self.level forKey:@"level"];  
    [encoder encodeObject: self.currentStats forKey:@"currentStats"];
}

// Player decoder needed because we're are storing PlayerDatabase
// which is made up of Players
- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
		self.level   = [decoder decodeObjectForKey:@"level"];
		self.currentStats = [decoder decodeObjectForKey:@"currentStats"];
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone {
	Player *copy = [[[self class] allocWithZone:zone] init];
	copy.name = [self.name copyWithZone:zone];
	copy.level = self.level;
	copy.currentStats = self.currentStats;
	return copy;
}

- (void) setPlayerName: (NSString*) myName
				 Level: (Level*) mylevel {
	self.name = myName;
	self.level = mylevel;
}


/* Create a new plaer with the specified data.  */
- (id) initWithName: (NSString *) newName 
      andTimePlayed: (int) newTimedPlayed {
	if (self = [super init]) {
		self.currentStats = [[PlayerStats alloc] init];
		self.name = newName;
		self.currentStats.timePlayed = newTimedPlayed;
	}
	return self;	
}

- (void) setPlayerLevel:(Level*)myLevel {
	//if this is practice, just return
	if (myLevel.game==0)
		return;
	self.level = myLevel;
	Level *l = [currentStats.highestLevel valueForKey:[myLevel getGameName]];
	if ([myLevel compare:l]==NSOrderedAscending) {
		[currentStats.highestLevel setValue:myLevel forKey:[myLevel getGameName]];
	}
}
- (void) clearStats {
	
}

- (void) addPlayerStatsForTimeChallenge: (ChallengeGroupType) cType
							   andLevel:(unsigned int) lev
							andBalloons:(unsigned int) hits
								andTime:(unsigned int) timeElapsed
							   andCombo:(unsigned int) combo 
							   andScore:(unsigned int) score {
	TimeChallengeStats *currentTcs = [self.currentStats.timeChallengeStats objectForKey:[NSNumber numberWithInt:cType]];
	currentTcs.totalSecondsPlayed+=timeElapsed;
	
	if (lev > currentTcs.maxLevels) {
		currentTcs.maxLevels = lev;
	} 
	if (hits > currentTcs.maxNumBalloons) {
		currentTcs.maxNumBalloons = hits;
	} 
	if (timeElapsed > currentTcs.maxTimeSeconds) {
		currentTcs.maxTimeSeconds = timeElapsed;
	}
	if (combo > currentTcs.maxCombo) {
		currentTcs.maxCombo = combo;
	}
	if (score > currentTcs.highScore) {
		currentTcs.highScore = score;
	}
}

- (void) addPlayerStatsForLevel: (Level*) mylevel
				  andDifficulty: (ChallengeDifficulty) diff
					 andCorrect: (unsigned int) correct
				   andIncorrect: (unsigned int) incorrect
						andTime: (unsigned int) seconds {
	// if new stats are better than existing stats, add them for currentstats
	if ([currentStats percentForLevel:mylevel] <
		[NSNumber numberWithFloat:(correct/(correct+incorrect))*100]) {

		[self.currentStats.levelCorrectAnswers setObject:[NSNumber numberWithInt:correct] 
												  forKey:mylevel];
		[self.currentStats.levelIncorrectAnswers setObject:[NSNumber numberWithInt:incorrect] 
													forKey:mylevel];
	}
	
	if (diff > currentStats.highDifficulty) {
		currentStats.highDifficulty = diff;
		//set highest level if you are on new (higher) difficulty
	}
	// check if mylevel is 
	Level *l = [currentStats.highestLevel valueForKey:[mylevel getGameName]];
	if ([mylevel compare:l]==NSOrderedAscending) {
		[currentStats.highestLevel setValue:mylevel forKey:[mylevel getGameName]];
	}

	currentStats.timePlayed += seconds;
}

- (void) dealloc {
	[name release];
	[currentStats release];
	[level release];
	[super dealloc];
}

@end
