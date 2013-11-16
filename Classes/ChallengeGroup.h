//
//  ChallengeGroup.h
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/11/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "MathChallenge.h"
#import "Level.h"

//unique id for ordering in lists
typedef enum {
	e_Game,
	e_Progression,
	e_Challenge	
} GroupType;

// a challenge group is a list of groups or challenges
@interface ChallengeGroup : NSObject {
	GroupType type;
	NSString *name;
	NSMutableArray *subgroups;
	BOOL isComplete;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic) GroupType type;
@property (nonatomic) BOOL isComplete;
@property (nonatomic,retain) NSMutableArray *subgroups;

+(id) groupWithName:(NSString *) myname 
		   withType:(GroupType) mytype;
+(id) groupWithName:(NSString *) myname 
		   withType:(GroupType) mytype 
	  withGroup:(NSMutableArray*) mysubgroups;

+(ChallengeGroup*) challengeWithLevel: (Level*) level;

@end
