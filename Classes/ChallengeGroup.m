//
//  ChallengeGroup.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/11/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "ChallengeGroup.h"
#import "GroupFactory.h"


@implementation ChallengeGroup
@synthesize name;
@synthesize type;
@synthesize subgroups;
@synthesize isComplete;


- (id) init {
	if (self = [super init]) {
		isComplete = NO;	
	}
	return self;
}

+(ChallengeGroup*) groupWithName:(NSString *) myname 
		   withType:(GroupType) mytype {
	ChallengeGroup *g = [[ChallengeGroup alloc] init];
	[g autorelease];
	g.name = myname;
	g.type = mytype;
	g.subgroups = nil;
	return g;
}

+(ChallengeGroup*) groupWithName:(NSString *) myname 
		   withType:(GroupType) mytype 
		  withGroup:(NSMutableArray*) mysubgroups {
	ChallengeGroup *g = [[ChallengeGroup alloc] init];
	[g autorelease];
	g.name = myname;
	g.type = mytype;
	g.subgroups = mysubgroups;
	return g;
}

+(ChallengeGroup*) challengeWithLevel: (Level*) level {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:level.game];
	ChallengeGroup* p = [[g subgroups] objectAtIndex:level.progression];
	ChallengeGroup* c = [[p subgroups] objectAtIndex:level.challenge];
	return c;
}

- (void) dealloc {
	[name release];
	[subgroups release];
	[super dealloc];
}

@end
