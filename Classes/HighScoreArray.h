//
//  HighScoreArray.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighScore.h"

#define kNumHighScores 5

@interface HighScoreArray: NSObject {
	NSMutableArray *highScores;
}

@property (nonatomic,retain) NSMutableArray *highScores;

- (void) addScore:(HighScore *) newScore;
- (void) addScore:(int) newScore
		 withName:(NSString*) newName;

- (BOOL) isHighScore: (int) newScore;
- (int) numPlayers;
- (void) removeLowestScore;

@end
