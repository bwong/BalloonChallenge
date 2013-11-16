//
//  PlayerStats.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 4/3/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathChallenge.h"
#import "Level.h"

typedef enum {
	e_GradePerfect,
	e_GradeA,
	e_GradeB,
	e_GradeC,
	e_GradeIncomplete
} GradeEnum;

@interface PlayerStats : NSObject <NSCoding, NSCopying> {
	ChallengeDifficulty highDifficulty;
	unsigned int timePlayed;
	unsigned int numLevels;
	unsigned int numGames;
	NSMutableArray *difficultyLevels;
	
	//each game needs stats for the following
	/*however, each group will need to be tracked to a single id
	There is a master list of challenges...each of those challenges should have an id
	 this array will have a key value pair dictionary index = value
	*/
	//key - game name
	//value - level
	NSMutableDictionary *highestLevel;
	//key - level
	//value - NSNumber answer count
	NSMutableDictionary *levelCorrectAnswers;
	NSMutableDictionary *levelIncorrectAnswers;
	
	//key - challenge group type
	//value - time challenge stats
	NSMutableDictionary *timeChallengeStats;
}

@property (nonatomic) ChallengeDifficulty highDifficulty;
@property (nonatomic) unsigned int timePlayed;
@property (nonatomic,retain) NSMutableDictionary *highestLevel;
@property (nonatomic) unsigned int numLevels;
@property (nonatomic) unsigned int numGames;
@property (nonatomic, retain) NSMutableDictionary *levelCorrectAnswers;
@property (nonatomic, retain) NSMutableDictionary *levelIncorrectAnswers;
@property (nonatomic, retain) NSMutableDictionary *timeChallengeStats;
@property (nonatomic, retain) NSMutableArray *difficultyLevels;

- (NSNumber *) percentForLevel: (Level *) level;
- (GradeEnum) gradeForLevel: (Level *) level;

- (void) clearStats;

@end
