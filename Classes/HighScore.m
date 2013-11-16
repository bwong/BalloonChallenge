//
//  HighScore.m
//  BalloonChallenge
//
//  Created by Kevin Weiler on 3/21/10.
//  Copyright 2010 klivin.com. All rights reserved.
//

#import "HighScore.h"


@implementation HighScore
@synthesize name;
@synthesize score;

/* Create a new quote with the specified data.  */
- (id) initWithName: (NSString *) newName
			andScore: (int) newScore {
	if (self = [super init]) {
		self.name = newName;
		self.score = newScore;
	}
	return self;
}

- (NSComparisonResult) compareByScore: (HighScore *) otherScore {
	if (score > [otherScore score])
		return NSOrderedAscending;
	if (score < [otherScore score])
		return NSOrderedDescending;
	return NSOrderedSame;
}

// encode the high score with this encoder function
- (void) encodeWithCoder:(NSCoder *) encoder {
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeInt:score forKey:@"score"];
}

// initialize the high score class with a coder
-(id) initWithCoder:(NSCoder *) decoder {
	if (self = [super init]) {
		self.score = [decoder decodeIntForKey:@"score"];
		self.name = [decoder decodeObjectForKey:@"name"];
	}
	return self;
}

@end
