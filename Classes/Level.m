//
//  Level.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 5/17/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "Level.h"
#import "GroupFactory.h"


@implementation Level
@synthesize game, progression, challenge;

+ (id) levelWithGame: (int) g 
	 withProgression: (int) p 
	   withChallenge: (int) c {
	Level *l = [[Level alloc] init];
	l.game = g;
	l.progression = p;
	l.challenge = c;
	[l autorelease];
	return l;
}

- (NSComparisonResult) compare: (Level*) otherLevel {
	if (self.progression > otherLevel.progression || (self.challenge > otherLevel.challenge && self.progression >= otherLevel.progression))
		return NSOrderedAscending;
	if (self.progression < otherLevel.progression || (self.challenge < otherLevel.challenge && self.progression <= otherLevel.progression))
		return NSOrderedDescending;
	return NSOrderedSame;
}


- (id) initWithCoder: (NSCoder *) decoder {
    if ( self = [self init]) {
        self.game = [decoder decodeIntForKey:@"game"];
        self.progression = [decoder decodeIntForKey:@"progression"];
        self.challenge = [decoder decodeIntForKey:@"challenge"];
	}
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt: game forKey:@"game"];  
    [encoder encodeInt: progression forKey:@"progression"];  
    [encoder encodeInt: challenge forKey:@"challenge"];  
}

- (void) incrementLevel {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:self.game];
	ChallengeGroup* p = [[g subgroups] objectAtIndex:self.progression];
	if ( self.challenge < [[p subgroups] count] - 1 ) {
		self.challenge++;
	} else if ( self.progression < [[g subgroups] count] - 1 ) {
		//start next progression
		self.challenge=0;
		self.progression++;
	} else {
		//we are at highest level, dont do anything
	}
}

- (void) decrementLevel {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:self.game];
	if ( self.challenge > 0 ) {
		self.challenge--;
	} else if ( self.progression > 0 ) {
		//start next progression
		self.progression--;
		ChallengeGroup* p = [[g subgroups] objectAtIndex:self.progression];
		self.challenge=[[p subgroups] count] - 1;
	} else {
		//we are at lowest level
		self.challenge=0;
	}
}

- (NSString *) getGameName {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:self.game];
	return g.name;
}

- (NSString *) getProgressionName {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:self.game];
	ChallengeGroup* p = [[g subgroups] objectAtIndex:self.progression];
	return p.name;
}

- (NSString *) getChallengeName {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:self.game];
	ChallengeGroup* p = [[g subgroups] objectAtIndex:self.progression];
	ChallengeGroup* c = [[p subgroups] objectAtIndex:self.challenge];
	return c.name;
}

- (NSUInteger) hash {
	return (self.game << 16) + (self.progression << 8) + self.challenge;
}

- (BOOL)isEqual:(id)level {
	Level *l = level;
	unsigned int selfhash = (self.game << 16) + (self.progression << 8) + self.challenge;
	unsigned int comparehash = (l.game << 16) + (l.progression << 8) + l.challenge;
	return (selfhash == comparehash);
}

-(BOOL) isLastLevel: (int) gameId {
	ChallengeGroup* g = [[GroupFactory games] objectAtIndex:gameId];
	int lastProgressionId = [g.subgroups count] - 1;
	ChallengeGroup* p = [[g subgroups] objectAtIndex:lastProgressionId];
	return ((self.progression == lastProgressionId) && (self.challenge == [p.subgroups count]-1));
}

- (id) copyWithZone:(NSZone *)zone {
	Level *copy = [[[self class] allocWithZone:zone] init];
	copy.game = self.game;
	copy.progression = self.progression;
	copy.challenge = self.challenge;
	return copy;
}

@end
