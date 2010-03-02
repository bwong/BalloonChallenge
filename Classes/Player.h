//
//  Player.h
//  BalloonChallenge
//
//  Created by Brian Wong on 2/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Player : NSObject <NSCoding>{
    NSString *name;
    int difficulty;
    int level;
    int highscore;
}

@property (retain) NSString *name;
@property int difficulty;
@property int level;
@property int highscore;

/* Create a new player with the specified information.  */
- (id) initWithName: (NSString *) newName 
        andDifficulty: (int) newDifficulty
        andLevel: (int) newLevel
        andHighscore: (int) newHighscore;

/* Compare against another player alphabetically based on the player's
 name.  Performs a case-sensitive comparison.  */
- (NSComparisonResult) compareByName: (Player *) otherPlayer;

/* Compare against another player based on the highscore.  */
- (NSComparisonResult) compareByHighScore: (Player *) otherPlayer;

- (void) dealloc;

@end