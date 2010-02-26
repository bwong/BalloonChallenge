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

- (void) dealloc;

@end