//
//  PlayerStats.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/3/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "PlayerStats.h"
#import "ChallengeFactory.h"
#import "GroupFactory.h"
#import "TimeChallengeStats.h"


@implementation PlayerStats
@synthesize highestLevel, numLevels,numGames,levelCorrectAnswers, levelIncorrectAnswers, timePlayed, highDifficulty;
@synthesize difficultyLevels, timeChallengeStats;

- (id) init {
	if ( self = [super init]) {
		self.numLevels = [[GroupFactory challenges] count];
		self.numGames = [[GroupFactory games] count];
		self.timeChallengeStats = [[NSMutableDictionary alloc] initWithCapacity:e_ChallengeGroupTypeTotal];
		self.levelCorrectAnswers = [[NSMutableDictionary alloc] initWithCapacity:numLevels];
        self.levelIncorrectAnswers = [[NSMutableDictionary alloc] initWithCapacity:numLevels];
		self.highestLevel = [[NSMutableDictionary alloc] initWithCapacity:numGames];
		self.difficultyLevels = [[NSMutableArray alloc] initWithCapacity:3];
		[self clearStats];
	}
	return self;
}

- (void) clearStats {
	NSArray *levels = [[GroupFactory challenges] allKeys];
	[self.difficultyLevels removeAllObjects];
	for (int i=0; i<e_ChallengeGroupTypeTotal; i++) {
		[self.timeChallengeStats setObject:[TimeChallengeStats statsWithTime:0 andBalloons:0 andLevels:0 andScore:0 andCombo:0]
									forKey:[NSNumber numberWithInt:i]];
	}
	for (int i=0; i<numLevels; i++) {
		[self.levelCorrectAnswers setObject:[NSNumber numberWithInt:0] forKey:[levels objectAtIndex:i]];
		[self.levelIncorrectAnswers setObject:[NSNumber numberWithInt:0] forKey:[levels objectAtIndex:i]];
	}
	for (int i=0; i<3; i++) {
		[self.difficultyLevels insertObject:[NSNumber numberWithInt:0] atIndex:i];
	}	
	self.timePlayed = 0;
	for (int i=0; i<numGames; i++) {
		ChallengeGroup *g = [[GroupFactory games] objectAtIndex:i];
		[self.highestLevel setValue:[Level levelWithGame:i withProgression:0 withChallenge:0] forKey:g.name];
	}
}

- (void) clearStatsForGame: (int) gameId {
	NSArray *levels = [[GroupFactory challenges] allKeys];
	[self.difficultyLevels removeAllObjects];
	for (int i=0; i<numLevels; i++) {
		if ([[levels objectAtIndex:i] game] == gameId) {
			[self.levelCorrectAnswers setObject:[NSNumber numberWithInt:0] forKey:[levels objectAtIndex:i]];
			[self.levelIncorrectAnswers setObject:[NSNumber numberWithInt:0] forKey:[levels objectAtIndex:i]];
		}
	}
	for (int i=0; i<3; i++) {
		[self.difficultyLevels insertObject:[NSNumber numberWithInt:0] atIndex:i];
	}	
	//self.timePlayed = 0;
	ChallengeGroup *g = [[GroupFactory games] objectAtIndex:gameId];
	[self.highestLevel setValue:[Level levelWithGame:gameId withProgression:0 withChallenge:0] forKey:g.name];
	
}

- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
		self.numLevels = [[GroupFactory challenges] count];
		self.numGames = [[GroupFactory games] count];
        self.highDifficulty = [decoder decodeIntForKey:@"highDifficulty"];
        self.levelCorrectAnswers = [decoder decodeObjectForKey:@"levelCorrectAnswers"];
        self.levelIncorrectAnswers = [decoder decodeObjectForKey:@"levelIncorrectAnswers"];
        self.timePlayed = [decoder decodeIntForKey:@"timePlayed"];
        self.highestLevel = [decoder decodeObjectForKey:@"highestLevel"]; 
		self.timeChallengeStats = [decoder decodeObjectForKey:@"timeChallengeStats"];

	}
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt: highDifficulty forKey:@"highDifficulty"];  
    [encoder encodeObject:levelCorrectAnswers forKey:@"levelCorrectAnswers"];  
    [encoder encodeObject:levelIncorrectAnswers forKey:@"levelIncorrectAnswers"];  
    [encoder encodeInt:timePlayed forKey:@"timePlayed"];
    [encoder encodeObject:highestLevel forKey:@"highestLevel"];
    [encoder encodeObject:timeChallengeStats forKey:@"timeChallengeStats"];
}

- (id) copyWithZone:(NSZone *)zone {
	PlayerStats *copy = [[[self class] allocWithZone:zone] init];
	copy.highDifficulty = self.highDifficulty;
	copy.levelCorrectAnswers = [self.levelCorrectAnswers copyWithZone:zone];
	copy.levelIncorrectAnswers = [self.levelIncorrectAnswers copyWithZone:zone];
	copy.timePlayed = self.timePlayed;
	copy.highestLevel = self.highestLevel;
	copy.timeChallengeStats = self.timeChallengeStats;
	return copy;
}

- (GradeEnum) gradeForLevel: (Level *) level {
	int percent = [[self percentForLevel:level] intValue];
	if (percent >= 70 && percent < 80) {
		return e_GradeC;
	} else if (percent >= 80 && percent < 90) {
		return e_GradeB;
	} else if (percent >= 90 && percent <= 100) {
		return e_GradeA;
	} else if (percent == 100) {
		return e_GradeA;
	}
	return e_GradeIncomplete;
}

- (NSNumber *) percentForLevel: (Level *) level {
	float levelCorrect = [[self.levelCorrectAnswers objectForKey:level] floatValue];
	float levelIncorrect = [[self.levelIncorrectAnswers objectForKey:level] floatValue];
	if (levelCorrect == 0)
		return 0;
	return [NSNumber numberWithFloat:(levelCorrect/(levelCorrect+levelIncorrect))*100];	
}

- (void) dealloc {
	[levelCorrectAnswers release];
	[levelIncorrectAnswers release];
	[difficultyLevels release];
	[highestLevel release];
	[timeChallengeStats release];
	[super dealloc];
}

@end
