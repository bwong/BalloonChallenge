//
//  PlayerDatabase.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/* A Player Database represents a collection of players. */
@interface PlayerDatabase : NSObject <NSCoding>{
    NSMutableArray *playerArray;
}
@property (nonatomic, retain) NSMutableArray *playerArray;

- (id) init;

/* Add a quote to the database.  */
- (void) addPlayer:(NSString *) newName
		 withDifficultySettingAt:(int) newDifficulty
		 andLevelSettingAt:(int) newLevel
         andHighscoreOf: (int) newHighscore;

/* Returns number of players in the database.  */
- (int) numPlayers;

/* Returns an array of players.  */
- (NSMutableArray *) findAllPlayers;

@end 
