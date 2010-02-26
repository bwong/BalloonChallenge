//
//  PlayerDatabase.m
//  BalloonChallenge
//
//  Created by Brian Wong on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerDatabase.h"
#import "Player.h"

@implementation PlayerDatabase

@synthesize playerArray;

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: playerArray forKey:@"playerArray"];    
}

- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
        self.playerArray = [decoder decodeObjectForKey:@"playerArray"];
    }
    return self;
}

- (id) init {
	if (self = [super init]) {
		playerArray = [[NSMutableArray alloc] init];
	}
	return self;
}

/* Add a quote with the specified data to the quote database.  */
- (void) addPlayer:(NSString *) newName
                withDifficultySettingAt:(int) newDifficulty
                andLevelSettingAt:(int) newLevel
                andHighscoreOf: (int) newHighscore {
	Player *newPlayer = [[Player alloc] initWithName:newName andDifficulty:newDifficulty andLevel:newLevel andHighscore:newHighscore];
	[playerArray addObject:newPlayer];
	[newPlayer release];
	
}

/* Returns the number of players in the database.  */
- (int) numPlayers {
	return [playerArray count];
}

/* Returns an array of players in the database.  */
- (NSMutableArray *) findAllPlayers {
    return playerArray;
}

- (void) dealloc {
	[playerArray release];
	[super dealloc];
}

@end