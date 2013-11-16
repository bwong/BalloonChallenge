//
//  GameState.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/28/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "MathChallenge.h"

@interface GameState : NSObject {
	BOOL isMuted;
	int timePerChallenge;
	ChallengeDifficulty currentDifficulty;
}

@property (nonatomic) BOOL isMuted;
@property (nonatomic) int timePerChallenge;
@property ChallengeDifficulty currentDifficulty;

- (id) initWithNoSound: (BOOL) muted
   andTimePerChallenge: (int) challengeTime;

@end
