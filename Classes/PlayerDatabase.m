//
//  PlayerDatabase.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "PlayerDatabase.h"
#import "Player.h"
#import "TimeChallengeStats.h"

@implementation PlayerDatabase

static NSMutableArray *playerNames;

@synthesize playerArray;


// Protocol methods must be implemented inorder for the archiver to work
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: playerArray forKey:@"playerArray"];    
}

- (id) init {
    if ( self = [super init]) {
        self.playerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [super init]) {
        self.playerArray = [decoder decodeObjectForKey:@"playerArray"];
    }
    return self;
}

/* Add a player object into database.  */
- (void) addPlayerObj:(Player *) newPlayer {
	[self.playerArray addObject:newPlayer];
	//[self.playerNames addObject:newPlayer.name];
}

/* Returns the number of players in the database.  */
- (int) numPlayers {
	return [playerArray count];
}

/* Returns an array of players in the database.  */
- (NSMutableArray *) playerNames {
	playerNames = [[NSMutableArray alloc] initWithCapacity:[playerArray count]];
	[playerNames autorelease];
	NSArray *exampleNames = [[NSArray alloc] initWithObjects:@"Ace",@"Mathy",@"Wiz Kid",@"Boomer",@"Sum Fun",nil];
	for (Player *p in playerArray) {
		if ([exampleNames containsObject:p.name]) {
			continue;
		}
		[playerNames addObject:p.name];
	}
	[exampleNames release];
	return playerNames;
}

- (HighScore*) highScoreForTimeChallenge: (ChallengeGroupType) challengeType {
	HighScore *hs = [[[HighScore alloc] init] autorelease];
	int max = 0;
	for (Player *p in playerArray) {
		TimeChallengeStats *tcs = [p.currentStats.timeChallengeStats objectForKey:[NSNumber numberWithInt:challengeType]];
		if (tcs.highScore > max) {
			max = tcs.highScore;
			hs.name = p.name;
			hs.score = tcs.highScore;
		}
	}
	return hs;
}

// Find a player by the given name and return the player object
- (Player *) findPlayerWithName: (NSString *) name {
    for (Player *nextPlayer in self.playerArray )
    {
        if ( [name compare: [nextPlayer name]] == NSOrderedSame )
        {
            return nextPlayer;
        }
    }
    return nil;
}


// Check if a Player with the same name exists already
- (BOOL) isExistingName: (NSString *) playerName {
    BOOL isDuplicate = NO;
    for ( Player *nextPlayer in playerArray )
    {
        if ( [playerName compare: [nextPlayer name]] == NSOrderedSame )
        {
            isDuplicate = YES;
        }
    }
    return isDuplicate;
}

// Check if a Player with the same name exists already
- (BOOL) isPlayerNameDuplicate: (NSString *) playerName {
	int i = 0;
    for ( Player *nextPlayer in playerArray )
    {
        if ( [playerName compare: [nextPlayer name]] == NSOrderedSame )
			i++;
    }
	if (i>1)
		return YES;
    return NO;
}

// Remove a player the given name
- (void) removePlayerWithName: (NSString *) name {
    /* To avoid modifying the array while iterating through it, we'll collect
     all matches into another array.  */
	NSMutableArray *elementsToDelete = [[NSMutableArray alloc] init];
	for (Player *nextPlayer in playerArray) 
    {
		if ([name compare: [nextPlayer name]] == NSOrderedSame) {
			[elementsToDelete addObject:nextPlayer];
		}
	}
	
	[playerArray removeObjectsInArray:elementsToDelete];

	[elementsToDelete release];
}

- (void) dealloc {
	[playerArray release];
	[super dealloc];
}

@end