//
//  ChallengeFactory.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathChallenge.h"
#import "Level.h"

@interface ChallengeFactory : NSObject {

}
+ (id) timeChallengeWithType: (ChallengeGroupType) challengeType;

+ (id) createChallengeByLevel: (Level*) level
				andDifficulty: (ChallengeDifficulty) difficulty;
+ (NSNumber *) getGivenFromString: (NSString*) str 
					 withLocation: (int)loc;

+ (NSNumber *) randomWithMin: (int) min andMax: (int) max;

@end
