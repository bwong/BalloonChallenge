//
//  PlayerDatabase.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 2/23/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "Player.h"
#import "MathChallenge.h"
#import "HighScore.h"

enum PlayerOrdering {
	PlayerDBSortByName,
	PlayerDBSortByHighScore,
	PlayerDBSortByLevel
};

/* A Player Database represents a collection of players. */
@interface PlayerDatabase : NSObject <NSCoding>{
    NSMutableArray *playerArray;
}
@property (nonatomic, retain) NSMutableArray *playerArray;

// Add a player object to the database
- (void) addPlayerObj:(Player *) newPlayer;

// Returns number of players in the database
- (int) numPlayers;

// Check if a Player with the same name exists already
- (BOOL) isPlayerNameDuplicate: (NSString *) playerName;
- (BOOL) isExistingName: (NSString *) playerName;

// Remove a player the given name
- (void) removePlayerWithName: (NSString *) name;

// Find a player by the given name and return the player object
- (Player *) findPlayerWithName: (NSString *) name;

- (HighScore*) highScoreForTimeChallenge: (ChallengeGroupType) challengeType;

/* Returns an array of names of players.  */
- (NSMutableArray *) playerNames;

@end 
